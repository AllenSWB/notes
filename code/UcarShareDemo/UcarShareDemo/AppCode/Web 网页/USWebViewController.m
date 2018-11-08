//
//  USWebViewController.m
//  UcarShare
//
//  Created by wenbo.sun on 2018/10/29.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "USWebViewController.h"
#import <WebKit/WebKit.h>

@interface USWebViewController ()

@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation USWebViewController

- (instancetype)initWithUrlString:(NSString *)urlString {
    self = [super init];
    if (self) {
        self.urlString = urlString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.wkWebView loadRequest:request];
}

- (void)setupViews {
    [super setupViews];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:self.wkWebView];
}

@end
