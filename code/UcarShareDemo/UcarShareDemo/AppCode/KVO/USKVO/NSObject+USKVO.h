//
//  NSObject+USKVO.h
//  UcarShareDemo
//
//  Created by wenbo.sun on 2018/11/6.
//  Copyright © 2018 wenbo.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^USKVONotificationBlock)(id observer, NSString *keyPath, id oldValue, id newValue);

@interface NSObject (USKVO)

/**
 注册监听者
 
 @param observer 监听者
 @param keyPath 属性getter方法 . 这里不用字符串，是为了防止不小心拼错字母
 @param options 监听策略
 @param context 传参
 @param kvoNotiBlcok 监听回调
 */
- (void)us_addObserver:(id)observer forKeyPath:(SEL)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context kvoNotiBlock:(USKVONotificationBlock)kvoNotiBlcok;
/**
 移除监听者
 
 @param observer 监听者
 @param keyPath 属性getter方法
 */
- (void)us_removeObserver:(id)observer forKeyPath:(SEL)keyPath;


@end
