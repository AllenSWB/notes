# Tips in iOS
- [Tips in iOS](#Tips-in-iOS)
  - [iOS开发随手记](#iOS%E5%BC%80%E5%8F%91%E9%9A%8F%E6%89%8B%E8%AE%B0)
  - [多target](#%E5%A4%9Atarget)
    - [创建多target方法](#%E5%88%9B%E5%BB%BA%E5%A4%9Atarget%E6%96%B9%E6%B3%95)
    - [创建一个新target的注意点：](#%E5%88%9B%E5%BB%BA%E4%B8%80%E4%B8%AA%E6%96%B0target%E7%9A%84%E6%B3%A8%E6%84%8F%E7%82%B9)
    - [多target设置`GCC_PREPROCESSOR_DEFINITIONS`引起的问题](#%E5%A4%9Atarget%E8%AE%BE%E7%BD%AEGCCPREPROCESSORDEFINITIONS%E5%BC%95%E8%B5%B7%E7%9A%84%E9%97%AE%E9%A2%98)
    - [加快编译速度](#%E5%8A%A0%E5%BF%AB%E7%BC%96%E8%AF%91%E9%80%9F%E5%BA%A6)
    - [安装多个版本的cocoapods](#%E5%AE%89%E8%A3%85%E5%A4%9A%E4%B8%AA%E7%89%88%E6%9C%AC%E7%9A%84cocoapods)

## iOS开发随手记 
  
  https://www.jianshu.com/p/cb80ad438057
   
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

### 加快编译速度

从源码到二进制可执行文件整个流程去考虑

1. 修改`Optimization Level`的值

    ![Optimization Level](../../src/imgs/ios/optimization_level.png)

2. `.h`文件引入头文件，`#import`改成`@class`


### 安装多个版本的cocoapods

????