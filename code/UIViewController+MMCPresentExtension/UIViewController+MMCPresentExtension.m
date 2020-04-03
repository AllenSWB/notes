//
//  UIViewController+MMCPresentExtension.m
//  Pods
//
//  Created by lwong on 2019/8/6.
//

#import "UIViewController+MMCPresentExtension.h"
#import "MMCCustomPresentationController.h"
#import <objc/runtime.h>


@implementation UIViewController (MMCPresentExtension)

- (void)setMmc_preferredPoint:(CGPoint)mmc_preferredPoint{
    objc_setAssociatedObject(self, @selector(mmc_preferredPoint), [NSValue valueWithCGPoint:mmc_preferredPoint], OBJC_ASSOCIATION_RETAIN);
}

- (CGPoint)mmc_preferredPoint{
    return [objc_getAssociatedObject(self, @selector(mmc_preferredPoint)) CGPointValue];
}

- (void)setMmc_preferredSize:(CGSize)mmc_preferredSize{
    objc_setAssociatedObject(self, @selector(mmc_preferredSize), [NSValue valueWithCGSize:mmc_preferredSize], OBJC_ASSOCIATION_RETAIN);
}

- (CGSize)mmc_preferredSize{
    return [objc_getAssociatedObject(self, @selector(mmc_preferredSize)) CGSizeValue];
}

- (void)mmc_presentViewController:(UIViewController *)viewControllerToPresent
                     contentInset:(UIEdgeInsets)contentInset
                         animated:(BOOL)flag
                       completion:(void (^)(void))completion {

    [self mmc_customPresentationController:viewControllerToPresent
                            preferredPoint:UIEdgeInsetsInsetRect([UIScreen mainScreen].bounds,contentInset).origin
                      preferredContentSize:UIEdgeInsetsInsetRect([UIScreen mainScreen].bounds,contentInset).size
                                  animated:flag
                                completion:completion];
}

- (void)mmc_presentViewController:(UIViewController *)viewControllerToPresent
             preferredContentSize:(CGSize)preferredContentSize
                         animated:(BOOL)flag
                       completion:(void (^)(void))completion{
    
    CGFloat x = (CGRectGetWidth([UIScreen mainScreen].bounds) - preferredContentSize.width) / 2;
    CGFloat y = (CGRectGetHeight([UIScreen mainScreen].bounds) - preferredContentSize.height) / 2;
    
    [self mmc_customPresentationController:viewControllerToPresent
                            preferredPoint:CGPointMake(x, y)
                      preferredContentSize:preferredContentSize
                                  animated:flag
                                completion:completion];
}


// For presentations which will use a custom presentation controller,
// it is possible for that presentation controller to also be the
// transitioningDelegate.  This avoids introducing another object
// or implementing <UIViewControllerTransitioningDelegate> in the
// source view controller.
//
// transitioningDelegate does not hold a strong reference to its
// destination object.  To prevent presentationController from being
// released prior to calling -presentViewController:animated:completion:
// the NS_VALID_UNTIL_END_OF_SCOPE attribute is appended to the declaration.

- (void)mmc_presentViewController:(UIViewController *)viewControllerToPresent
                   safeAreaHeight:(CGFloat)safeAreaHeight
                         animated:(BOOL)flag
                       completion:(void (^)(void))completion {
    
    CGFloat height = safeAreaHeight;
    if (@available(iOS 11.0, *)) {
        height += viewControllerToPresent.view.safeAreaInsets.bottom;
    }
    
    [self mmc_customPresentationController:viewControllerToPresent
                            preferredPoint:CGPointMake(0, CGRectGetMaxY([UIScreen mainScreen].bounds) - height)
                      preferredContentSize:CGSizeMake(CGRectGetWidth(self.view.bounds),height)
                                  animated:flag
                                completion:completion];
}

- (void)mmc_customPresentationController:(UIViewController *)viewControllerToPresent
                           preferredPoint:(CGPoint)preferredPoint
                   preferredContentSize:(CGSize)preferredContentSize
                         animated:(BOOL)flag
                              completion:(void (^)(void))completion{
    MMCCustomPresentationController* customPresentationController NS_VALID_UNTIL_END_OF_SCOPE;
    customPresentationController = [[MMCCustomPresentationController alloc] initWithPresentedViewController:viewControllerToPresent
                                                                                   presentingViewController:self];

    viewControllerToPresent.preferredContentSize = preferredContentSize;
    viewControllerToPresent.mmc_preferredSize = preferredContentSize;
    viewControllerToPresent.mmc_preferredPoint = preferredPoint;
    [self presentViewController:viewControllerToPresent animated:flag completion:completion];

}


@end
