//
//  USLayerMaskCyanController.m
//  UcarShare
//
//  Created by wenbo.sun on 2018/10/25.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "USLayerMaskCyanController.h"

@interface USLayerMaskCyanController ()

@end

@implementation USLayerMaskCyanController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
//    USTransitionManager *obj = [[USTransitionManager alloc] init];
//    self.navigationController.delegate = obj;
//    
    self.actionButton.backgroundColor = UIColor.magentaColor;
    @weakify(self)
    [[self.actionButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

@end
