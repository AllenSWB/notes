//
//  USBaseTableViewCell.m
//  UcarShare
//
//  Created by ghost on 2018/11/1.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "USBaseTableViewCell.h"

@implementation USBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initConfig];
        [self setupViews];
    }
    return self;
}

- (void)initConfig {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setupViews { }

@end
