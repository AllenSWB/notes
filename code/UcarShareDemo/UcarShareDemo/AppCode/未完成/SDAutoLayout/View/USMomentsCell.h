//
//  USMomentsCell.h
//  UcarShare
//
//  Created by ghost on 2018/11/1.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDAutoLayout.h>
#import "USMomentsModel.h"
#import "USBaseTableViewCell.h"

@interface USMomentsCell : USBaseTableViewCell

- (void)bindModel:(USMomentsModel *)model;

@end
