# 基础知识

## 更新 Flutter 版本

  ```shell
    # 更新(加上--force参数，代表强制更新，会把你对flutter sdk本地修改直接丢弃)
    flutter upgrade --force
  ```

  ![upgrade_force](/Users/wb/Desktop/Github/notes/src/imgs/flutter/tips/upgrade_force.png)

## 打开视觉调试开关

  ```dart
    // 1. 在main.dart中导入头文件
    import 'package:flutter/rendering.dart';
    // 2. 在main方法中加入下面一行代码
    main () async {
      debugPaintSizeEnabled = true;      //打开视觉调试开关
      runApp(MyApp());
    } 
  ```

## 判断当前设备平台

  ```dart
    // 导入头文件
    import 'dart:io';
    // 调用方法
    if (Platform.isIOS) {
      print('iOS');
    } else if (Platform.isAndroid) {
      print('安卓');
    } else if (Platform.isWindows) {
      print('Windows');
    } else if (Platform.isFuchsia) {
      print('Fuchsia');
    } else if (Platform.isLinux) {
      print('Linux');
    } else if (Platform.isMacOS) {
      print('Mac OS');
    }
  ```

## 判断当前是 debug 还是 product

  ```dart
    bool inProduction = const bool.fromEnvironment("dart.vm.product");//当前是否是production环境
  ```

## 获取屏幕宽高

   ```dart
      import 'dart:ui';
      import 'package:flutter/material.dart';

      /// 返回屏幕宽
      double wbScreenWidth(BuildContext context) {
        return wbScreenSize(context).width;
      }

      /// 返回屏幕高
      double wbScreenHeight(BuildContext context) {
        return wbScreenSize(context).height;
      }

      Size wbScreenSize(BuildContext context) {
        return MediaQuery.of(context).size;
      }
   ```

