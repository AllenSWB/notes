//
//  TheTimerManager.m
//  UcarShareDemo
//
//  Created by wenbo.sun on 2018/11/7.
//  Copyright © 2018 wenbo.sun. All rights reserved.
//

#import "TheTimerManager.h"

@implementation TheTimerManager

+ (instancetype)sharedTheTimerManager {
    static TheTimerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TheTimerManager alloc] init];
    });
    return manager;
}

@end
