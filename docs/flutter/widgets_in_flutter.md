# Widgets in Flutter

> - widget目录  https://flutterchina.club/widgets/
> - 在Flutter中构建布局 https://flutterchina.club/tutorials/layout/
> - 《flutter实战》 https://book.flutterchina.club/

Flutter里一切都是Widget，视图、布局、手势、动画等等都是Widget.

## 界面相关Widget

> - 可见Widget：界面上可见的视图 eg : Text、Image等；
>   - Flutter提供了两种风格的视图库：Cupertino风格(苹果)、Material风格
> - 不可见Widget：
>   容器类和布局类Widget都作用于其子Widget
>   - 布局Widget：一般接收一个Widget数组 `children`，他们直接或间接继承自(或包含)`MultiChildRenderObjectWidget`；按照一定的排列方式来对其子Widget进行排列；
>   - 容器Widget：一般接收一个子Widget `child`,他们直接或间接继承自(或包含)`SingleChildRenderObjectWidget`；一般只包装子Widget，对其添加一些修饰(加边距、背景色等)、变换(旋转或剪裁)、限制(大小等)；

打开视觉调试开关

  ```dart
    /// 在main.dart中导入头文件 import 'package:flutter/rendering.dart';
    /// 添加代码
    void main () {
      debugPaintSizeEnabled = true;      //打开视觉调试开关
      runApp(BwcmtFlutterApp());
    } 
  ```
  ![view_debug](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/view_debug.png)
  

### 基础Widget

1. Text
   
   ```dart
     const Text(
       this.data, {
       Key key,
       this.style,
       this.strutStyle,
       this.textAlign,    // TextAlign类型，布局，有值left、right、center、justify等
       this.textDirection,
       this.locale,
       this.softWrap,
       this.overflow,
       this.textScaleFactor,
       this.maxLines,     // 指定显示最大行数，默认文本自动折行，
       this.semanticsLabel,
     })
   ```

2. Button

    eg: 自定义button `MaterialButton`

    ![btn_material](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/btn_material.png)
    ![btn_raised](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/btn_raised.png)
    ![btn_flat](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/btn_flat.png)
    ![btn_outline](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/btn_outline.png)
    ![btn_icon](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/btn_icon.png)


3. Image
   
    ```dart
        const Image({
          Key key,
          @required this.image,   // ImageProvider类型，这是一个抽象类型，主要定义了图片数据获取的接口load()，从不同的数据源获取图片，需要实现不同的ImageProvider。
          this.semanticLabel,
          this.excludeFromSemantics = false,
          this.width,
          this.height,
          this.color,
          this.colorBlendMode,
          this.fit,
          this.alignment = Alignment.center,
          this.repeat = ImageRepeat.noRepeat,
          this.centerSlice,
          this.matchTextDirection = false,
          this.gaplessPlayback = false,
          this.filterQuality = FilterQuality.low,
        }) 
    ```
      + 将图片放入工程

        ![img_to_proj](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/img_to_proj.png)  

      + 在`pubspec.ymal`里添加`assets`

        ![asset_ymal](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/asset_ymal.png)  

      + 使用

        ![img](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/img.png)

### 布局Widget

> 对于线性布局，有**主轴**、**纵轴**之分

1. Row 
   
   > 线性布局，沿水平方向布局子Widget。主轴水平方向、纵轴垂直方向。
    ```dart
      Row({
       Key key,
       MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start, // 表示子widgets在Row所占用的水平空间内对其方式。有值.start .end .center
       MainAxisSize mainAxisSize = MainAxisSize.max,  // 表示Row在主轴方向占用的空间。默认是MainAxisSize.max，尽可能多的占用主轴方向的空间，此时无论子Widget实际占用多少空间，row的宽度始终等于水平方向的最大宽度；MainAxisSize.min，表示尽可能少的占用主轴方向的空间。
       CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center, // 表示子Widgets在纵轴方向的对齐方式。
       TextDirection textDirection,     // 布局顺序：ltr从左到右 rtl从右到左
       VerticalDirection verticalDirection = VerticalDirection.down,  // 纵轴的对齐方向，默认 .down 从上往下。
       TextBaseline textBaseline,
       List<Widget> children = const <Widget>[],
      })
    ```
    ![row](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/row.png)

