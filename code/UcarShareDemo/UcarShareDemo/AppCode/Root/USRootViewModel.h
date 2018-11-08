//
//  USRootViewModel.h
//  UcarShare
//
//  Created by wenbo.sun on 2018/10/23.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USBaseViewModel.h"
#import "USRootSection.h"

@interface USRootViewModel : USBaseViewModel

- (void)addSection:(USRootSection *)section;

- (USRootRow *)objAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfSections;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)titleForHeaderInSection:(NSInteger)section;

@end
