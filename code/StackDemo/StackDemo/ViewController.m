//
//  ViewController.m
//  StackDemo
//
//  Created by wenbo.sun on 2018/12/18.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "ViewController.h"
#import "ArrayStack.h" 
#import "ListStack.h"
#import "Calculate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNumber *result = [[Calculate sharedCalculate] calculateWithExpression:@"2 * 2 - 10 + 3 / 1 * 8"];
    NSLog(@"结果是 %@",result);// 18
    
    NSInteger i = 3;
//    [self testMethod:@"fsd"];
    
    NSCAssert(i < 3, @"你这不行，笑了");
}

- (void)testMethod:(id)para {
    NSParameterAssert(para);
    NSLog(@"过啦 哈哈哈哈哈");
}

@end
                                                                                                                                                                                                                                                                                                                                                                                                                                                         