2. Column
   
   > 线性布局，沿垂直方向布局子Widget。主轴垂直方向、纵轴水平方向
    ```dart
       Column({
          Key key,
          MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
          MainAxisSize mainAxisSize = MainAxisSize.max,
          CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
          TextDirection textDirection,
          VerticalDirection verticalDirection = VerticalDirection.down,
          TextBaseline textBaseline,
          List<Widget> children = const <Widget>[],
       })
    ```


3. Flex

   > 弹性布局， 上面说的`Row`和`Column`都是继承自`Flex`的。 
   > 弹性布局允许子Widget按照一定比例来分配父容器空间。Flutter中弹性布局主要通过`Flex`和`Expanded`来配合实现。

   `Flex`可以沿着水平或垂直方向排列子Widget。如果知道主轴方向，可以直接使用`Row`或者`Column`。继承自`MultiChildRenderObjectWidget`，对应的`RenderOjbect`是`RenderFlex`，`RenderFlex`中实现了其布局算法。

   ```dart
    Flex({
      @required this.direction,   // 弹性布局的方向, Row默认为水平方向，Column默认为垂直方向
      List<Widget> children = const <Widget>[],
    })
   ``` 

4. Expanded
   
   可以按比例扩伸`Row`、`Colume`或`Flex`子Widget所占的空间。
    ```dart
        const Expanded({
          Key key,
          int flex = 1,   // 弹性系数，为0或null的时候，子Widget没有弹性(不会被扩伸占用的空间。如果大于0，所有Expanded按照其flex的比例分割主轴的全部空闲空间。
          @required Widget child,
        })
    ```
      ![flex0](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/flex0.png)
      ![flex1](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/flex1.png)

5. Wrap

    > 流式布局：超出屏幕显示范围会自动折行的布局。

      在线性布局Row(Column)中，如果子Widget超出屏幕返回就会报溢出的错误。

      ![row_overflow](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/row_overflow.png)

      这时候就需要用流式布局来解决这个问题。

    ```dart
      Wrap({
       Key key,
       this.direction = Axis.horizontal,
       this.alignment = WrapAlignment.start,
       this.spacing = 0.0,                              // 主轴方向子Widget的间距
       this.runAlignment = WrapAlignment.start,         // 纵轴方向的对齐方式。
       this.runSpacing = 0.0,                           // 纵轴方向子Widget的间距
       this.crossAxisAlignment = WrapCrossAlignment.start,
       this.textDirection,
       this.verticalDirection = VerticalDirection.down,
       List<Widget> children = const <Widget>[],
     })
    ```
    ![wrap](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/wrap.png)

  
6. Flow
   
    > 流式布局

    ![flow_desc](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/flow_desc.png)

    ```dart
      /////////// Flow

      Flow({
        Key key,
        @required this.delegate,   // FlowDelegate类型，布局child widgets
        List<Widget> children = const <Widget>[],
      }) 

      /////////// FlowDelegate
      abstract class FlowDelegate {
        /// The flow will repaint whenever [repaint] notifies its listeners.
        const FlowDelegate({ Listenable repaint }) : _repaint = repaint;
        final Listenable _repaint;

        /// 设置Flow的尺寸；
        Size getSize(BoxConstraints constraints) => constraints.biggest;

        /// 设置每个child的布局约束条件，会覆盖已有的；
        BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) => constraints;

        /// child的绘制控制代码，可以调整尺寸位置；
        void paintChildren(FlowPaintingContext context);

        /// 是否需要重新布局。
        bool shouldRelayout(covariant FlowDelegate oldDelegate) => false;

        /// 是否需要重绘；
        bool shouldRepaint(covariant FlowDelegate oldDelegate);
      }

      ////////////// FlowPaintingContext ： 包装了一些布局child的必要数据 以及 child布局方法
      abstract class FlowPaintingContext {
        /// The size of the container in which the children can be painted.
        Size get size;

        /// The number of children available to paint.
        int get childCount;

        /// The size of the [i]th child.
        Size getChildSize(int i);

        /// Paint the [i]th child using the given transform.
        void paintChild(int i, { Matrix4 transform, double opacity = 1.0 });
      }
    ```

