//
//  USLayerMaskNextController.m
//  UcarShare
//
//  Created by wenbo.sun on 2018/10/24.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "USLayerMaskNextController.h"
#import "USLayerMaskCyanController.h"
#import "AppDelegate.h"

@interface USLayerMaskNextController () 

@end

@implementation USLayerMaskNextController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor magentaColor];
    self.actionButton.backgroundColor = UIColor.cyanColor;
    
    @weakify(self)
    [[self.actionButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        USLayerMaskCyanController *cyan = [[USLayerMaskCyanController alloc] init];
        [self.navigationController pushViewController:cyan animated:YES];
    }];
}

- (void)setupNav {
    /*
     * 另一种写法会报警告 https://www.aliyun.com/jiaocheng/393578.html
     * self.navigationController.delegate = [[USTransitionManager alloc] init];
     */
    USTransitionManager *obj = [[USTransitionManager alloc] init];
    ((AppDelegate *)UIApplication.sharedApplication.delegate).obj = obj;
    ((UINavigationController *)UIApplication.sharedApplication.keyWindow.rootViewController).delegate = obj;
}

- (void)dealloc {
    ((AppDelegate *)UIApplication.sharedApplication.delegate).obj = nil;
    ((UINavigationController *)UIApplication.sharedApplication.keyWindow.rootViewController).delegate = nil;
}

@end
