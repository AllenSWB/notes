//
//  USRootSection.m
//  UcarShare
//
//  Created by wenbo.sun on 2018/11/1.
//  Copyright © 2018 wenbo.sun. All rights reserved.
//

#import "USRootSection.h"

@interface USRootSection ()

@property (nonatomic, strong, readwrite) NSString *sectionTitle;

@property (nonatomic, strong, readwrite) NSMutableArray <USRootRow *> *rows;

@end

@implementation USRootSection

+ (instancetype)sectionWithTitle:(NSString *)title {
    USRootSection *section = [[USRootSection alloc] init];
    section.sectionTitle = title;
    return section;
}

#pragma mark - public

- (void)addRowWithTitle:(NSString *)title selectedRow:(USRootRowDidSelected)selectedRow {
    USRootRow *row = [[USRootRow alloc] initWithTitle:title selectedRow:selectedRow];
    [self.rows addObject:row];
}

#pragma mark - lazy

- (NSMutableArray<USRootRow *> *)rows {
    if (!_rows) {
        _rows = [NSMutableArray arrayWithCapacity:0];
    }
    return _rows;
}

@end
