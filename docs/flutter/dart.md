# Dart 

> - 语法预览  http://dart.goodev.org/guides/language/language-tour
> - 核心库预览 http://dart.goodev.org/guides/libraries/library-tour

## 语法

1. 字符串插值：在字符串字面量中引用变量或者表达式。 `$variableName` 、`${expression}`
  
   ```dart
    var number = 42; 
    print(The number is $number.);
   ```

2. 关键字

  ![keywords](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/dart/keywords.png)

3. `final`和`const`的区别
   
   `const`比`final`更严格。

   `final`是一个变量只能赋值一次，`const`是编译时常量。(一个const变量同时时final变量)。

   通过`final`，我们无法在编译时（运行之前）知道这个变量的值；而`const`所修饰的是编译时常量，我们在编译时就已经知道了它的值，显然，它的值也是不可改变的。

   ```dart
      int Func() {
        // 代码
      }

      final int m1 = 60;
      final int m2 = Func(); // 正确
      const int n1 = 42;
      const int n2 = Func(); // 错误
   ```

4. Dart内置类型
   
    - numbers
    - strings
    - booleans
    - lists (也被称之为 arrays)
    - maps
    - runes (用于在字符串中表示 Unicode 字符)
    - symbols

5. `Functions`方法
   
   方法也是一个对象，类型是`Functions`。也可以赋值给变量，可以当做其它方法的参数。

    ```dart
      bool isNoble(int atomicNumber) {
        return _nobleGases[atomicNumber] != null;
      }
    ```
   Effective Dart推荐：在公开的APIs上使用静态类型。你当然也可以选择忽略类型定义。

    ```dart
      isNoble(atomicNumber) {
        return _nobleGases[atomicNumber] != null;
      }
    ```

6. 方法 - 可选参数
   
   可选参数可以是命名参数，或者基于位置的参数。但是这两种参数不能同时当做可选参数。

   I. 可选命名参数

      ```dart
        // 使用 {param1, param2, ...}的方式来指定命名参数

        // eg： 
        void setMargin({double leftMargin, double rightMargin}) {
          print('left is $leftMargin, right is $rightMargin');
        }

        // 调用
        setMargin(leftMargin: 23);  // log: flutter: left is 23.0, right is null
      ```

   II. 可选位置参数

      ```dart
          // 把一些方法的参数放到 [] 中就变成可选 位置参数了

          // eg： 
          void setMargin(double leftMargin, [double rightMargin]) {
             if (rightMargin != null) {
               print('left margin is $leftMargin, right margin is $rightMargin');
             } else {
               print('only left margin exist, value is $leftMargin');
             }
           }

           // 调用
           setMargin(32);       // flutter: only left margin exist, value is 32.0
           setMargin(32, 99);   // flutter: left margin is 32.0, right margin is 99.0
      ```
7. 方法 - 默认参数值

      ```dart
        // 在定义方法的时候，可以使用 = 来定义可选参数的默认值。 默认值只能是编译时常量。 如果没有提供默认值，则默认值为 null。

        // eg： 设置可选默认参数值的示例
        void setMargin({double leftMargin = 32}) {
          print('left margin is $leftMargin');
        }

        // 调用
        setMargin(leftMargin: 232); // flutter: left margin is 232.0
        setMargin();                // flutter: left margin is 32.0
      ```

