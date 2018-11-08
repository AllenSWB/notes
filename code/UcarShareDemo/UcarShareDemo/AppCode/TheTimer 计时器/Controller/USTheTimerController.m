//
//  USTheTimerController.m
//  UcarShareDemo
//
//  Created by wenbo.sun on 2018/11/7.
//  Copyright © 2018 wenbo.sun. All rights reserved.
//

#import "USTheTimerController.h"
#import "USTheTimerViewModel.h"

@interface USTheTimerController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) USBaseTableView *tableView;

@property (nonatomic, strong) USTheTimerViewModel *viewModel;


@end

@implementation USTheTimerController

- (void)initConfig {
    self.viewModel = [[USTheTimerViewModel alloc] init];
}

- (void)setupNav {
    [super setupNav];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(itemAddAction)];
}

- (void)setupViews {
    [super setupViews];
    self.tableView = [[USBaseTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
        .leftEqualToView(self.view)
        .topEqualToView(self.view)
        .bottomEqualToView(self.view)
        .rightEqualToView(self.view);
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark - actions

- (void)itemAddAction {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate

@end
