//
//  USBaseTableView.m
//  UcarShare
//
//  Created by wenbo.sun on 2018/10/23.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "USBaseTableView.h"

@implementation USBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (void)initConfig {
    self.backgroundColor = [UIColor whiteColor];
    self.tableFooterView = [UIView new];
}

@end
