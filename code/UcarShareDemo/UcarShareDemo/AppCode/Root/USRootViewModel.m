//
//  USRootViewModel.m
//  UcarShare
//
//  Created by wenbo.sun on 2018/10/23.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "USRootViewModel.h"

@interface USRootViewModel ()

@property (nonatomic, strong) NSMutableArray <USRootSection *> *sectionsArray;

@end

@implementation USRootViewModel

- (void)initConfig {
    [super initConfig];
}

- (void)addSection:(USRootSection *)section {
    if (!section) {
        return;
    }
    [self.sectionsArray addObject:section];
}

#pragma mark - public

- (USRootRow *)objAtIndexPath:(NSIndexPath *)indexPath {
    USRootSection *sectionObj = [self.sectionsArray wb_objectOrNilAtIndex:indexPath.section];
    if (!sectionObj) {
        return nil;
    }
    USRootRow *rowObj = [sectionObj.rows wb_objectOrNilAtIndex:indexPath.row];
    if (!rowObj) {
        return nil;
    }
    return rowObj;
}

- (NSInteger)numberOfSections {
    return self.sectionsArray.count;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return self.sectionsArray[section].rows.count;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}

- (NSString *)titleForHeaderInSection:(NSInteger)section {
    USRootSection *sectionObj = [self.sectionsArray wb_objectOrNilAtIndex:section];
    if (!sectionObj) {
        return @"";
    }
    return sectionObj.sectionTitle;
}
#pragma mark - lazy

- (NSMutableArray<USRootSection *> *)sectionsArray {
    if (!_sectionsArray) {
        _sectionsArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _sectionsArray;
}

@end
