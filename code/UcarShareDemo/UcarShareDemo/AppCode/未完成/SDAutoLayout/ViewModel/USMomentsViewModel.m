//
//  USMomentsViewModel.m
//  UcarShare
//
//  Created by ghost on 2018/11/1.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "USMomentsViewModel.h"
#import "USMomentsModel.h"

@interface USMomentsViewModel ()

@property (nonatomic, strong, readwrite) NSMutableArray <USMomentsModel *> *dataArray;

@end

@implementation USMomentsViewModel

- (void)initConfig {
    USMomentsModel *model0 = [[USMomentsModel alloc] init];
    model0._id = @"4567";
    model0.userName = @"梅超风";
    model0.userAvatar = @"https://tse2-mm.cn.bing.net/th?id=OIP.JSdSbXDiBDh0wCCFpG2aHQAAAA&w=212&h=212&c=7&o=5&pid=1.7";
    model0.momentsType = USMomentsType_SingleText;
    model0.momentsContent = @"首先，我来到草地上，看到土地上一片空白，心想：该我大显身手了。于是我轻轻一吹，小草的棉被就消失的无影无踪了。我对小草说：“小草，别睡了，现在外面阳光明媚，可暖和了。”只见小草们把头一个个冒了出来。1、2、3……不一会儿，草地上就一片绿油油。花妹妹见草哥哥出来了，也探出了小脑袋。这些花儿吸引了一群健壮的骏马。";
    [self.dataArray addObject:model0];
}

#pragma mark - public

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark - lazy

- (NSMutableArray<USMomentsModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

@end
