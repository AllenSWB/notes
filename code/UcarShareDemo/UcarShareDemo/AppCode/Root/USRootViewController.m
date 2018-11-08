//
//  USRootViewController.m
//  UcarShare
//
//  Created by wenbo.sun on 2018/10/23.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "USRootViewController.h"
#import "USRootViewModel.h"
#import "USLayerMaskViewController.h"
#import "USWebViewController.h"
#import "USMylayoutDemoController.h"
#import "USKVODemoController.h"
#import "USTheTimerController.h"

//#import "USAnimationViewController.h"
//#import "USGCDViewController.h"
//#import "USTextureController.h"
//#import "USNewsDetailController.h" 
//#import "USSDAutoLayoutDemoController.h"
//#import "USSDWebImageDemoController.h"

@interface USRootViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) USRootViewModel *viewModel;

@property (nonatomic, strong) USBaseTableView *tableView;

@end

@implementation USRootViewController

- (void)initConfig {
    [super initConfig];
    self.viewModel = [[USRootViewModel alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Share";
    [self setupViews]; 
    [self configTableViewDatas];
    [self.tableView reloadData];
}

- (void)configTableViewDatas {
    __weak typeof(self) weakSelf = self;
    
    USRootSection *section00 = [USRootSection sectionWithTitle:@"未完成"];
    
    [section00 addRowWithTitle:@"Web" selectedRow:^{
        NSString *urlString = @"http://www.baidu.com";
        USWebViewController *vc = [[USWebViewController alloc] initWithUrlString:urlString];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [section00 addRowWithTitle:@"MyLayout布局" selectedRow:^{
        USMylayoutDemoController *vc = [[USMylayoutDemoController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [section00 addRowWithTitle:@"KVO" selectedRow:^{
        USKVODemoController *vc = [[USKVODemoController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
//    [section00 addRowWithTitle:@"The Timer" selectedRow:^{
//        USTheTimerController *vc = [[USTheTimerController alloc] init];
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    }];
    
//    [section00 addRowWithTitle:@"动画" selectedRow:^{
//        USAnimationViewController *vc = [[USAnimationViewController alloc] init];
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    }];
//
//    [section00 addRowWithTitle:@"SDAutoLayout" selectedRow:^{
//        USSDAutoLayoutDemoController *vc = [[USSDAutoLayoutDemoController alloc] init];
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    }];
//
//    [section00 addRowWithTitle:@"多线程 - GCD" selectedRow:^{
//        USGCDViewController *vc = [[USGCDViewController alloc] init];
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    }];
//
//    [section00 addRowWithTitle:@"Texture" selectedRow:^{
//        USTextureController *vc = [[USTextureController alloc] init];
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    }];

//    [section00 addRowWithTitle:@"新闻详情(图文混排)" selectedRow:^{
//        USNewsDetailController *vc = [[USNewsDetailController alloc] init];
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    }];
    
//    [section00 addRowWithTitle:@"SDWebImage" selectedRow:^{
//        USSDWebImageDemoController *vc = [[USSDWebImageDemoController alloc] init];
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    }];
//
    [self.viewModel addSection:section00];
    
    USRootSection *section11 = [USRootSection sectionWithTitle:@"已完成"];

    [section11 addRowWithTitle:@"蒙版" selectedRow:^{
        USLayerMaskViewController *vc = [[USLayerMaskViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.viewModel addSection:section11];
}

- (void)setupViews {
    self.tableView = [[USBaseTableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    USRootRow *rowObj = [self.viewModel objAtIndexPath:indexPath];
    cell.textLabel.text = rowObj.title;
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.viewModel titleForHeaderInSection:section];
} 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    USRootRow *rowObj = [self.viewModel objAtIndexPath:indexPath];
    if (rowObj.didSelectedRow) {
        rowObj.didSelectedRow();
    }
}

@end
