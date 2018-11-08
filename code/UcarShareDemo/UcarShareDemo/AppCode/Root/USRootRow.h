//
//  USRootRow.h
//  UcarShare
//
//  Created by wenbo.sun on 2018/10/23.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^USRootRowDidSelected)(void);

@interface USRootRow : NSObject

@property (nonatomic, copy  , readonly) USRootRowDidSelected didSelectedRow;

@property (nonatomic, strong, readonly) NSString *title;

- (instancetype)initWithTitle:(NSString *)title selectedRow:(USRootRowDidSelected)selectedRow;

@end
