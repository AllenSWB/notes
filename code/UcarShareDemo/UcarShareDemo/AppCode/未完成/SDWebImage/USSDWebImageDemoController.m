//
//  USSDWebImageDemoController.m
//  UcarShare
//
//  Created by wenbo.sun on 2018/11/1.
//  Copyright © 2018 wenbo.sun. All rights reserved.
//

#import "USSDWebImageDemoController.h"

@implementation USSDWebImageDemoController

- (void)setupViews {
    [super setupViews];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [self.view addSubview:imgView];
    imgView.sd_layout.centerXEqualToView(self.view).widthIs(100).heightIs(100).topSpaceToView(self.view, 40.f);
    
    NSString *imgUrl = @"https://tse2-mm.cn.bing.net/th?id=OIP.JSdSbXDiBDh0wCCFpG2aHQAAAA&w=212&h=212&c=7&o=5&pid=1.7";
    [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:US_PlaceHolderIMG];
}


@end
