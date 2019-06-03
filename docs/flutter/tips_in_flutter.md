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

---
// todo list

1. Flutter中使用2倍图、3倍图
2. 获取设备信息 https://segmentfault.com/a/1190000014913010?utm_source=index-hottest



