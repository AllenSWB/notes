//
//  NSArray+WBAdd.m
//  UcarShare
//
//  Created by wenbo.sun on 2018/10/23.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "NSArray+WBAdd.h"

@implementation NSArray (WBAdd)

- (id)wb_objectOrNilAtIndex:(NSUInteger)index {
    if (self.count <= index) {
        return nil;
    }
    id obj = [self objectAtIndex:index];
    if ([obj isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return obj;
}

@end