7. Stack
   
   > 层叠布局

   ```dart
     Stack({
       Key key,
       this.alignment = AlignmentDirectional.topStart,  // 此参数决定如何去对齐没有定位（没有使用Positioned）或部分定位的子widget。所谓部分定位，在这里特指没有在某一个轴上定位：left、right为横轴，top、bottom为纵轴，只要包含某个轴上的一个定位属性就算在该轴上有定位
       this.textDirection,    // 枚举TextDirection，从左到右ltr 从右到左rtl
       this.fit = StackFit.loose, // 枚举StackFit，使用子widget的大小loose、扩伸到Stack的大小expand、passthrough
       this.overflow = Overflow.clip, // 枚举Overflow，超出边界的子Widget可见visible，不可见clip
       List<Widget> children = const <Widget>[],
     })
   ```

8. Positioned
  
   > 层叠布局

   ```dart
     const Positioned({
       // left、top 、right、 bottom分别代表离Stack左、上、右、底四边的距离
       // width和height用于指定定位元素的宽度和高度，
       // 注意，此处的width、height 和其它地方的意义稍微有点区别，此处用于配合left、top 、right、 bottom来定位widget，举个例子，在水平方向时，你只能指定left、right、width三个属性中的两个，如指定left和width后，right会自动算出(left+width)，如果同时指定三个属性则会报错，垂直方向同理。
       Key key,
       this.left, 
       this.top,
       this.right,
       this.bottom,
       this.width,
       this.height,
       @required Widget child,
     })
   ```

    ![Positioned](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/Positioned.png)    

### 容器Widget

1. Container  
    > 容器
     ```dart
      Container({
       Key key,
       this.alignment,              // AlignmentGeometry类型
       this.padding,                // EdgeInsetsGeometry类型
       Color color,
       Decoration decoration,       // Decoration类型
       this.foregroundDecoration,
       double width,
       double height,
       BoxConstraints constraints,  // BoxConstraints类型
       this.margin,                 // EdgeInsetsGeometry类型
       this.transform,              // Matrix4类型
       this.child,
      })
     ```

    - `color`和`decoration`不能同时存在，否则会报错. `The color argument is just a shorthand for "decoration: new BoxDecoration(color: color)".`

      ![color_decoration](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/color_decoration.png)

     
2. Padding
    > 边距

    给子节点添加补白。`EdgeInsetsGeometry`是抽象类，编码时候我们经常用到的是它的子类`EdgeInset`。

     ```dart
      // 分别指定四个方向的补白（就是设置内容部分的四个边距）
       EdgeInsets.fromLTRB(double left, double top, double right, double bottom) → EdgeInsets

      // 所有方向使用相同数值的补白（居中）
       EdgeInsets.all(double value) → EdgeInsets

      // 指定某个方向的补白，可以指定多个方向
      // 入参都是可选的：
      // eg: 左边距20
      // padding: EdgeInsets.only(left: 20)  
       EdgeInsets.only({double left: 0.0, double top: 0.0, double right: 0.0, double bottom: 0.0}) → EdgeInsets
       
      // 设置对称方向的补白。vertical垂直方向:上下边距；horizontal水平方向:左右边距
       EdgeInsets.symmetric({double vertical: 0.0, double horizontal: 0.0}) → EdgeInsets

       EdgeInsets.fromWindowPadding(WindowPadding padding, double devicePixelRatio) → EdgeInsets

     ```
    
    ![padding](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/padding.png)
    
3. DecoratedBox
    > 装饰

    ```dart
      const DecoratedBox({
          Key key,
          @required this.decoration,  // Decoration类型，将要绘制的装饰。 Decoration是一个抽象类，定义了一个接口`createBoxPainter([ VoidCallback onChanged ])`,子类的主要职责是通过实现它来创建一个画笔，该画笔用于绘制装饰。
          this.position = DecorationPosition.background,  // 枚举 background背景 foreground前景
          Widget child,
      })
    ```
    `DecoratedBox`可以在子widget绘制前or后，绘制一个装饰Decoration(eg：背景、边框、圆角、阴影等效果)。

    我们通常直接用`Decoration`的子类`BoxDecoration`，它实现了常用的装饰的绘制。

       ```dart
         const BoxDecoration({
          this.color,          // 颜色
          this.image,          // DecorationImage类型，图片
          this.border,         // BoxBorder类型，边框
          this.borderRadius,   // BorderRadiusGeometry类型，圆角
          this.boxShadow,      // List<BoxShadow>类型，阴影，可以指定多个
          this.gradient,       // Gradient类型，渐变
          this.backgroundBlendMode,        // BlendMode类型，背景混合模式
          this.shape = BoxShape.rectangle, // BoxShape类型，形状
        })
       ```
      ![decoration](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/decoration.png)

