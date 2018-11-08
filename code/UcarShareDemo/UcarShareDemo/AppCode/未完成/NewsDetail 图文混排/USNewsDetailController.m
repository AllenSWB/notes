//
//  USNewsDetailController.m
//  UcarShare
//
//  Created by wenbo.sun on 2018/10/31.
//  Copyright © 2018 wenbo.sun. All rights reserved.
//

#import "USNewsDetailController.h"
#import <SDAutoLayout.h>
#import "USWebViewController.h"
/*
 1. WKWebview 直接嵌入web页
 2. 手机端拼HTML 展示web页 https://blog.csdn.net/shaobo8910/article/details/51719673
 3. 布谷app 和后台约定好model，UITableView布局
 4. CoreText
 4. UITextKit
 
 YYText
 TTTAttribuatedLabel
 
 https://github.com/12207480/TYAttributedLabel
 
 */

@interface USNewsDetailController ()

@end

@implementation USNewsDetailController

- (void)setupViews {
    [super setupViews];
    
    UIButton *btn00 = [[UIButton alloc] init];
    btn00.backgroundColor = UIColor.cyanColor;
    [btn00 setTitle:@"直接加载URL" forState:(UIControlStateNormal)];
    [self.view addSubview:btn00];
    
    UIButton *btn11 = [[UIButton alloc] init];
    btn11.backgroundColor = UIColor.cyanColor;
    [btn11 setTitle:@"手机端拼HTML" forState:(UIControlStateNormal)];
    [self.view addSubview:btn11];
    
    UIButton *btn22 = [[UIButton alloc] init];
    btn22.backgroundColor = UIColor.cyanColor;
    [btn22 setTitle:@"原生 - UITableView" forState:(UIControlStateNormal)];
    [self.view addSubview:btn22];
    
    UIButton *btn33 = [[UIButton alloc] init];
    btn33.backgroundColor = UIColor.cyanColor;
    [btn33 setTitle:@"原生 - CoreText" forState:(UIControlStateNormal)];
    [self.view addSubview:btn33];
    
    btn00.sd_layout.centerXEqualToView(self.view).widthRatioToView(self.view, 0.75).topSpaceToView(self.view, 100).heightIs(60);
    btn11.sd_layout.centerXEqualToView(self.view).widthRatioToView(btn00, 1).heightRatioToView(btn00, 1).topSpaceToView(btn00, 20);
    btn22.sd_layout.centerXEqualToView(self.view).widthRatioToView(btn00, 1).heightRatioToView(btn00, 1).topSpaceToView(btn11, 20);
    btn33.sd_layout.centerXEqualToView(self.view).widthRatioToView(btn00, 1).heightRatioToView(btn00, 1).topSpaceToView(btn22, 20);
    
    @weakify(self)
    [[btn00 rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        USWebViewController *web = [[USWebViewController alloc] init];
        web.urlString = @"http://t.pae.baidu.com/s?s=bai-q0iulx";
        [self.navigationController pushViewController:web animated:YES];
    }];
}


@end
