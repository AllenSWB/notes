//
//  USGCDViewController.m
//  UcarShare
//
//  Created by wenbo.sun on 2018/10/26.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "USGCDViewController.h"

@interface User : NSObject
+ (instancetype)sharedUser;
@end

@implementation User

+ (instancetype)sharedUser {
    static User *user  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[User alloc] init];
    });
    return user;
}

@end

@interface USGCDViewController ()

@end

@implementation USGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


@end
