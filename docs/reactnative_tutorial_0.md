# React Natvie 入坑

## 搭建开发环境

> 必须安装的依赖有：Node、Watchman、RN命令行工具、Xcode（JDK和Android Studio）

+ [Watchman](https://facebook.github.io/watchman)是由 Facebook 提供的监视文件系统变更的工具。安装此工具可以提高开发时的性能（packager 可以快速捕捉文件的变化从而实现实时刷新）
+ Node 是 xxxx
+ RN命令行工具：用于执行创建、初始化、更新项目、运行打包服务（packager）等任务
+ [Yarn](http://yarnpkg.com/)是 Facebook 提供的替代 npm 的工具，可以加速 node 模块的下载

使用Homebrew安装node和watchman

```shell
brew install node
brew install watchman

# 查看node版本
node -v
```

Yarn、RN命令行工具（react-native-cli）

```shell
npm install -g yarn react-native-cli
```

## 创建RN项目

```shell
# xxxName 工程名
react-native init xxxName # 默认创建最新版本的rn
# 创建指定版本的rn
react-native init testRN --version 0.44.3 # testRN 工程名
```

运行工程

```shell
To run your app on iOS:
   cd /Users/wenbo.sun/Desktop/testRN
   react-native run-ios
- or -
  Open ios/testRN.xcodeproj in Xcode
     Hit the Run button
To run your app on Android:
     cd /Users/wenbo.sun/Desktop/testRN
     Have an Android emulator running (quickest way to get started), or a device connected
     react-native run-android
```

## 集成RN到原生App 

+  [官方文档 集成RN到Native](https://reactnative.cn/docs/integration-with-existing-apps/)

> 主要步骤如下：
>
> 1. 配置好 React Native 依赖和项目结构。
> 2. 了解你要集成的 React Native 组件。
> 3. 使用 CocoaPods 把这些组件以依赖的形式加入到项目中。
> 4. 创建 js 文件，编写 React Native 组件的 js 代码。
> 5. 在应用中添加一个`RCTRootView`。这个`RCTRootView`正是用来承载你的 React Native 组件的容器。
> 6. 启动 React Native 的 Packager 服务，运行应用。
> 7. 验证这部分组件是否正常工作。

### 安装依赖

步骤如下：

1. 创建一个空目录，再在其中创建一个子目录`/ios`，把现有iOS工程拷贝进`/ios`目录底下

   ```shell
   # 创建一个空目录 rnJoinNative
   mkdir rnJoinNative
   cd rnJoinNative/
   # 创建一个子目录 ios
   mkdir ios
   # 把现有iOS工程拷贝进ios目录底下
   ```

2. 创建一个`package.json`文件，安装JavaScript依赖包

   ```shell
   touch package.json
   ```

   编辑`package.json`文件

   ```json
   {
   	"name": "rnJoinNative",
       // 这个字段意义不大，除非你要把项目发布到npm仓库
   	"version": "0.0.1",  
   	"private": true,
   	"scripts": {
       	// 用于启动 packager 服务的命令。   
   		"start": "node node_modules/react-native/local-cli/cli.js start"
   	}
   }
   ```

   使用yarn或者npm（二者都是node的包管理器）来安装React和React Native模块。

   终端运行一下命令，默认会安装最新版本的React Native。

   ```shell
   yarn add react-native
   
   # 会打印类似下面的警告信息，这是正常现象，意味着我们需要安装指定版本的React
   warning " > react-native@0.58.1" has unmet peer dependency "react@16.6.3".
   ```

   安装React

   ```shell
   yarn add react@16.6.3 # 注意，这里的版本号要和上面warning提示的版本号一致！！！
   ```

   成功后，再去看`package.json`文件，会发现多出了`dependencies`字段

   ```json
   {
   	"name": "rnJoinNative",
   	"version": "0.0.1",
   	"private": true,
   	"scripts": {
   		"start": "node node_modules/react-native/local-cli/cli.js start"
   	},
   	"dependencies": {
   		"react": "16.6.3",
   		"react-native": "^0.58.1"
   	}
   }
   ```

3. 使用cocoapods将RN添加到原生app中

   在Podfile文件中加入以下代码

   ```ruby
   # React Native
   pod 'React', :path => '../../node_modules/react-native', :subspecs => [
       'Core',
       # 根据需要加入相应的组件
       'RCTText',
       'RCTNetwork',
       'CxxBridge', # 如果RN版本 >= 0.47则加入此行
       'DevSupport', # 如果RN版本 >= 0.43，则需要加入此行才能开启开发者菜单
   ]
   # 如果你的RN版本 >= 0.42.0，则加入下面这行
   pod 'yoga', :path => '../../node_modules/react-native/ReactCommon/yoga'
   # 如果RN版本 >= 0.45则加入下面三个第三方编译依赖
   pod 'DoubleConversion', :podspec => '../../node_modules/react-native/third-party-podspecs/DoubleConversion.podspec'
   pod 'glog', :podspec => '../../node_modules/react-native/third-party-podspecs/glog.podspec'
   pod 'Folly', :podspec => '../../node_modules/react-native/third-party-podspecs/Folly.podspec'
   ```

   然后执行`pod install`命令，全部配置没问题的话，就可以`Pod installation complete!`。

   

   遇到的问题：

   1. `pod install`时也有可能遇到如下问题：

      ```shell
      [!] No podspec found for `React` in `../node_modules/react-native`
      ```

      解决方法：[原因是路径写错了](https://github.com/react-native-community/react-native-maps/issues/1197)，把Podfile中路径改成 `path => '../../node_modules/react-native', `

   2. pod库装完后，我用Xcode打开工程，build出错

      ![](https://github.com/AllenSWB/notes/blob/master/src/imgs/reactnative/rn_join_error_0.png)

      ```
      'jsireact/JSIExecutor.h' file not found`
      ```

      解决办法：`JSIExecutor.h`这个文件是存在的，但是自动生成的路径不对。改成`#import 'JSIExecutor.h'`就好了。

    3. 错误提示:required a higher minimum deployment target.

      ![](https://github.com/AllenSWB/notes/blob/master/src/imgs/reactnative/rn_join_error_1.png)

      解决办法：
      ![](https://github.com/AllenSWB/notes/blob/master/src/imgs/reactnative/rn_join_error_1_solve.png)

> 至此，所有的依赖都安装完成了。下面就可以进入编码阶段了。

### 代码集成

1. React Native 组件

   在根目录创建一个`index.js`文件，这个文件是RN应用在iOS上的入口文件（0.49 版本之前是 `index.ios.js` 文件）。 

   在`index.js`里写demo代码

   ```javascript
   import React from 'react';
   import {AppRegistry, StyleSheet, Text, View} from 'react-native';
   
   class CMTApp extends React.Component {
     render() {
       var contents = this.props['scores'].map((score) => (
         <Text key={score.name}>
           {score.name}:{score.value}
           {'\n'}
         </Text>
       ));
       return (
         <View style={styles.container}>
           <Text style={styles.highScoresTitle}>2048 High Scores!</Text>
           <Text style={styles.scores}>{contents}</Text>
         </View>
       );
     }
   }
   
   const styles = StyleSheet.create({
     container: {
       flex: 1,
       justifyContent: 'center',
       alignItems: 'center',
       backgroundColor: '#FFFFFF',
     },
     highScoresTitle: {
       fontSize: 20,
       textAlign: 'center',
       margin: 10,
     },
     scores: {
       textAlign: 'center',
       color: '#333333',
       marginBottom: 5,
     },
   });
   
   // 整体js模块的名称
   AppRegistry.registerComponent('CMTApp', () => CMTApp);
   ```

2. `RCTRootView`

   在原生的ViewController里`#import <React/RCTRootView.h>`

   ```objective-c
   - (void)btnAction {
       NSURL *jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.bundle?platform=ios"];
       RCTRootView *rootView =
       [[RCTRootView alloc] initWithBundleURL: jsCodeLocation
                                   moduleName: @"CMTApp" //注意：这里是工程名，要跟index.js中对应上！！！！
                            initialProperties:
        @{
          @"scores" : @[
                  @{
                      @"name" : @"Alex",
                      @"value": @"42"
                      },
                  @{
                      @"name" : @"Joel",
                      @"value": @"10"
                      }
                  ]
          }
                                launchOptions: nil];
       UIViewController *vc = [[UIViewController alloc] init];
       vc.view = rootView;
       [self presentViewController:vc animated:YES completion:nil];
   }
   ```

3. 测试集成结果

   运行工程：

   1. 在工程根目录下启动服务

      ```shell
      npm start
      ```

   2. 跑工程有两个方法，一个是执行命令，一个是用Xcode打开

      + 执行命令

        ```shell
        react-native run-ios
        ```

      + 用xcode打开

        打开`.xcworkspace`文件

   遇到问题：

   1. 链接js文件问题

      ```objective-c
      // 原来代码中，js文件的路径如下。
      NSURL *jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.bundle?platform=ios"];
      ```

      我用真机跑工程，发现找不到文件，需要把IP地址改下。改动后如下：

      ```objective-c
      NSURL *jsCodeLocation = [NSURL URLWithString:@"http://10.99.58.67:8081/index.bundle?platform=ios"];
      ```

   2. 内网IP问题

      确认链接js的路径没问题后，发现还是不行。这是因为我电脑连得是公司WiFi，`10.99.58.67`是公司内网IP，真机没连WiFi，所以找不到这个IP，还是不行，解决就是手机连上公司WiFi和电脑处于一个局域网内。

   3. native工程所在文件夹命名问题 `ios` or `CMTApp`

      如图所示，原来iOS native工程的根目录就叫做`CMTApp`，用Xcode跑工程的时候一切都没问题，但是如果想要用命令`react-native run-ios`跑工程是不行的。这是因为ReactNative是跨平台的，iOS工程需要放在`ios`目录下，安卓工程放在`android`目录下，它才能分辨出来。

      想要用命令跑工程的话，得改下native app的根目录名称。（记得改完目录名重新`pod install`下）

      ![proj_path](https://github.com/AllenSWB/notes/blob/master/src/imgs/reactnative//proj_path.PNG)

# 参考资料

## 视频

+ [80节实战课精通RN开发](https://www.youtube.com/watch?v=PHnM1sD30dY&list=PLXbU-2B80FvDgo7wQjdu5zAJG2boO9q2C)

### 文档

+ [es6入门 by 阮一峰](http://es6.ruanyifeng.com/)
+ [给所有开发者的React Native详细入门指南](https://juejin.im/post/5898388b128fe1006cb943e3#heading-6)
+ [React教程 by 菜鸟教程](http://www.runoob.com/react/react-tutorial.html)



