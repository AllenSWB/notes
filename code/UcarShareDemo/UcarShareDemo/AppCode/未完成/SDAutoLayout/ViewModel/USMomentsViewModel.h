//
//  USMomentsViewModel.h
//  UcarShare
//
//  Created by ghost on 2018/11/1.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USBaseViewModel.h"

@class USMomentsModel;

@interface USMomentsViewModel : USBaseViewModel

@property (nonatomic, strong, readonly) NSMutableArray <USMomentsModel *> *dataArray;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

@end
