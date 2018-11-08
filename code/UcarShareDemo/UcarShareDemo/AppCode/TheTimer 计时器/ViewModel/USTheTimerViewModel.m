//
//  USTheTimerViewModel.m
//  UcarShareDemo
//
//  Created by wenbo.sun on 2018/11/7.
//  Copyright © 2018 wenbo.sun. All rights reserved.
//

#import "USTheTimerViewModel.h"

@interface USTheTimerViewModel ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation USTheTimerViewModel

- (void)initConfig {
    self.dataArray = @[@2,@3];
}

#pragma mark - public

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark - lazy

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}


@end
