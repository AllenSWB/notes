//
//  USMomentsModel.h
//  UcarShare
//
//  Created by ghost on 2018/11/1.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USMomentsModelLikeItem : NSObject

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *userId;

@end

@interface USMomentsModelCommentsItem : NSObject

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *commentsContent;

// 是否是回复
@property (nonatomic, assign) BOOL isReply;

@property (nonatomic, strong) NSString *replyToUserName;

@end

@interface USMomentsImageModel : NSObject

@property (nonatomic, strong) NSString *imgUrl;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat heigth;

@end

typedef NS_ENUM(NSUInteger, USMomentsType) {
    USMomentsType_SingleText      = 0, //文本
    USMomentsType_SingleImage     = 2, //图片
    USMomentsType_TextAndImages   = 3, //文本 + 图片
};

@interface USMomentsModel : NSObject

@property (nonatomic, strong) NSString *_id;

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *userAvatar;

@property (nonatomic, assign) USMomentsType momentsType;

// 文字
@property (nonatomic, strong) NSString *momentsContent;

// 图片
@property (nonatomic, strong) NSArray <USMomentsImageModel *> *momentsImages;

@property (nonatomic, strong) NSArray <USMomentsModelLikeItem *> *momentLikeArray;

@property (nonatomic, strong) NSArray <USMomentsModelCommentsItem *> *momentCommentsArray;

@end


