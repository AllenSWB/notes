- [链接](#链接)
- [Code](#code)
  - [自动选择二倍图三倍图资源](#自动选择二倍图三倍图资源)
  - [StatelessWidget 和 StatefulWidget 区别](#statelesswidget-和-statefulwidget-区别)
  - [使用 setState 方法更新状态](#使用-setstate-方法更新状态)
  - [extends 、Minxins、implements、abstract](#extends-minxinsimplementsabstract)
- [踩坑记录](#踩坑记录)
  - [热重载【r】错误：`Error 105 received from application: Isolate must be runnable`](#热重载r错误error-105-received-from-application-isolate-must-be-runnable)
  - [真机运行，flutter run报错 : Error connecting to the service protocol: HttpException](#真机运行flutter-run报错--error-connecting-to-the-service-protocol-httpexception)
  - [Runner找不到头文件](#runner找不到头文件)
  - [[VERBOSE-2:ui_dart_state.cc(148)] Unhandled Exception: NoSuchMethodError: Class 'Window' has no instance setter 'onReportTimings='.](#verbose-2ui_dart_statecc148-unhandled-exception-nosuchmethoderror-class-window-has-no-instance-setter-onreporttimings)


# 链接

+ [Flutter 实践 - 语雀文档](https://www.yuque.com/docs/share/6b275965-74d5-41b4-8879-8d39ffa1622e?)
+ [马蜂窝Flutter分享观后感 - 20190521](https://shimo.im/slides/mqu8dFUTkpAPRuwT/) 

# Code
 
## 自动选择二倍图三倍图资源

  ![auto_select_img](./imgs/tips/auto_select_img.png)

  eg: 

  1. 在`/resources`目录下放入三个不同倍率的图片

     ![auto_select_img_step1](./imgs/tips/auto_select_img_step1.png)

  2. 在`pubspec.ymal`里引入资源

     ![auto_select_img_step2](./imgs/tips/auto_select_img_step2.png)

  3. 使用

     ```dart
       child: Center(
           child: Image(image: AssetImage('resources/atestimg.png'),)
       ),
     ```

  4. 效果 (在6Plus上)

     ![auto_select_img_step4](./imgs/tips/auto_select_img_step4.png)

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
# 踩坑记录

## 热重载【r】错误：`Error 105 received from application: Isolate must be runnable`

  + https://github.com/flutter/flutter/issues/26568
  + https://github.com/flutter/flutter/issues/26953

  表现：app里的flutter界面白屏，使用【r】hot-reload报错

  ![hot_reload_error_isolate](../../src/imgs/flutter/hot_reload_error_isolate.png)

## 真机运行，flutter run报错 : Error connecting to the service protocol: HttpException

  ![flutter_err_httpexc](./imgs/tips/flutter_err_httpexc.png)

## Runner找不到头文件

  ![flutter_err_install](./imgs/tips/flutter_err_install.png)

## [VERBOSE-2:ui_dart_state.cc(148)] Unhandled Exception: NoSuchMethodError: Class 'Window' has no instance setter 'onReportTimings='.

  + [参考链接](https://github.com/brianegan/flutter_redux/issues/142)

  解决方法：把flutter sdk版本换成stabel版本

 