## `flutter attach` 让你跑 native 工程也能享受 hot-reload

   [flutter attach 文档](https://github.com/flutter/flutter/wiki/Add-Flutter-to-existing-apps#hot-restartreload-and-debugging-dart-code-1)

   ![flutter-attach](/Users/wb/Desktop/Github/notes/src/imgs/flutter/flutter-attach.png)

## 修改 `app` 名和 `logo`

  - 名称：

    `iOS`是`info.plist`文件中修改，`Android`在`AndroidManifest.xml`文件中修改。两个名字可以不一致。

  - `Logo`：

    `iOS` 是在 `AppIcon.appiconset` 文件夹中添加对应 `Logo` 图标，并在 `Contents.json` 中进行配置，`Android` 是添加图片在 `mipmap` 文件夹中，并在 `AndroidManifest.xml` 中修改 

## 自动选择二倍图三倍图资源

  ![auto_select_img](/Users/wb/Desktop/Github/notes/src/imgs/flutter/tips/auto_select_img.png)

  eg: 

  1. 在`/resources`目录下放入三个不同倍率的图片

     ![auto_select_img_step1](/Users/wb/Desktop/Github/notes/src/imgs/flutter/tips/auto_select_img_step1.png)

  2. 在`pubspec.ymal`里引入资源

     ![auto_select_img_step2](/Users/wb/Desktop/Github/notes/src/imgs/flutter/tips/auto_select_img_step2.png)

  3. 使用

     ```dart
       child: Center(
           child: Image(image: AssetImage('resources/atestimg.png'),)
       ),
     ```

  4. 效果 (在6Plus上)

     ![auto_select_img_step4](/Users/wb/Desktop/Github/notes/src/imgs/flutter/tips/auto_select_img_step4.png)

## StatelessWidget 和 StatefulWidget 区别

StatelessWidget：无状态 Widget

StatefulWidget：有状态 Widget

## 使用 setState 方法更新状态

```dart
class BWHome extends StatefulWidget {
@override
  State<StatefulWidget> createState() => BWHomeState();
}

class BWHomeState extends State<BWHome> {
  void itemAcion(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
```

## 使用三方库

https://pub.dev/

```yaml
dependencies:
  dio: ^3.0.0
```

## `dev_dependencies` 和 `dependencies` 区别

  > pubspec.ymal文件：https://dart.dev/tools/pub/pubspec

  + `dependencies`：工程所依赖的库放在这里；[官方释义点我](https://dart.dev/tools/pub/pubspec#dependencies)
  + `dev_dependencies`：仅在开发阶段才使用到的库放在这里；

## 使用 typedef

```dart
typedef BwActionButtonTapAction  = void Function();

class BwActionButton extends StatelessWidget {
  final BwActionButtonTapAction tapAction;
}
```

## 十六进制颜色

```dart
import 'package:flutter/material.dart';

class ColorsUtil {
   /// 十六进制颜色，
   /// hex, 十六进制值，例如：0xffffff,
   /// alpha, 透明度 [0.0,1.0]
   static Color hexColor(int hex,{double alpha = 1}){
    if (alpha < 0){
      alpha = 0;
    }else if (alpha > 1){
      alpha = 1;
    }
    return Color.fromRGBO((hex & 0xFF0000) >> 16 ,
         (hex & 0x00FF00) >> 8,
         (hex & 0x0000FF) >> 0,
         alpha);
   }
}

// 使用
ColorsUtil.hexColor(0x3caafa)//透明度为1
ColorsUtil.hexColor(0x3caafa,alpha: 0.5)//透明度为0.5
```

## final 和 const

`final` 常量一经赋值就不可更改

`const` 是编译时常量，比 `final` 更严格

## extends 、Minxins、implements、abstract

`extends`：继承

minxins：混合。使用关键字 `with`

```dart
class A {
  void testA() {
    print('test a');
  }
}

class B with A {

}

// B 的实例可以使用 A 中的方法
B obj = B();
obj.testA();	// test a
```

`implements` ：接口实现。iOS中的代理？？？

```dart
class _TextFieldState extends State<TextField> implements TextSelectionGestureDetectorBuilderDelegate {
}
```

## 异步

```dart
  Future<Response<T>> request<T>(
    String path, {
    data,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    return _request<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
```

# 踩坑记录

## 热重载【r】错误：`Error 105 received from application: Isolate must be runnable`

  + https://github.com/flutter/flutter/issues/26568
  + https://github.com/flutter/flutter/issues/26953

  表现：app里的flutter界面白屏，使用【r】hot-reload报错

  ![hot_reload_error_isolate](/Users/wb/Desktop/Github/notes/src/imgs/flutter/hot_reload_error_isolate.png)

## 真机运行，flutter run报错 : Error connecting to the service protocol: HttpException

  ![flutter_err_httpexc](/Users/wb/Desktop/Github/notes/src/imgs/flutter/tips/flutter_err_httpexc.png)

## Runner找不到头文件

  ![flutter_err_install](/Users/wb/Desktop/Github/notes/src/imgs/flutter/tips/flutter_err_install.png)

## [VERBOSE-2:ui_dart_state.cc(148)] Unhandled Exception: NoSuchMethodError: Class 'Window' has no instance setter 'onReportTimings='.

  + [参考链接](https://github.com/brianegan/flutter_redux/issues/142)

  解决方法：把flutter sdk版本换成stabel版本

## 本地图片加载不出来
> [flutter加载本地图片趟坑](https://www.jianshu.com/p/c6135bc044e4)

pubspec.ymal 中 assets 要和 uses-material-design 一栏左对齐

## BottomNavigationBarItem 的标题不显示
> [BottomNavigationBar 常见问题](https://www.jianshu.com/p/7274bad9f7ec)

设置 showUnselectedLabels: true

## GestureDetector 空白部分不能响应事件

设置 behavior: HitTestBehavior.opaque 

## SingleChildScrollView 嵌套 ListView，防止内部的 ListView 滚动，设置`primary: false`

  ```dart
      ListView.builder(
         itemExtent: 88,
         itemCount: 3,
         shrinkWrap: true,
         primary: false, // 当我们使用SingleChildScrollView 整个布局包含了ListView 滑动时会产生冲突 滚动卡顿，不流畅。要关闭这个属性
         itemBuilder: (BuildContext context ,int index) {
           return OrderListCell();
         },
      ),
  ```

## 类似 iOS 的 present 效果，从底部弹出一个新页面

设置 MaterialPageRoute 的 fullscreenDialog: true 

## Text 不换行

```dart
// 使用 Expanded 包裹 Text
Expanded(child: Text('我已阅读并同意《宝沃会员服务条款》《用户隐私协议》')),
```


# 参考资料

## Blog

- [Flutter 笔记](https://github.com/AllenSWB/notes#flutter)
- [Flutter 驿站](http://wiki.10101111.com/pages/viewpage.action?pageId=194938325)
- [善用 Provider 榨干 Flutter 的最后一点性能](https://juejin.im/post/5e3a93f0f265da57337cf29e)
- [Flutter Provider 3.0 实战教程](https://juejin.im/post/5d2c19c6e51d4558936aa11c)
- [手把手教你分离 flutter iOS 编译产物](https://juejin.im/post/5e5a492be51d452716050a11)

## Github 

- [dio](https://github.com/flutterchina/dio/blob/master/README-ZH.md)
- [dna](https://github.com/Assuner-Lee/dna)
- [仿滴滴](https://github.com/Sky24n/GreenTravel)

# todo

- 纯色 Checkbox
- oc 思想的 flutter 组件  。 tableview 代理
- 混编 Flutter Module、
- flutter_boost 导航栏管理、
- Packages Plugin 插件开发
- 常用Widget、布局、手势、
- 三层树原理 Widget Element RenderObject
- 状态管理、 provider
- 路由
- 持久化
- 多线程异步 await
- 动画 
  1. Flutter中使用2倍图、3倍图
  2. 获取设备信息 https://segmentfault.com/a/1190000014913010?utm_source=index-hottest
  3. 一个channel处理1万个方法，和一千个channel，每个处理10个方法，性能可能前者更好吧？
  4. 页面跳转的方式；push栈 ；router
  5. 页面间传参数
  6. 下层widget通知上层widget更高state
  7. bloc 状态

- 通知
- 页面跳转
  + stack
  + router
- 页面间传递参数
- 返回按钮拦截  onwillpop
- 手势处理
- 状态管理 bloc
