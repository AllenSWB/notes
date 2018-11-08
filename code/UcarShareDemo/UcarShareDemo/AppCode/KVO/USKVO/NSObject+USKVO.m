//
//  NSObject+USKVO.m
//  UcarShareDemo
//
//  Created by wenbo.sun on 2018/11/6.
//  Copyright © 2018 wenbo.sun. All rights reserved.
//

#import "NSObject+USKVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

/**
 储存KVO需要的一些信息
 */
@interface USKVOItem : NSObject

@property (nonatomic, weak) id observer;

@property (nonatomic, strong) NSString *keyPath;

@property (nonatomic, copy  ) USKVONotificationBlock notificationBlock;

- (instancetype)initWithObserver:(id)observer keyPath:(NSString *)keyPath notiBlock:(USKVONotificationBlock)notiBlock;

@end

@implementation USKVOItem

- (instancetype)initWithObserver:(id)observer keyPath:(NSString *)keyPath notiBlock:(USKVONotificationBlock)notiBlock {
    self = [super init];
    if (self) {
        self.observer = observer;
        self.keyPath = keyPath;
        self.notificationBlock = notiBlock;
    }
    return self;
}

@end

/**
 给NSObject增加一个属性，用于存储所有的KVO
 */
@interface NSObject (USKVOAdd)

@property (nonatomic, strong) NSArray *us_KVOItems;

@end

static NSString *us_KVOItemsKey = @"us_KVOItemsKey";

@implementation NSObject (USKVOAdd)

- (void)setUs_KVOItems:(NSArray *)us_KVOItems {
    objc_setAssociatedObject(self, &us_KVOItemsKey, us_KVOItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)us_KVOItems {
    return objc_getAssociatedObject(self, &us_KVOItemsKey);
}

@end

static const NSString *USKVOClassPrefix = @"USKVONotifying_";

@implementation NSObject (USKVO)

#pragma mark - public

- (void)us_addObserver:(id)observer forKeyPath:(SEL)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context kvoNotiBlock:(USKVONotificationBlock)kvoNotiBlcok {

    // 1. 查找对应属性是否存在setter方法，不存在直接crash
    NSString *setterName = [self _setterNameWithGetter:keyPath];
    SEL setterSelector = NSSelectorFromString(setterName);
    Method originalMethod = class_getInstanceMethod(object_getClass(self), setterSelector);
    if (!originalMethod) {// 属性没有setter方法
        NSString *exceptionDesc = [NSString stringWithFormat:@"类%@中没找到%@的setter方法", NSStringFromClass([self class]), NSStringFromSelector(keyPath)];
        NSException *exception = [NSException exceptionWithName:@"NotExistKeyExceptionName" reason:exceptionDesc userInfo:nil];
        [exception raise];
    }

    
    // 2. 生成KVO类
    Class kvoClass = [self _usKVOClassWithName:NSStringFromClass([self class])];
    // 修改被观察者的isa指针,指向自定义的类
    object_setClass(self, kvoClass);
    
    //3. setter方法
    if (![self _usHaveMethodWithKeyPath:setterSelector]) {
        class_addMethod(kvoClass, setterSelector, (IMP)us_kvoClassSetter, method_getTypeEncoding(originalMethod));
    }
    
    // 4. 存储KVO信息
    USKVOItem *item = [[USKVOItem alloc] initWithObserver:observer keyPath:NSStringFromSelector(keyPath) notiBlock:kvoNotiBlcok];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:[self us_KVOItems]];
    if (!temp) {
        temp = [NSMutableArray arrayWithCapacity:0];
    }
    [temp addObject:item];
    self.us_KVOItems = [temp mutableCopy];
}

- (void)us_removeObserver:(id)observer forKeyPath:(SEL)keyPath {
    NSMutableArray *temp = [NSMutableArray arrayWithArray:[self us_KVOItems]];
    [self.us_KVOItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        USKVOItem *item = (USKVOItem *)obj;
        SEL selector = NSSelectorFromString(item.keyPath);
        if (item.observer == observer && selector == keyPath) {
            [temp removeObject:item];
        }
    }];
    self.us_KVOItems = [temp mutableCopy];
}

#pragma mark - private

/// 获取setter方法名
- (NSString *)_setterNameWithGetter:(SEL)getter {
    NSString *getterName = NSStringFromSelector(getter);
    NSString *firstChar = [[getterName substringToIndex:1] uppercaseString];
    NSString *setterName = [NSString stringWithFormat:@"set%@%@:", firstChar, [getterName substringFromIndex:1]];
    return setterName;
}

/// 获取getter方法名
- (NSString *)_getterNameWithSetter:(SEL)setter {
    NSString *setterName = NSStringFromSelector(setter);
    if (![setterName hasPrefix:@"set"]) {
        return nil;
    }
    NSString *getterString = [setterName substringWithRange:NSMakeRange(4, setterName.length - 5)];
    NSString *firstString = [[setterName substringWithRange:NSMakeRange(3, 1)] lowercaseString];
    getterString = [NSString stringWithFormat:@"%@%@", firstString, getterString];
    return getterString;
}

- (BOOL)_usHaveMethodWithKeyPath:(SEL)keyPath {
    NSString *setterName = NSStringFromSelector(keyPath);
    unsigned int count;
    Method *methodList = class_copyMethodList(object_getClass(self), &count);
    for (NSInteger i = 0; i < count; i++) {
        Method method = methodList[i];
        NSString *methodName = NSStringFromSelector(method_getName(method));
        if ([methodName isEqualToString:setterName]) {
            return YES;
        }
    }
    return NO;
}

/// 生成KVO子类
- (Class)_usKVOClassWithName:(NSString *)name {
    NSString *kvoClassName = [NSString stringWithFormat:@"%@%@", USKVOClassPrefix, name];
    Class kvoClass = objc_getClass(kvoClassName.UTF8String);
    // 已经存在kvoClass 直接返回
    if (kvoClass) {
        return kvoClass;
    }
    
    // 创建kvoClass
    kvoClass = objc_allocateClassPair(object_getClass(self), kvoClassName.UTF8String, 0);
    
    // 重写kvoClass的class方法 返回父类Class
    const char *types = NSStringFromSelector(@selector(class)).UTF8String;
    class_addMethod(kvoClass, @selector(class), (IMP)us_kvoClassMethod, types);
    return kvoClass;
}

/// 重写class方法，返回父类Class
static Class us_kvoClassMethod(id self, SEL selector) {
    return class_getSuperclass(object_getClass(self));
}

// 重写setter方法
static void us_kvoClassSetter(id self, SEL selector, id value) {
    
    // 1.获取旧值。
    id (*getterMsgSend) (id, SEL) = (void *)objc_msgSend;
    NSString *getterName = [self _getterNameWithSetter:selector];
    SEL getterSelector = NSSelectorFromString(getterName);
    id oldValue = getterMsgSend(self, getterSelector);
    
    // 2.创建super的结构体，并向super发送属性的消息。
    id (*msgSendSuper) (void *, SEL, id) = (void *)objc_msgSendSuper;
    struct objc_super objcSuper = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    msgSendSuper(&objcSuper, selector, value);
    
    // 3. 遍历调用block。
    NSMutableArray *temp = [NSMutableArray arrayWithArray:[self us_KVOItems]];
    [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        USKVOItem *item = (USKVOItem *)obj;
        if ([item.keyPath isEqualToString:getterName] && item.notificationBlock) {
            item.notificationBlock(self, NSStringFromSelector(selector), oldValue, value);
        }
    }];
}

@end
