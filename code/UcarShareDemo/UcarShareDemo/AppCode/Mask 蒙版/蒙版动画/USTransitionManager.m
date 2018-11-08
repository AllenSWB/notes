//
//  USTransitionManager.m
//  UcarShare
//
//  Created by ghost on 2018/10/25.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "USTransitionManager.h"
#import "USCircleTransition.h"

@implementation USTransitionManager

#pragma mark - UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
 
//    return nil;
    return [[USCircleTransition alloc] init];
}

@end
