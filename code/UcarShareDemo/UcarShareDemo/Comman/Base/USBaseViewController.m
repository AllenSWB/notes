//
//  USBaseViewController.m
//  UcarShare
//
//  Created by wenbo.sun on 2018/10/23.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "USBaseViewController.h"

@interface USBaseViewController ()

@end

@implementation USBaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    // 通常写在base类的loadView方法中
    // iOS7.0后，显示在导航栏之下，即frame.y从导航栏下面开始算起
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        // 不要往四周边沿展开，避免被导航栏遮挡
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        // 取消半透明色，避免被导航栏遮挡
        self.navigationController.navigationBar.translucent = NO;
        // 展开时不包含导航栏，避免被导航栏遮挡
        self.extendedLayoutIncludesOpaqueBars = NO;
        // 改变scrollView的contentInsets，避免scrollView，tableView，collectionView的contentInset.top = 64
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)initConfig {};

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    [self setupViews];
}

- (void)setupViews {}

- (void)setupNav {
    if (self.navigationController.childViewControllers.count > 1) {
        // https://www.jianshu.com/p/31f177158c9e
    }
}

- (void)_backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
