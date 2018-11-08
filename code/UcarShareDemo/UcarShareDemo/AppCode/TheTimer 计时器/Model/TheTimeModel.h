//
//  TheTimeModel.h
//  UcarShareDemo
//
//  Created by wenbo.sun on 2018/11/7.
//  Copyright © 2018 wenbo.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TheTimeType) {
    TheTimeType_PositiveSequence = 0, // 正序 +
    TheTimeType_Reverse          = 1, // 倒序 -
};

@interface TheTimeModel : NSObject

@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) NSString *startTime;

@property (nonatomic, strong) NSString *endTime;

@property (nonatomic, assign) TheTimeType type;

@end
