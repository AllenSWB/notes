# Dart 

> http://dart.goodev.org/

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

