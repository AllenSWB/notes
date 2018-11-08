//
//  USRootRow.m
//  UcarShare
//
//  Created by wenbo.sun on 2018/10/23.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "USRootRow.h"

@interface USRootRow ()

@property (nonatomic, copy  , readwrite) USRootRowDidSelected didSelectedRow;

@property (nonatomic, strong, readwrite) NSString *title;

@end

@implementation USRootRow

- (instancetype)initWithTitle:(NSString *)title selectedRow:(USRootRowDidSelected)selectedRow {
    self = [super init];
    if (self) {
        self.title = title;
        self.didSelectedRow = selectedRow;
    }
    return self;
}

@end
