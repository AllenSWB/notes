//
//  USTestCar.m
//  UcarShareDemo
//
//  Created by wenbo.sun on 2018/11/5.
//  Copyright © 2018 wenbo.sun. All rights reserved.
//

#import "USTestCar.h"
#import <objc/runtime.h>

@implementation USTestCar

- (NSString *)description {
    
    NSLog(@"obj is %p \n",self);
    
    IMP carNameIMP = class_getMethodImplementation(object_getClass(self), @selector(setCarName:));
    NSLog(@"IMP setCarName is %p \n",carNameIMP);

    Class objClass = [self class];
    NSLog(@"obj class is %@ \n", objClass);
    
    Class objRuntimeClass = object_getClass(self);
    NSLog(@"obj runtime class is %@ \n", objRuntimeClass);

    NSLog(@"obj method list is: \n");
    unsigned int count;
    Method *methodList = class_copyMethodList(objRuntimeClass, &count);
    for (NSInteger i = 0; i < count; i++) {
        Method method = methodList[i];
        NSString *methodName = NSStringFromSelector(method_getName(method));
        NSLog(@"method%ld = %@ \n", (long)i, methodName);
    }
    
    NSLog(@"\n");
    
    return @"";
}

@end
