//
//  USKVODemoController.m
//  UcarShareDemo
//
//  Created by wenbo.sun on 2018/11/5.
//  Copyright © 2018 wenbo.sun. All rights reserved.
//

#import "USKVODemoController.h"
#import "USTestCar.h"
#import <KVOController.h>
#import "USKVO.h"

@interface USKVODemoController ()

@property (nonatomic, strong) USTestCar *car;
@property (nonatomic, strong) FBKVOController *kvoController;

@end

@implementation USKVODemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KVO";
    
    self.car = [[USTestCar alloc] init];
    self.car.carName = @"本田CR-V";
    
    // 方式一：系统KVO
//    [self systemKVO];
    
    // 方式二：KVOController
//    [self fb_KVO];
    
    // 方式三：US KVO
    [self us_KVO];
    
    // 触发KVO
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.car.carName = @"丰田FJ";
    });
    
    // 手动触发KVO
//    [self.car willChangeValueForKey:@"carName"];
//    [self.car didChangeValueForKey:@"carName"]; 
}


#pragma mark - 系统KVO

//- (void)systemKVO {
//    [self.car description];
//    [self.car addObserver:self forKeyPath:@"carName" options:(NSKeyValueObservingOptionNew) context:@"我想传啥就传啥 nil也行"];
//    [self.car description];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if ([object isKindOfClass:[USTestCar class]]) {
//        USTestCar *obj = (USTestCar *)object;
//        NSLog(@"【系统KVO】 %@",obj.carName);
//    }
//}
//
//- (void)dealloc {
//    [self.car removeObserver:self forKeyPath:@"carName"];
//}

#pragma mark - KVOController

- (void)fb_KVO {
    // 使用方法一：block回调
    self.kvoController = [FBKVOController controllerWithObserver:self];
    [self.kvoController observe:self.car keyPath:@"carName" options:(NSKeyValueObservingOptionNew) block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        if ([object isKindOfClass:[USTestCar class]]) {
            USTestCar *obj = (USTestCar *)object;
            NSLog(@"【KVOController】 %@",obj.carName);
        }
    }];
    
    // 使用方法二：action回调
//    [self.KVOController observe:self.car keyPath:@"carName" options:(NSKeyValueObservingOptionNew) action:@selector(newValueAction:)];
}

- (void)newValueAction:(id)obj {
    NSLog(@"%@",obj);
}

#pragma mark - us_kvo

- (void)us_KVO {
    [self.car us_addObserver:self forKeyPath:@selector(carName) options:(NSKeyValueObservingOptionNew) context:nil kvoNotiBlock:^(id observer, NSString *keyPath, id oldValue, id newValue) {
        NSLog(@"新值 %@",newValue);
    }];
}

- (void)dealloc {
    [self.car us_removeObserver:self forKeyPath:@selector(carName)];
}

@end
