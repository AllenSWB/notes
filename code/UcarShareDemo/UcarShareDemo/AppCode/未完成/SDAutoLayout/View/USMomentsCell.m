//
//  USMomentsCell.m
//  UcarShare
//
//  Created by ghost on 2018/11/1.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "USMomentsCell.h"

@interface USMomentsCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation USMomentsCell

- (void)setupViews {
    self.avatarImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.avatarImageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.nameLabel];
    
    self.avatarImageView.sd_layout
        .leftSpaceToView(self.contentView, 20.f)
        .topSpaceToView(self.contentView, 10.f)
        .widthIs(50.f)
        .heightIs(50.f);
}

- (void)bindModel:(USMomentsModel *)model {
    if (!model) {
        return;
    }
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.userAvatar] placeholderImage:US_PlaceHolderIMG];
}

@end