8. 匿名方法

    匿名方法有时候也被称为 lambda 或者 closure 闭包。

    ```dart
        // eg: 
        var iamclosure = ({String name}) => print('$name');

        print(iamclosure); // flutter: Closure: ({String name}) => void
    ```

    ![closure](https://github.com/AllenSWB/notes/blob/master/src/imgs/flutter/dart/closure.png)

9. 方法 - 返回值

   所有方法都有返回值。如果没有指定，则把语句`return null`作为函数的最后一个语句执行。

10. 操作符

    ```dart
        // 算数操作符
        +	    // 加号
        –	    // 减号
        -expr	// 负号
        *	    // 乘号
        /	    // 除号
        ~/	  // 除号，但是返回值为整数
        %	    // 取模

        // 递增、递减前缀 和后缀操作
        ++var	    // var = var + 1 (expression value is var + 1)
        var++	    // var = var + 1 (expression value is var)
        --var	    // var = var – 1 (expression value is var – 1)
        var--	    // var = var – 1 (expression value is var)

        // 相等相关的操作符
        ==	      // 相等
        !=	      // 不等
        >	        // 大于
        <	        // 小于
        >=        // 大于等于
        <=	      // 小于等于

        // 类型判定操作符
        as    	  // 类型转换
        is	      // 如果对象是指定的类型返回 True
        is!	      // 如果对象是指定的类型返回 False

        // 赋值操作符
        a = value;   // 给 a 变量赋值
        b ??= value; // 如果 b 是 null，则赋值给 b； 如果不是 null，则 b 的值保持不变  

        // 复合赋值操作符。 对于操作符op，表达式<a op= b>，等效于表达式 <a = a op b>;
        =	
        –=	
        /=	
        %=	
        >>=	
        ^=
        +=	
        *=	
        ~/=
        <<=	
        &=	
        |=

        // 逻辑操作符
        !expr	  //  对表达式结果取反（true 变为 false ，false 变为 true）
        ||	    //  逻辑 OR
        &&	    //  逻辑 AND

        // 位和移位操作符
        &	      //  AND
        |	      //  OR
        ^	      //  XOR
        ~expr	  //  Unary bitwise complement (0s become 1s; 1s become 0s)
        <<	    //  Shift left
        >>	    //  Shift right

        // 条件表达式
        condition ? expr1 : expr2     //  如果 condition 是 true，执行 expr1 (并返回执行的结果)； 否则执行 expr2 并返回其结果。
        expr1 ?? expr2                //  如果 expr1 是 non-null，返回其值； 否则执行 expr2 并返回其结果

        // 级联操作符
        .. // 级联操作符 (..) 可以在同一个对象上 连续调用多个函数以及访问成员变量。 使用级联操作符可以避免创建 临时变量， 并且写出来的代码看起来 更加流畅

        // eg: 
        querySelector('#button') // Get an object.
          ..text = 'Confirm'   // Use its members.
          ..classes.add('important')
          ..onClick.listen((e) => window.alert('Confirmed!'));

        // 等效于下面的代码
        var button = querySelector('#button');
        button.text = 'Confirm';
        button.classes.add('important');
        button.onClick.listen((e) => window.alert('Confirmed!'));

        // 其他操作符
        ()	//  使用方法	代表调用一个方法
        []	//  访问 List	访问 list 中特定位置的元素
        .	  //  访问 Member	访问元素，例如 foo.bar 代表访问 foo 的 bar 成员
        ?.	//  条件成员访问	和 . 类似，但是左边的操作对象不能为 null，例如 foo?.bar 如果 foo 为 null 则返回 null，否则返回 bar 成员
    ```

11. 流程控制语句

    - if and else
    - for loops
    - while and do-while loops
    - break and continue
    - switch and case
    - assert

12. 异常
  
    Dart提供了`Exception`和`Error`类型，以及一些子类型。开发者也可以定义自己的异常类型。Dart可以抛出任何**非null**的对象为异常。

    **I. Throw**

    ```dart
      throw new FormatException('Expected at least 1 section');
      throw 'Out of llamas!';
      distanceTo(Point other) =>  throw new UnimplementedError();
    ```

    **II. Catch**

    捕获异常可以避免异常继续传递。

    ```dart
        final foo = '';

        void misbehave() {
            try {
              foo = "You can't change a final variable's value.";
            } catch (e) {
               print('misbehave() partially handled ${e.runtimeType}.');
              rethrow; // 使用 rethrow 关键字可以 把捕获的异常给 重新抛出。
            }
        }

        void main() {
            try {
              misbehave();
            } catch (e) {
              print('main() finished handling ${e.runtimeType}.');
            }
        }
    ```

    **III. Finally**

    ```dart
        try {
          breedMoreLlamas();
        } catch(e) {
          print('Error: $e');  // Handle the exception first.
        } finally {
          cleanLlamaStalls();  // Then clean up.
        }
    ```

13. 类Class

    - 每个对象都是一个类的实例，所有的类都继承于 `Object`.
    - 每个类（`Object` 除外） 都只有一个超类，一个类的代码可以在其他 多个类继承中重复使用。
    - 对象的成员包括方法和数据 (函数 和 实例变量)。

14. 类 - 实例变量 Instance Variables

    ```dart
      class Point {
        num x;  // default value is null
        num y = 1;  // default value is 1
      }
    ```

    - 所有没有初始化的变量值都是`null`
    - 每个实例变量都会自动生成一个 getter 方法（隐含的）
    - Non-final 实例变量还会自动生成一个 setter 方法

15. 抽象类
    
    使用 abstract 修饰符定义一个 抽象类—一个不能被实例化的类。 抽象类通常用来定义接口， 以及部分实现

    + 抽象类通常具有 抽象函数。 下面是定义具有抽象函数的 抽象类的示例：

      ```dart
        // This class is declared abstract and thus
        // can't be instantiated.
        abstract class AbstractContainer {
          // ...Define constructors, fields, methods...
          void updateChildren(); // Abstract method.
        }

        // 下面的类不是抽象的，但是定义了一个抽象函数，这样 的类是可以被实例化的：
        class SpecializedContainer extends AbstractContainer {
          // ...Define more constructors, fields, methods...
          void updateChildren() {
            // ...Implement updateChildren()...
          }
          // Abstract method causes a warning but
          // doesn't prevent instantiation.
          void doSomething();
        }
      ```

16. 构造函数 Constructors

    > - 默认构造函数： 如果开发者没有定义构造函数，会有个默认的构造函数（无名，无参），这个默认构造函数会调用超类的没有参数的构造函数。
    > - 命名构造函数
    > - 重定向构造函数：有时候一个构造函数会调动类中的其他构造函数。 一个重定向构造函数是没有代码的，在构造函数声明后，使用 冒号调用其他构造函数。
    > - 常量构造函数
    > - 工厂方法构造函数

    定义一个和类名一样的方法，就是一个构造函数。

    ```dart
      class Point {
          num x;
          num y;

          Point(num x, num y) {
            // There's a better way to do this, stay tuned.
            this.x = x;
            this.y = y;
          }

          // 构造函数语法糖
          Point(this.x, this.y);
      }
    ```

    - 只有当名字冲突的时候才使用 this。否则的话， Dart 代码风格样式推荐忽略 this。
    - 如果你没有定义构造函数，则会有个默认构造函数。 默认构造函数没有参数，并且会调用超类的 没有参数的构造函数。
    - 子类不会继承超类的构造函数。 子类如果没有定义构造函数，则只有一个默认构造函数 （没有名字没有参数）。
    - 使用命名构造函数可以为一个类实现多个构造函数， 或者使用命名构造函数来更清晰的表明你的意图：

        ```dart
          class Point {
            num x;
            num y;

            Point(this.x, this.y);

            // Named constructor
            Point.fromJson(Map json) {
              x = json['x'];
              y = json['y'];
            }
          }
        ```

    - 默认情况下，子类的构造函数会自动调用超类的默认构造函数。
    - 超类的构造函数在子类构造函数体开始执行的位置调用。
    - 初始化列表
      
      使用逗号分隔初始化表达式。初始化列表非常适合用来设置 final 变量的值。

      ```dart
        class Point {
          num x;
          num y;

          Point(this.x, this.y);

          // Initializer list sets instance variables before
          // the constructor body runs.
          Point.fromJson(Map jsonMap)
              : x = jsonMap['x'],       //  初始化表达式等号右边的部分不能访问 this。
                y = jsonMap['y'] {
            print('In Point.fromJson(): ($x, $y)');
          }
        }
      ```

    - 如果提供了一个 initializer list（初始化参数列表） ，则初始化参数列表在超类构造函数执行之前执行

      ```dart
        //  下面是构造函数执行顺序：

        //  1. initializer list（初始化参数列表）
        //  2. superclass’s no-arg constructor（超类的无名构造函数）
        //  3. main class’s no-arg constructor（主类的无名构造函数）
      ```

    - 重定向构造函数 : 在构造函数声明后，使用 冒号调用其他构造函数。

      ```dart
        class Point {
          num x;
          num y;

          // The main constructor for this class.
          Point(this.x, this.y);

          // Delegates to the main constructor.
          Point.alongXAxis(num x) : this(x, 0);
        }
      ```

    - 常量构造函数：如果你的类提供一个状态不变的对象，你可以把这些对象 定义为编译时常量。要实现这个功能，需要定义一个 const 构造函数， 并且声明所有类的变量为 final。

      ```dart
        class ImmutablePoint {
          final num x;
          final num y;
          const ImmutablePoint(this.x, this.y);
          static final ImmutablePoint origin =
              const ImmutablePoint(0, 0);
        }
      ```

    - 工厂方法构造函数

      如果一个构造函数并不总是返回一个新的对象，则使用 factory 来定义 这个构造函数。例如，一个工厂构造函数 可能从缓存中获取一个实例并返回，或者 返回一个子类型的实例。

      工厂构造函数不能访问this

      ```dart
        //  下面代码演示工厂构造函数 如何从缓存中返回对象。
        class Logger {
          final String name;
          bool mute = false;

          // _cache is library-private, thanks to the _ in front
          // of its name.
          static final Map<String, Logger> _cache =
              <String, Logger>{};

          factory Logger(String name) {
            if (_cache.containsKey(name)) {
              return _cache[name];
            } else {
              final logger = new Logger._internal(name);
              _cache[name] = logger;
              return logger;
            }
          }

          Logger._internal(this.name);

          void log(String msg) {
            if (!mute) {
              print(msg);
            }
          }
        }

        // 使用 new 关键字来调用工厂构造函数。

        var logger = new Logger('UI');
        logger.log('Button clicked');
      ```

17. 类 - Methods 函数

    函数是类中定义的方法，是类对象的行为。

    **I. 实例函数**

      对象的实例函数可以访问 this。

    **II. setter & getter**

      - Getters 和 setters 是用来设置和访问对象属性的特殊 函数。每个实例变量都隐含的具有一个 getter， 如果变量不是 final 的则还有一个 setter。
      - 你可以通过实现 getter 和 setter 来创建新的属性， 使用 get 和 set 关键字定义 getter 和 setter。

        ```dart
          class Rectangle {
            num left;
            num top;
            num width;
            num height;

            Rectangle(this.left, this.top, this.width, this.height);

            // Define two calculated properties: right and bottom.
            num get right             => left + width;
                set right(num value)  => left = value - width;
            num get bottom            => top + height;
                set bottom(num value) => top = value - height;
          }

          main() {
            var rect = new Rectangle(3, 4, 20, 15);
            assert(rect.left == 3);
            rect.right = 12;
            assert(rect.left == -8);
          }
        ```

    **III. 抽象函数**

      抽象函数是只定义函数接口但是没有实现的函数，由子类来 实现该函数。如果**用分号来替代函数体**则这个函数就是抽象函数。

      调用一个没实现的抽象函数会导致运行时异常。
      
      ```dart
        abstract class Doer {       //  abstract ['æbstrækt] 抽象的
          // ...Define instance variables and methods...
          void doSomething(); // Define an abstract method. 抽象函数
        }

        class EffectiveDoer extends Doer {
          void doSomething() {
            // ...Provide an implementation, so the method is not abstract here...
          }
        }
      ```

18. 类 - 隐式接口 Implicit interfaces
    
    每个类都隐式的定义了一个包含所有实例成员的接口， 并且这个类实现了这个接口。如果你想 创建类 A 来支持 类 B 的 api，而不想继承 B 的实现， 则类 A 应该实现 B 的接口。

    一个类可以通过 implements 关键字来实现一个或者多个接口， 并实现每个接口定义的 API。 例如：

    ```dart
        // A person. The implicit interface contains greet().
        class Person {
          // In the interface, but visible only in this library.
          final _name;

          // Not in the interface, since this is a constructor.
          Person(this._name);

          // In the interface.
          String greet(who) => 'Hello, $who. I am $_name.';
        }

        // An implementation of the Person interface.
        class Imposter implements Person {
          // We have to define this, but we don't use it.
          final _name = "";

          String greet(who) => 'Hi $who. Do you know who I am?';
        }

        greetBob(Person person) => person.greet('bob');

        main() {
          print(greetBob(new Person('kathy')));
          print(greetBob(new Imposter()));
        }


        // 可以同时集成多个接口
        class Point implements Comparable, Location {
          // ...
        }
    ```

19. 类 - 扩展类（继承）
    
    使用`extends`定义子类，`super`引用超类

20. 类 - 枚举类型
    
    枚举类型是一个特殊的类。

    ```dart
        // 枚举类型中的每个值都有一个 index getter 函数， 该函数返回该值在枚举类型定义中的位置（从 0 开始）
        enum Color {
          red,
          green,
          blue
        }

        // 枚举的 values 常量可以返回 所有的枚举值。
        List<Color> colors = Color.values;
        assert(colors[2] == Color.blue);

    ```

21. [为类添加新的功能 Mixins](http://dart.goodev.org/guides/language/language-tour#adding-features-to-a-class-mixins%E4%B8%BA%E7%B1%BB%E6%B7%BB%E5%8A%A0%E6%96%B0%E7%9A%84%E5%8A%9F%E8%83%BD) 

    Mixins是一种在多类继承中重用 一个类代码的方法。

22. 使用static类变量和类函数 

  + 静态变量： 在第一次使用的时候才被初始化。
    ```dart
      class Color {
        static const red =
            const Color('red'); // A constant static variable.
        final String name;      // An instance variable.
        const Color(this.name); // A constant constructor.
      }

      main() {
        assert(Color.red.name == 'red');
      }
    ```

  + 静态函数

    静态函数不再类实例上执行， 所以无法访问 this。例如：

    ```dart
      import 'dart:math';

      class Point {
        num x;
        num y;
        Point(this.x, this.y);

        static num distanceBetween(Point a, Point b) {
          var dx = a.x - b.x;
          var dy = a.y - b.y;
          return sqrt(dx * dx + dy * dy);
        }
      }

      main() {
        var a = new Point(2, 2);
        var b = new Point(4, 4);
        var distance = Point.distanceBetween(a, b);
        assert(distance < 2.9 && distance > 2.8);
      }
    ```
23. 引入库

    + 指定库前缀

      ```dart
        // 如果你导入的两个库具有冲突的标识符， 则你可以使用库的前缀来区分。 例如，如果 library1 和 library2 都有一个名字为 Element 的类， 你可以这样使用：
        import 'package:lib1/lib1.dart';
        import 'package:lib2/lib2.dart' as lib2;
        // ...
        Element element1 = new Element();           // Uses Element from lib1.
        lib2.Element element2 = new lib2.Element(); // Uses Element from lib2.
      ```
    + 导入库的一部分

      ```dart
        // Import only foo.
        import 'package:lib1/lib1.dart' show foo;

        // Import all names EXCEPT foo.
        import 'package:lib2/lib2.dart' hide foo;
      ```

    + 延迟载入库 : 可以让应用在需要的时候再加载库
      
        - 减少 APP 的启动时间。
        - 执行 A/B 测试，例如 尝试各种算法的 不同实现。
        - 加载很少使用的功能，例如可选的屏幕和对话框。

      ```dart
        // 要延迟加载一个库，需要先使用 deferred as 来 导入：
        import 'package:deferred/hello.dart' deferred as hello;
        // 当需要使用的时候，使用库标识符调用 loadLibrary() 函数来加载库：
        greet() async {
          await hello.loadLibrary();  // 使用 await 关键字暂停代码执行一直到库加载完成。 在一个库上你可以多次调用 loadLibrary() 函数。 但是该库只是载入一次。
          hello.printGreeting();  
        }
      ```
      使用延迟加载库的时候，请注意一下问题：

        - 延迟加载库的常量在导入的时候是不可用的。 只有当库加载完毕的时候，库中常量才可以使用。
        - 在导入文件的时候无法使用延迟库中的类型。 如果你需要使用类型，则考虑把接口类型移动到另外一个库中， 让两个库都分别导入这个接口库。
        - Dart 隐含的把 loadLibrary() 函数导入到使用 deferred as 的命名空间 中。 loadLibrary() 方法返回一个 Future。

    + 创建一个库 http://dart.goodev.org/guides/libraries/create-library-packages

24. 异步

    Dart 库中有很多返回 Future 或者 Stream 对象的方法。 这些方法是异步的： 这些函数在设置完基本的操作后就返回了，而无需等待操作执行完成。 例如读取一个文件，在打开文件后就返回了。

    + 有两种方式可以使用 Future 对象中的数据：

      - 使用 async 和 await
      - 使用 Future API

    + 同样，从 Stream 中获取数据也有两种方式：

      - 使用 async 和一个 异步 for 循环 (await for)
      - 使用 Stream API

    + 要使用 await，其方法必须带有 async 关键字：

      ```dart
        checkVersion() async {
          var version = await lookUpVersion();
          if (version == expectedVersion) {
            // Do something.
          } else {
            // Do something else.
          }
        }
      ```
    
    + 可以使用 try, catch, 和 finally 来处理使用 await 的异常：

      ```dart
        try {
          server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4044);
        } catch (e) {
          // React to inability to bind to the port...
        }
      ```

    + 声明异步方法

      一个 async 方法 是函数体被标记为 async 的方法。 虽然异步方法的执行可能需要一定时间，但是 异步方法立刻返回 - 在方法体还没执行之前就返回了。

      ```dart
      checkVersion() async {
        // ...
      }

      lookUpVersion() async => /* ... */;
      ```  

    + 在一个方法上添加 async 关键字，则这个方法返回值为 Future

      ```dart
        // 例如，下面是一个返回字符串 的同步方法：
        String lookUpVersionSync() => '1.0.0';
        // 如果使用 async 关键字，则该方法 返回一个 Future，并且 认为该函数是一个耗时的操作。
        Future<String> lookUpVersion() async => '1.0.0';
      ```

    + `await`表达式

        形式如下： 

        ```dart
          await expression  // expression表达式
        ```

        在 await expression 中， expression 的返回值通常是一个 Future； 如果返回的值不是 Future，则 Dart 会自动把该值放到 Future 中返回。 Future 对象代表返回一个对象的承诺（promise）。 await expression 执行的结果为这个返回的对象。 await expression 会阻塞住，直到需要的对象返回为止。

    + 在循环中使用异步

      ```dart
        await for (variable declaration in expression) {
          // Executes each time the stream emits发出 a value.
        }

        // 上面 expression 返回的值必须是 Stream 类型的。 执行流程如下：

        //  1. 等待直到 stream 返回一个数据
        //  2. 使用 stream 返回的参数 执行 for 循环代码，
        //  3. 重复执行 1 和 2 直到 stream 数据返回完毕。
      ```

25. 元数据

    使用元数据给你的代码添加其他额外信息。 元数据注解是以 @ 字符开头，后面是一个编译时 常量(例如 deprecated)或者 调用一个常量构造函数。

    元数据可以在 library、 class、 typedef、 type parameter、 constructor、 factory、 function、 field、 parameter、或者 variable 声明之前使用，也可以在 import 或者 export 指令之前使用。 使用反射可以在运行时获取元数据 信息。

    有三个注解所有的 Dart 代码都可以使用：`@deprecated`、`@override`、和`@proxy`

    ```dart
      class Television {
          /// _Deprecated: Use [turnOn] instead._
          @deprecated
          void activate() {
            turnOn();
          }

          /// Turns the TV's power on.
          void turnOn() {
            print('on!');
          }
        }
    ```

    + 自定义元数据

      下面的示例定义了一个带有两个参数的 @todo 注解：

      ```dart
        library todo;

        class todo {
          final String who;
          final String what;

          const todo(this.who, this.what);
        }

        // 使用 
        import 'todo.dart';

        @todo('seth', 'make this do something')
        void doSomething() {
          print('do something');
        }
      ```

## 核心库

### 一些基础类型 numbers, collections, strings, and more

1. Numbers

    有`num` `int` `double`三种类型

     + 字符串转为整数或浮点数

       ```dart
        assert(int.parse('42') == 42);
         assert(int.parse('0x42') == 66);
         assert(double.parse('0.50') == 0.5);
       ```
     
     + num 类也定义了一个 parse() 函数，这个函数会尝试解析 为整数，如果无法解析为整数，则会解析为浮点数(double)。

        ```dart
          assert(num.parse('42') is int);
          assert(num.parse('0x42') is int);
          assert(num.parse('0.50') is double);
        ```

     + 使用 toString() 函数 (由 Object 对象定义)来把整数或者浮点数 转换为字符串。

         ```dart
           // Convert an int to a string.
           assert(42.toString() == '42');

           // Convert a double to a string.
           assert(123.456.toString() == '123.456');

           // 限定 小数点的位数.
           assert(123.456.toStringAsFixed(2) == '123.46');

           // 指定转换为字符串的有效位数.
           assert(123.456.toStringAsPrecision(2) == '1.2e+2');
           assert(double.parse('1.2e+2') == 120.0);
         ```

   
2. String & 正则表达式
   
      + 在字符串内查找特定字符的位置；判断字符串是否以特定字符串开始和结尾

        ```dart
          // Check whether a string contains another string.
          assert('Never odd or even'.contains('odd'));

          // Does a string start with another string?
          assert('Never odd or even'.startsWith('Never'));

          // Does a string end with another string?
          assert('Never odd or even'.endsWith('even'));

          // Find the location of a string inside a string.
          assert('Never odd or even'.indexOf('odd') == 6);
        ```

      + 从字符串中获取到单个的字符，单个字符可以是 String 也可以是 int 值

        从字符串中提取一个子字符串，或者把字符串分割为 多个子字符串

        ```dart

          // 截取指定位置子字符串
          assert('Never odd or even'.substring(6, 9) == 'odd');
          // 分割字符串
          var parts = 'structured web apps'.split(' ');
          assert(parts.length == 3);
          assert(parts[0] == 'structured');
          // Get a UTF-16 code unit (as a string) by index.
          assert('Never odd or even'[0] == 'N');
          // 获取每个字符
          for (var char in 'hello'.split('')) {
            print(char);
          }
          // Get all the UTF-16 code units in the string.
          var codeUnitList = 'Never odd or even'.codeUnits.toList();
          assert(codeUnitList[0] == 78);
        ```
      
      + 大小写转换

        ```dart 
          // 转大写
          assert('structured web apps'.toUpperCase() ==
              'STRUCTURED WEB APPS');
          // 转小写
          assert('STRUCTURED WEB APPS'.toLowerCase() ==
              'structured web apps');
        ```
      + 裁剪和判断空字符串

        ```dart
          // Trim a string.
          assert('  hello  '.trim() == 'hello');
          // Check whether a string is empty.
          assert(''.isEmpty);
          // Strings with only white space are not empty.
          assert(!'  '.isEmpty);
        ```
      + 替换部分字符
        
        ```dart 
          var greetingTemplate = 'Hello, NAME!';
          var greeting = greetingTemplate
              .replaceAll(new RegExp('NAME'), 'Bob');

          assert(greeting !=
              greetingTemplate); // greetingTemplate didn't change.
        ```

      + [正则表达式](http://dart.goodev.org/guides/libraries/library-tour#regular-expressions%E6%AD%A3%E5%88%99%E8%A1%A8%E8%BE%BE%E5%BC%8F)

3. Collections集合类

    三个集合类型
    + Lists
      + `indexOf()`来查找 list 中对象的索引
      + `sort`排序list
      + `Lists`支持泛型
    + Set 是一个无序集合，里面不能保护重复的数据
      + 使用`contains()`和`containsAll()`来判断 set 中是否包含 一个或者多个对象
    + Map 也被称之为 字典或者 hash 

    ---
    + `isEmpty` 函数来判断集合是否为空的
    + `forEach()`函数可以对集合中的每个数据都应用 一个方法

        ```dart
          // 在 Map 上使用 forEach() 的时候，方法需要能 接收两个参数（key 和 value）
          hawaiianBeaches.forEach((k, v) {
           print('I want to visit $k and swim at $v');
           // I want to visit Oahu and swim at
           // [Waikiki, Kailua, Waimanalo], etc.
         });
        ```
    + 可以使用 `map().toList()` 或者 `map().toSet()` 来 强制立刻执行 map 的方法
   
4. URIs: 编码和解码 URI（URL） 字符的功能。 

     这些函数处理 URI 特殊的字符，例如 & 和 =。 Uri 类还可以解析和处理 URI 的每个部分，比如 host, port, scheme 等。

5. Dates and times
   
6. Utility classes（工具类）
   
7. Exceptions 异常和错误类

### 异步编程async
### Math库: 数学运算
### dart:html
### dart.io
### convert: JSON转换
### mirrors: 反射机制