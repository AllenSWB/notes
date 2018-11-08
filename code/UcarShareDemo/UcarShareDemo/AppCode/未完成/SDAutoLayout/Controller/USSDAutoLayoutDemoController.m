//
//  USSDAutoLayoutDemoController.m
//  UcarShare
//
//  Created by ghost on 2018/11/1.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "USSDAutoLayoutDemoController.h"
#import "USMomentsViewModel.h"
#import "USMomentsCell.h"
#import "USBaseTableView.h"
/*
 
 项目地址  https://github.com/gsdios/SDAutoLayout
 
 */

@interface USSDAutoLayoutDemoController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) USMomentsViewModel *viewModel;

@property (nonatomic, strong) USBaseTableView *tableView;

@end

@implementation USSDAutoLayoutDemoController

- (void)initConfig {
    self.viewModel = [[USMomentsViewModel alloc] init];
}

- (void)setupViews {
    self.tableView = [[USBaseTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
        .leftEqualToView(self.view)
        .topEqualToView(self.view)
        .bottomEqualToView(self.view)
        .rightEqualToView(self.view);
    
    [self.tableView registerClass:[USMomentsCell class] forCellReuseIdentifier:@"USMomentsCell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    USMomentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USMomentsCell" forIndexPath:indexPath];
    [cell bindModel:[self.viewModel.dataArray objectOrNilAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate



@end
