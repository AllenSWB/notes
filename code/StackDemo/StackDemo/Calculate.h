//
//  Calculate.h
//  StackDemo
//
//  Created by wenbo.sun on 2018/12/19.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Calculate : NSObject

+ (instancetype)sharedCalculate;

/**
 * 表达式计算结果
 * expression: 一个加减乘除的表达式 eg: 2 * 2 - 10 + 3 / 1 * 8
 */
- (NSNumber *)calculateWithExpression:(NSString *)expression;

@end

NS_ASSUME_NONNULL_END
