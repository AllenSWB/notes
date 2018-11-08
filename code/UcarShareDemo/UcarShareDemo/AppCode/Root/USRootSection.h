//
//  USRootSection.h
//  UcarShare
//
//  Created by wenbo.sun on 2018/11/1.
//  Copyright © 2018 wenbo.sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USRootRow.h"

@interface USRootSection : NSObject

@property (nonatomic, strong, readonly) NSString *sectionTitle;

@property (nonatomic, strong, readonly) NSMutableArray <USRootRow *> *rows;

+ (instancetype)sectionWithTitle:(NSString *)title;

- (void)addRowWithTitle:(NSString *)title selectedRow:(USRootRowDidSelected)selectedRow;

@end
