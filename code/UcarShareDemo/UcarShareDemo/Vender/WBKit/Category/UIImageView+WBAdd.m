//
//  UIImageView+WBAdd.m
//  UcarShareDemo
//
//  Created by wenbo.sun on 2018/11/5.
//  Copyright © 2018 wenbo.sun. All rights reserved.
//

#import "UIImageView+WBAdd.h"

@implementation UIImageView (WBAdd)

- (void)wb_makeCircleCorner {
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.bounds;
    UIImage *circleImg = [UIImage imageNamed:@"wb_cornerCircle"];
    maskLayer.contents = (__bridge id)circleImg.CGImage;
    self.layer.mask = maskLayer;
}

@end