4. ConstrainedBox
    > 约束

    用于对子Widget添加额外的约束
    
    ```dart
    const BoxConstraints({
     this.minWidth = 0.0,
     this.maxWidth = double.infinity,
     this.minHeight = 0.0,
     this.maxHeight = double.infinity,
    })
    ```

    ![constraintbox](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/constraintbox.png)

    **多重限制**
    - 有多重限制时，对于minHeight&minWidth来说，是取父子中比较**大**的那个值。
      ![muti_constraint_0](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/muti_constraint_0.png)
    - 有多重限制时，对于maxHeight&maxWidth来说，是取父子中比较**小**的那个值。
      ![muti_constraint_1](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/muti_constraint_1.png)
5. SizeBox

    `SizeBox`用于指定子Widget固定宽高，它只是`ConstrainedBox`的一个定制。

    ![sizebox](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/sizebox.png)

6. Transform

7. Scaffold

8. TabBar

### 可滚动Widget

> ViewPort视口：指一个widget的实际显示区域
> 主轴：滚动方向
> 纵轴：非滚动方向

可滚动的Widget都直接或间接的包含一个`Scrollable`。

```dart
    const Scrollable({
       this.axisDirection = AxisDirection.down,  // 滚动方向，默认向下。
       this.controller,     // ScrollController类型。ScrollController的主要作用是控制滚动位置和监听滚动事件。默认情况下，widget树中会有一个默认的PrimaryScrollController，如果子树中的可滚动widget没有显式的指定controller并且primary属性值为true时（默认就为true），可滚动widget会使用这个默认的PrimaryScrollController，这种机制带来的好处是父widget可以控制子树中可滚动widget的滚动，例如，Scaffold使用这种机制在iOS中实现了"回到顶部"的手势。我们将在本章后面“滚动控制”一节详细介绍ScrollController。
       this.physics,    // ScrollPhysics类型。它决定可滚动Widget如何响应用户操作，比如用户滑动完抬起手指后，继续执行动画；或者滑动到边界时，如何显示。默认情况下，Flutter会根据具体平台分别使用不同的ScrollPhysics对象，应用不同的显示效果，如当滑动到边界时，继续拖动的话，在iOS上会出现弹性效果，而在Android上会出现微光效果。如果你想在所有平台下使用同一种效果，可以显式指定，Flutter SDK中包含了两个ScrollPhysics的子类可以直接使用：ClampingScrollPhysics：Android下微光效果、 BouncingScrollPhysics：iOS下弹性效果。
       @required this.viewportBuilder,
       this.excludeFromSemantics = false,
       this.semanticChildCount,
       this.dragStartBehavior = DragStartBehavior.start,
     })

     // Scrollbar是一个Material风格的滚动指示器（滚动条），如果要给可滚动widget添加滚动条，只需将Scrollbar作为可滚动widget的父widget即可
     Scrollbar(
        child: SingleChildScrollView(
          ...
        ),
     );
     // Scrollbar和CupertinoScrollbar都是通过ScrollController来监听滚动事件来确定滚动条位置
     // CupertinoScrollbar是iOS风格的滚动条，如果你使用的是Scrollbar，那么在iOS平台它会自动切换为CupertinoScrollbar。

```

1. SingleChileScrollView

    ```dart
      const SingleChildScrollView({
       Key key,
       this.scrollDirection = Axis.vertical,  // 滚动方向，垂直方向vertical(default value)、horizontal水平方向
       this.reverse = false,  // 是否按照阅读方向相反的方向滑动
       this.padding,
       bool primary,  // 指是否使用widget树中默认的PrimaryScrollController；当滑动方向为垂直方向（scrollDirection值为Axis.vertical）并且controller没有指定时，primary默认为true.
       this.physics,
       this.controller,
       this.child,
       this.dragStartBehavior = DragStartBehavior.start,
     })
    ```

      ![singlechildscrollview](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/singlechildscrollview.png)

