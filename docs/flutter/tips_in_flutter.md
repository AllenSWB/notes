# tips in Flutter

1. 打开视觉调试开关

  ```dart
    // 1. 在main.dart中导入头文件
    import 'package:flutter/rendering.dart';
    // 2. 在main方法中加入下面一行代码
    main () async {
      debugPaintSizeEnabled = true;      //打开视觉调试开关
      runApp(MyApp());
    } 
  ```

2. SingleChildScrollView嵌套ListView，防止内部的ListView滚动，设置`primary: false`

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

3. 判断当前设备平台

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

4. 获取屏幕宽高
   
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
   
5. `pubspec.ymal`文件中的`dev_dependencies`和`dependencies`区别

    > pubspec.ymal文件：https://dart.dev/tools/pub/pubspec

    + `dependencies`：工程所依赖的库放在这里；[官方释义点我](https://dart.dev/tools/pub/pubspec#dependencies)
    + `dev_dependencies`：仅在开发阶段才使用到的库放在这里；

6. `flutter attach`让你跑native工程也能享受hot-reload
   
   ![flutter-attach](../../src/imgs/flutter/flutter-attach.png)

7. 修改`app`名和`logo`

    - 名称：
    
      `iOS`是`info.plist`文件中修改，`Android`在`AndroidManifest.xml`文件中修改。两个名字可以不一致。

    - `Logo`：
    
      `iOS` 是在 `AppIcon.appiconset` 文件夹中添加对应 `Logo` 图标，并在 `Contents.json` 中进行配置，`Android` 是添加图片在 `mipmap` 文件夹中，并在 `AndroidManifest.xml` 中修改 
   
---
// todo list

1. Flutter中使用2倍图、3倍图
2. 获取设备信息 https://segmentfault.com/a/1190000014913010?utm_source=index-hottest



