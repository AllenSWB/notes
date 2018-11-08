//
//  USCircleTransition.m
//  UcarShare
//
//  Created by ghost on 2018/10/25.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "USCircleTransition.h"
#import "USLayerMaskAnimationBaseController.h"

@interface USCircleTransition () <CAAnimationDelegate>

@property (nonatomic, strong) id <UIViewControllerContextTransitioning>context;

@end

@implementation USCircleTransition

#pragma mark - UIViewControllerAnimatedTransitioning

// 转场动画持续时长
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.1;
}

// 转场动画的具体内容
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.context = transitionContext;
    
    // from vc & to vc
    USLayerMaskAnimationBaseController *fromVC = (USLayerMaskAnimationBaseController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    USLayerMaskAnimationBaseController *toVC = (USLayerMaskAnimationBaseController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;

    UIView *snapshotView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    if (!snapshotView) {
        [self.context completeTransition:NO];// 转场失败
    }
    
    // back view
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = fromVC.view.backgroundColor;
    backView.frame = toVC.view.frame;
    [containerView addSubview:backView];
    
    // 移除旧view
    [containerView addSubview:snapshotView];
    [fromVC.view removeFromSuperview];
    [self animationMoveOutScreen:snapshotView];
    
    // 蒙版动画 - 圆形扩散
    [containerView addSubview:toVC.view];
    [self animationToView:toVC.view actionButton:toVC.actionButton];
}

- (void)animationToView:(UIView *)toView actionButton:(UIButton *)actionButton {
    
    // start
    CGRect startFrame = actionButton.frame;
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:startFrame];
    
    // end
    CGFloat fullHeight = toView.bounds.size.height;
    CGPoint extremePoint = CGPointMake(actionButton.centerX, actionButton.centerY - fullHeight);
    CGFloat radius = sqrt((extremePoint.x * extremePoint.x) + (extremePoint.y * extremePoint.y));
    CGRect endRect = CGRectInset(actionButton.frame, -radius, -radius);
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
    
    // mask
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = endPath.CGPath;
    toView.layer.mask = layer;
    
    // mask animation
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id _Nullable)(startPath.CGPath);
    maskLayerAnimation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    maskLayerAnimation.delegate = self;
    [layer addAnimation:maskLayerAnimation forKey:@"path"];
}

- (void)animationMoveOutScreen:(UIView *)fromView {
    [UIView animateWithDuration:0.25 delay:0.0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        fromView.center = CGPointMake(fromView.centerX - 1000, fromView.centerY + 1500);
        fromView.transform = CGAffineTransformMakeScale(5, 5);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.context completeTransition:YES];// 转场成功
}

@end
