//
//  ArrayStack.m
//  StackDemo
//
//  Created by wenbo.sun on 2018/12/19.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "ArrayStack.h"

@implementation ArrayStack

- (instancetype)initWithSize:(NSInteger)size {
    self = [super init];
    if (self) {
        self.size = size;
        self.count = 0;
        self.items = [NSMutableArray arrayWithCapacity:size];
    }
    return self;
}

- (BOOL)push:(id)item {
    if (!item) {
        return NO;
    }
    if (self.count >= self.size) {
        return NO;//空间不够用了，入栈失败
    }
    [self.items addObject:item];
    self.count += 1;
    return YES;
}

- (id)pop {
    if (self.count == 0) {
        return nil;//已经是空栈了。
    }
    id tempItem = self.items.lastObject;
    [self.items removeObject:tempItem];
    self.count -= 1;
    return tempItem;
}

@end
