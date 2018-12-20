//
//  Calculate.m
//  StackDemo
//
//  Created by wenbo.sun on 2018/12/19.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "Calculate.h"
#import "ArrayStack.h"
#import "ListStack.h"

@interface Calculate () {
    /// 操作符优先级
    NSDictionary *_operationPriorityDic;
    NSNumberFormatter *_numFormatter;
}

/// 操作符栈
@property (nonatomic, strong) ListStack *optStack;
/// 操作数栈
@property (nonatomic, strong) ListStack *numStack;

@end

@implementation Calculate

+ (instancetype)sharedCalculate {
    static Calculate *calculate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calculate = [[Calculate alloc] init];
    });
    return calculate;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _operationPriorityDic = @{
                                  @"+": @0,
                                  @"-": @0,
                                  @"*": @1,
                                  @"/": @1
                                  };
        _numFormatter = [[NSNumberFormatter alloc] init];
    }
    return self;
}

- (NSNumber *)calculateWithExpression:(NSString *)expression {
    
    NSArray *tempArray = [expression componentsSeparatedByString:@" "];
    for (NSString *obj in tempArray) {
        NSNumber *tempNum = [_numFormatter numberFromString:obj];
        if (tempNum) {
            [self.numStack push:tempNum];
        } else {
            
            // 如果栈顶操作符优先级大于等于当前的操作符
            while ([self _topOperationPriorityIsHigherOrEqualToOperation:obj]) {
                // 取出栈顶操作符和两个操作数运算一次
                NSNumber *result = [self _excuteOnceCaculate];
                // 将结果压入栈
                [_numStack push:result];
            }
            [_optStack push:obj];
        }
    }
    
    NSNumber *result;
    while ([self.optStack peek]) {
        result = [self _excuteOnceCaculate];
        [self.numStack push:result];
    }
    return result;
}

- (BOOL)_topOperationPriorityIsHigherOrEqualToOperation:(NSString *)opt {
    NSString *topOpt = [self.optStack peek];
    if (!topOpt) {
        return NO;
    }
    NSInteger currentPriority = [self _getPriority:opt];
    NSInteger topPriority = [self _getPriority:topOpt];
    return currentPriority <= topPriority;
}

- (NSInteger)_getPriority:(NSString *)opt {
    return [[_operationPriorityDic objectForKey:opt] integerValue];
}

- (NSNumber *)_excuteOnceCaculate {
    NSNumber *numRight = [_numStack pop];
    NSNumber *numLeft = [_numStack pop];
    NSString *topOpt = [_optStack pop];
    NSInteger result = [self _caculeteWithNumberLeft:numLeft numberRight:numRight operation:topOpt];
    NSNumber *res = [NSNumber numberWithInteger:result];
    return res;
}

- (NSInteger)_caculeteWithNumberLeft:(NSNumber *)numLeft numberRight:(NSNumber *)numRight operation:(NSString *)opt {
    if (!numLeft || !numRight || !opt) return 0;
    NSInteger left = [numLeft integerValue];
    NSInteger right = [numRight integerValue];
    if ([opt isEqualToString:@"+"]) {
        return left + right;
    } else if ([opt isEqualToString:@"-"]) {
        return left - right;
    } else if ([opt isEqualToString:@"*"]) {
        return left * right;
    } else if ([opt isEqualToString:@"/"]) {
        return left / right;
    } else {
        return 0;
    }
}
#pragma mark - lazy

- (ListStack *)optStack {
    if (!_optStack) {
        _optStack = [[ListStack alloc] init];
    }
    return _optStack;
}

- (ListStack *)numStack {
    if (!_numStack) {
        _numStack = [[ListStack alloc] init];
    }
    return _numStack;
}
@end
