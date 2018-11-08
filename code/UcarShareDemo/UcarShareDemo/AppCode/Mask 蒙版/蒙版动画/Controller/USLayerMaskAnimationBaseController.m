//
//  USLayerMaskAnimationBaseController.m
//  UcarShare
//
//  Created by wenbo.sun on 2018/10/25.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "USLayerMaskAnimationBaseController.h"

@interface USLayerMaskAnimationBaseController ()


@end

@implementation USLayerMaskAnimationBaseController

- (void)viewDidLoad {
    [super viewDidLoad]; 
    self.fd_prefersNavigationBarHidden = YES;
}

- (void)setupViews {
    [super setupViews];
    
    self.actionButton = [[UIButton alloc] init];
    self.actionButton.backgroundColor = [UIColor whiteColor];
    self.actionButton.frame = CGRectMake(WB_ScreenWidth - 10 - 50, 30, 50, 50);
    self.actionButton.layer.masksToBounds = YES;
    self.actionButton.layer.cornerRadius = 25.f;
    [self.view addSubview:self.actionButton];
} 

@end
