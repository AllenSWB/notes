//
//  ListStack.m
//  StackDemo
//
//  Created by wenbo.sun on 2018/12/19.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "ListStack.h"

@implementation Node

- (instancetype)initWithValue:(id)value {
    self = [super init];
    if (self) {
        self.value = value;
    }
    return self;
}

@end

@interface ListStack ()

@property (nonatomic, strong) Node *top;

@end

@implementation ListStack

- (BOOL)isEmpty {
    return self.top == nil;
}

- (BOOL)push:(id)value {
    Node *newTop = [[Node alloc] initWithValue:value];
    newTop.next = self.top;
    self.top = newTop;
    return YES;
}

- (id)pop {
    if ([self isEmpty]) {
        return nil;// stack为空
    }
    id value = self.top.value;
    self.top = self.top.next;
    return value;
}

- (id)peek {
    if ([self isEmpty]) {
        return nil;// stack为空
    }
    id value = self.top.value;
    return value;
}
@end
