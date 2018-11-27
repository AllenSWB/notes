# flutter学习2：入门

## Dart语言

0. [语言概览](https://www.dartlang.org/guides/language/language-tour)

1. 概念

    + 所有可以放到变量(var)里的值都是对象，所有对象都是一个类的实例。eg: `numbers` 函数 `null`这些都是`object`
    + 支持泛型 eg: `List<int>`
    + `_`开头的变量是私有变量。eg: `_suggestions`

2. 语法

+ 变量

      var name = 'Bob';

      int count; // 一个变量默认值是 null。就算是numbers类型的变量，默认值也是null。因为在Dart里，所有的都是对象。

+ 常量

        // final 一经赋值就不可再更改。
        final name = 'Jo';

        // Const variables are implicitly final.
        const name = 'Mike';

+ 基础类型

    + `numbers` (int double)
    + `string`
    + `booleans` (true false)
    + `lists` (数组)
    + `maps`  (key-value类型)
    + `runes` (for expressing Unicode characters in a string)
    + `symbols`

+ 函数

        // 返回值 函数名 参数
        Widget _buildList(WordPair pair) {
        return ...
        }

+ 单行函数使用 `=>` 符号

        void main() => runApp(MyApp()); 


## Flutter的一些基本概念

1. 热重载(`hot-reloading`): 无需重启应用程序就能实时加载修改后的代码，并且不会丢失状态。

    以下几种类型的更改无法热重载

    + 全局变量初始化器
    + 静态字段初始化程序
    + `main()`方法

2. 支持设备和系统

    + iOS8以上，iPhone5s之后
    + Android Jelly Bean, ARM Android设备

3. 核心原则：一切皆 `Widget`

    `Widget`的主要工作是提供一个`build()`方法来描述如何根据其他较低级别的`Widget`来显示自己。

4. 可变不可变的`Widget`
    
    + `StatelessWidge` 不可变的Widget

    + `StatefulWidge` 持有的状态可能在`widget`生命周期中发生变化. 实现一个 stateful widget 至少需要两个类:

        - 一个 `StatefulWidget`类。
        - 一个 `State`类。 StatefulWidget类本身是不变的，但是 State类在widget生命周期中始终存在.

5. 基础 `Widget`

    [widget目录](https://flutterchina.club/widgets/)  以下是常用的几个`Widget`

        Container 
            一个拥有绘制、定位、调整大小的 widget。
        Row 
            在水平方向上排列子widget的列表
        Column 
            在垂直方向上排列子widget的列表
        Image 
            一个显示图片的widget
        Text 
            单一格式的文本
        Icon 
            A Material Design icon.
        RaisedButton 
            按钮，一个凸起的材质矩形按钮
        Scaffold 
            此类提供了用于显示drawer、snackbar和底部sheet的API
        Appbar
            一个Material Design应用程序栏，由工具栏和其他可能的widget（如TabBar和FlexibleSpaceBar）组成。
        FlutterLogo
            Flutter logo, 以widget形式. 这个widget遵从IconTheme
        Placeholder 
            一个绘制了一个盒子的的widget，代表日后有widget将会被添加到该盒子中

        Scaffold
            是 Material library 中提供的一个widget, 它提供了默认的导航栏、标题和包含主屏幕widget树的body属性。widget树可以很复杂。

6. `Widget`只是`UI`的描述。它本身是轻量的，因为它不是控件，也不会直接绘制。

7. 通过操作`State`来更新`Widget`

8. iOS中通常使用cocoapods管理三方库，对应的flutter中使用`podspec.ymal`中声明外部依赖，资源在[pub](https://pub.dartlang.org/flutter/packages/)。