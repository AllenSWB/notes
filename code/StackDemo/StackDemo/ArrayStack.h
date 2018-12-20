//
//  ArrayStack.h
//  StackDemo
//
//  Created by wenbo.sun on 2018/12/19.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArrayStack : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) NSMutableArray *items;

/// 入栈
- (BOOL)push:(id)item;
/// 出栈
- (id)pop;

@end

NS_ASSUME_NONNULL_END
