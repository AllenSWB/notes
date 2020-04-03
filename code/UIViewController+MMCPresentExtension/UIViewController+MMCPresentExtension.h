//
//  UIViewController+MMCPresentExtension.h
//  Pods
//
//  Created by lwong on 2019/8/6.
//

#import <UIKit/UIKit.h>



@interface UIViewController (MMCPresentExtension) 

/**
 ⚠️ mmc_preferredCPoint 仅用于mmc_presentViewControllerf方法
 */
@property (nonatomic, assign,readonly) CGPoint mmc_preferredPoint;


/**
 mmc_preferredSize 仅用于mmc_presentViewControllerf方法
 */
@property (nonatomic, assign,readonly) CGSize mmc_preferredSize;


/**
 present控制器

 @param viewControllerToPresent 需要present的控制器
 @param contentInset 距离屏幕的边距
 @param flag flag
 @param completion 回调
 
 ⚠️⚠️ 需要present的控制器，内部视图使用绝对布局(frame)时，需在viewDidLayoutSubviews手动刷新内部视图的frame（父视图布局改变，不会触发子视图改变）
      masory会自动触发子视图刷新,不需要考虑上面的问题
 */
- (void)mmc_presentViewController:(UIViewController *)viewControllerToPresent
                     contentInset:(UIEdgeInsets)contentInset
                         animated:(BOOL)flag
                       completion:(void (^)(void))completion;


/**
 present控制器
 
 @param viewControllerToPresent 需要present的控制器
 @param preferredContentSize present的控制器的Size
 @param flag flag
 @param completion 回调
 
 ⚠️⚠️ 需要present的控制器，内部视图使用绝对布局(frame)时，需在viewDidLayoutSubviews手动刷新内部视图的frame（父视图布局改变，不会触发子视图改变）
 masory会自动触发子视图刷新,不需要考虑上面的问题
 */
- (void)mmc_presentViewController:(UIViewController *)viewControllerToPresent
                     preferredContentSize:(CGSize)preferredContentSize
                         animated:(BOOL)flag
                       completion:(void (^)(void))completion;



/**
 推出一个安全区域高度为safeAreaHeight的控制器

 @param viewControllerToPresent 需要present的控制器
 @param safeAreaHeight 安全区域高度，不包括刘海屏底部非安全区域高度
 @param flag 是否动画
 @param completion 完成回调
 */
- (void)mmc_presentViewController:(UIViewController *)viewControllerToPresent
                   safeAreaHeight:(CGFloat)safeAreaHeight
                         animated:(BOOL)flag
                       completion:(void (^)(void))completion;

@end

