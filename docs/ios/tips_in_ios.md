# Tips in iOS
- [Tips in iOS](#tips-in-ios)
  - [iOS开发随手记](#ios%e5%bc%80%e5%8f%91%e9%9a%8f%e6%89%8b%e8%ae%b0)
  - [多target](#%e5%a4%9atarget)
    - [创建多target方法](#%e5%88%9b%e5%bb%ba%e5%a4%9atarget%e6%96%b9%e6%b3%95)
    - [创建一个新target的注意点：](#%e5%88%9b%e5%bb%ba%e4%b8%80%e4%b8%aa%e6%96%b0target%e7%9a%84%e6%b3%a8%e6%84%8f%e7%82%b9)
    - [多target设置`GCC_PREPROCESSOR_DEFINITIONS`引起的问题](#%e5%a4%9atarget%e8%ae%be%e7%bd%aegccpreprocessordefinitions%e5%bc%95%e8%b5%b7%e7%9a%84%e9%97%ae%e9%a2%98)
  - [加快编译速度](#%e5%8a%a0%e5%bf%ab%e7%bc%96%e8%af%91%e9%80%9f%e5%ba%a6)
  - [安装多个版本的cocoapods](#%e5%ae%89%e8%a3%85%e5%a4%9a%e4%b8%aa%e7%89%88%e6%9c%ac%e7%9a%84cocoapods)
  - [扩大button响应区域](#%e6%89%a9%e5%a4%a7button%e5%93%8d%e5%ba%94%e5%8c%ba%e5%9f%9f)

## iOS开发随手记 
  
  [iOS开发随手记](https://www.jianshu.com/p/cb80ad438057)
   
## 多target
   
   >  BWCMT项目架构:
   >
   >  - 基础库pod集成（封装好的UI；网络库；三方库等）
   >  - 每个业务线是一个project，最后主工程依赖各个业务线framework，业务线间通信通过平台层platform里的路由完成（不能跨业务线直接调用）
   >
   >  ![bwcmt_struct](../../src/imgs/ios/bwcmt_struct.png)
   >
   >  产生的问题：主工程依赖所有的业务线的framework，但是各个业务线之间不一定有依赖，我开发某一个业务线的时候，如果需要编译整个工程的话，时间会很长。
   >
   >  解决方案是：为一个单独的业务线创建一个target，以节省工程build时间。

### 创建多target方法

  创建target的步骤参考这个链接：[iOS 一套代码多APP／多渠道／多target+自动打包脚本](https://www.jianshu.com/p/73343b4fc42b)

  [创建多target](./add_more_targets_to_your_project.md)
###  创建一个新target的注意点：

  + 依赖
    
    ![more_targets_noti0](../../src/imgs/ios/more_targets_noti0.png)
  + 宏：判断当前run的那个target
  
    ![more_targets_noti1](../../src/imgs/ios/more_targets_noti1.png)
    ![more_targets_noti2](../../src/imgs/ios/more_targets_noti2.png)

    设置`$(inherited)`

    ![more_target_error_pod_solve](../../src/imgs/ios/more_target_error_pod_solve.png)
  + Pods库：新的target也要记得依赖pod库

    ```ruby
      # Podfile 文件
      targetsArray = ['BWCMTApp','BWCMTAppYZFlutter']

      targetsArray.each  do |t|

         target t do
             pod 'YYModel', '~>1.0.4'
             pod 'DoraemonKit/Core', :git => 'http://gitlab.10101111.com:8888/p2p/udoraemonkit.git', :configurations => ['Debug','ZC','Distribution']
         end
      end
    ```

### 多target设置`GCC_PREPROCESSOR_DEFINITIONS`引起的问题
   
   前面说了，为了用代码判断当前run的是那个target，设置了两个宏`BWCMT_FULL`和`BWCMT_YZ_FLUTTER`。这时候使用`pod install`会有下面的提示（pod没有出错，只是会给个警告⚠️）。

  ```shell
    [!] The `BWCMTApp [Release]` target overrides the `GCC_PREPROCESSOR_DEFINITIONS` build setting defined in `Pods/Target Support Files/Pods-BWCMTApp/Pods-BWCMTApp.release.xcconfig'. This can lead to problems with the CocoaPods installation
     - Use the `$(inherited)` flag, or
     - Remove the build settings from the target.
  ```

   ![more_target_error_pod](../../src/imgs/ios/more_target_error_pod.png)

   解决办法是在`GCC_PREPROCESSOR_DEFINITIONS`里加上`$(inherited)`。再次`pod install`警告会消失。

   ![more_target_error_pod_solve](../../src/imgs/ios/more_target_error_pod_solve.png)

## 加快编译速度

从源码到二进制可执行文件整个流程去考虑

1. 修改`Optimization Level`的值

    ![Optimization Level](../../src/imgs/ios/optimization_level.png)

2. `.h`文件引入头文件，`#import`改成`@class`


## 安装多个版本的cocoapods


## 扩大button响应区域

```objc
/// .h

@interface UIButton (EnlargeHitArea)

@property (nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

@end

/// .m

#import "UIButton+EnlargeHitArea.h"
static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";

@implementation UIButton (EnlargeHitArea)

-(void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets]; return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

@end

```