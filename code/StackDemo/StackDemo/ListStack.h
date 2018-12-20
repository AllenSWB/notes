//
//  ListStack.h
//  StackDemo
//
//  Created by wenbo.sun on 2018/12/19.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Node : NSObject

@property (nonatomic, assign) id value;
@property (nonatomic, strong) Node *next;

@end

@interface ListStack : NSObject

- (BOOL)push:(id)value;

- (id)pop;

- (id)peek;

@end

NS_ASSUME_NONNULL_END
