//
//  ViewController.m
//  racDemo20191120
//
//  Created by wb on 2019/11/20.
//  Copyright © 2019 ucar. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>

@interface ViewController ()
@property (nonatomic, strong) NSString *name;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // 冷信号 eg:
//    RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        // 触发信号
//        [subscriber sendNext:@"hahaha"];
//        [subscriber sendNext:@"hahahaee3"];
//        [subscriber sendCompleted];
//
//        return nil;
//    }] replay];
//
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"订阅 %@",x);
//    }];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [signal subscribeNext:^(id  _Nullable x) {
//               NSLog(@"新的订阅者 %@",x);
//        }];
//    });
    
    
    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveMethod)(int);
        RecursiveMethod = ^(int value) {
            [lock lock];
            if (value > 0) {
                NSLog(@"value = %d", value);
                sleep(2);
                RecursiveMethod(value - 1); // 递归的调用了这个block，上次的还没解锁，所以它需要等待锁被解除，这样就导致了死锁，线程被阻塞住了。
            }
            [lock unlock];
        };
        RecursiveMethod(5);
    });
    
    
    RACObserve(<#TARGET#>, <#KEYPATH#>)
}


@end