2. ListView

    ```dart
      (new) ListView({
          Key key,
          Axis scrollDirection: Axis.vertical,    // 滚动方向，垂直方向vertical(default value)、horizontal水平方向
          bool reverse: false,                    // 是否按照阅读方向相反的方向滑动
          ScrollController controller,            
          bool primary,                           // 指是否使用widget树中默认的PrimaryScrollController
          ScrollPhysics physics, 
          bool shrinkWrap: false,                 // 该属性表示是否根据子widget的总长度来设置ListView的长度，默认值为false 。默认情况下，ListView的会在滚动方向尽可能多的占用空间。当ListView在一个无边界(滚动方向上)的容器中时，shrinkWrap必须为true。
          EdgeInsetsGeometry padding, 
           double itemExtent,                     // 该参数如果不为null，则会强制children的"长度"为itemExtent的值；这里的"长度"是指滚动方向上子widget的长度，即如果滚动方向是垂直方向，则itemExtent代表子widget的高度，如果滚动方向为水平方向，则itemExtent代表子widget的长度。
           bool addAutomaticKeepAlives: true,     // 该属性表示是否将列表项（子widget）包裹在AutomaticKeepAlive widget中；典型地，在一个懒加载列表中，如果将列表项包裹在AutomaticKeepAlive中，在该列表项滑出视口时该列表项不会被GC，它会使用KeepAliveNotification来保存其状态。如果列表项自己维护其KeepAlive状态，那么此参数必须置为false。
           bool addRepaintBoundaries: true,       // 该属性表示是否将列表项（子widget）包裹在RepaintBoundary中。当可滚动widget滚动时，将列表项包裹在RepaintBoundary中可以避免列表项重绘，但是当列表项重绘的开销非常小（如一个颜色块，或者一个较短的文本）时，不添加RepaintBoundary反而会更高效。和addAutomaticKeepAlive一样，如果列表项自己维护其KeepAlive状态，那么此参数必须置为false。
           bool addSemanticIndexes: true, 
           double cacheExtent, 
           List<Widget> children: const <Widget>[], 
           int semanticChildCount, 
           DragStartBehavior dragStartBehavior: DragStartBehavior.start}) 

    ```
    三种创建ListView的方法:
   
      - **I. 默认构造函数**

          这种方式接收一个widget list，适合只有少量子widg的情况。因为这种方式会提前将所有的children创建好，而不是等到子widget真正显示的时候才创建。

          ![listview_create_1](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/listview_create_1.png)

      - **II. `ListView.builder`**

          适合列表项比较多（或者无限）的情况，因为只有当子Widget真正显示的时候才会被创建。
          
          ```dart
            (new) ListView.builder({
               (BuildContext, int) → Widget itemBuilder, 
               int itemCount, 
               // 更多参数已省略
            }) → ListView
          ```

          ![listview_create_2](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/listview_create_2.png)

      - **III. `ListView.separated`**

          可以生成列表项之间的分割器，它比ListView.builder多了一个separatorBuilder参数，该参数是一个分割器生成器。

          ```dart
          (new) ListView.separated({
            (BuildContext, int) → Widget separatorBuilder, 
            // 更多参数已省略
          }) → ListView
          ```

          ![listview_create_3](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/listview_create_3.png)

    
    使用`ListTile`实现类似TableViewHeader的效果。

      ```dart
          //Material设计规范中状态栏、导航栏、ListTile高度分别为24、56、56 
            const ListTile({
             Key key,
             this.leading,
             this.title,
             this.subtitle,
             this.trailing,
             this.isThreeLine = false,
             this.dense,
             this.contentPadding,
             this.enabled = true,
             this.onTap,
             this.onLongPress,
             this.selected = false,
           })
      ```

      ![listtile](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/listtile.png)
        
    tip： 使用`ListTile`，需要将他放到一个Material风格的widget里面.

      ![listtil_err](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/widgets/listtil_err.png)

## 功能相关Widget

TODO

操作符 https://www.jianshu.com/p/64a6ed7581aa