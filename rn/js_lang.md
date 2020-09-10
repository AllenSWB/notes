- [JavaScript 基础](#javascript-基础)
  - [Chrome 快捷键](#chrome-快捷键)
  - [JavaScript 是轻量级的脚本语言。](#javascript-是轻量级的脚本语言)
  - [基本语法](#基本语法)
  - [JS 有7种数据类型](#js-有7种数据类型)
  - [typeof 运算符](#typeof-运算符)
  - [`null` 和 `undefined`](#null-和-undefined)
  - [boolean 布尔值 true / false](#boolean-布尔值-true--false)
  - [数值 Number](#数值-number)
  - [与数值有关的全局方法](#与数值有关的全局方法)
  - [字符串](#字符串)
  - [字符串 base64 转码](#字符串-base64-转码)
  - [对象](#对象)
  - [表达式还是对象?](#表达式还是对象)
  - [对象属性的操作](#对象属性的操作)
  - [函数](#函数)
  - [Node.js](#nodejs)

## JavaScript 基础

+ [现代 JavaScript 教程](https://zh.javascript.info)
+ [ECMAScript 6 入门 by 阮一峰](http://es6.ruanyifeng.com/)

### Chrome 快捷键 

+ 打开开发者工具 `Option` + `Command` + `J`
+ console 换行 `Shift` + `Enter`
+ console 执行代码 `Enter`

### JavaScript 是轻量级的脚本语言。

脚本语言: 指它不具备开发操作系统的能力，而是只用来编写控制其他大型应用程序(eg: 浏览器)的脚本。

JavaScript也是一种嵌入式语言。本身提供的核心语法不多，只能用来做数学和逻辑运算。JavaScript 本身不提供任何与 I/O（输入/输出）相关的 API，都要靠宿主环境（host）提供，所以 JavaScript 只合适嵌入更大型的应用程序环境，去调用宿主环境提供的底层 API。

从语法角度看，JavaScript 语言是一种“对象模型”语言。各种宿主环境通过这个模型，描述自己的功能和操作接口，从而通过 JavaScript 控制这些功能。但是，JavaScript 并不是纯粹的“面向对象语言”，还支持其他编程范式（比如函数式编程）。

JavaScript 的核心语法部分相当精简，只包括两个部分：基本的语法构造（比如操作符、控制结构、语句）和标准库（就是一系列具有各种功能的对象比如Array、Date、Math等）。除此之外，各种宿主环境提供额外的 API（即只能在该环境使用的接口），以便 JavaScript 调用。以浏览器为例，它提供的额外 API 可以分成三大类。
    
  + 浏览器控制类：操作浏览器
  + DOM 类：操作网页的各种元素
  + Web 类：实现互联网的各种功能

如果宿主环境是服务器，则会提供各种操作系统的 API，比如文件操作 API、网络通信 API等等。这些你都可以在 Node 环境中找到。

### 基本语法
```js
//  语句
   一个分隔号; 代表一个语句

   //  变量声明
   var a = 1;
   a = 'hello' 

   var b; // 声明未赋值，此时b为 undefined

   // 标识符命名
   $ _ 字母 开头。
   var 临时 = 1;   // 中文也可作标识符 

   // 区块
   // 对var来说。JS的区块不构成单独的作用域
   {
      var a = 2;
   }
   console.log(a); //不报错

   // if语句
   if (a === 3) {
      console.log('a是3了啊');
   }

   // === 严格相等运算符 
   // ==  相等运算符 
   // =   赋值运算符

   // switch语句 
   var a = 1;
   switch (a) {
      case a = 1: 
          console.log('a是1');
          breake;
      default:
          console.log('a不是1');
   }

   // 三元运算符 ?: 

   // while循环
   while(条件) {
      语句;
   }

   // for循环
   for (var i = 0; i < 3; i++) {
      console.log(i);
   }

   // do-while 循环
   do {
      语句;
   } while(条件);

   // break 跳出代码块或循环
   // continue 立即终止本轮循环，返回循环结构头部，开始下一轮循环

   // label 标签。相当于定位符，用于跳转到程序的任意位置。通常配合break或者continue语句使用
   label: 
      语句;
```
### JS 有7种数据类型

  + 数值 number
  + 字符串 string
  + 布尔值 boolean
  + undefined：表示未定义或不存在
  + null：表示空值
  + 对象 object：各种值组成的集合
  + Symbol: es6新增类型

  通常，数值、字符串、布尔值这三种类型，合称为原始类型（primitive type）的值，即它们是最基本的数据类型，不能再细分了。对象则称为合成类型（complex type）的值，因为一个对象往往是多个原始类型的值的合成，可以看作是一个存放各种值的容器。至于undefined和null，一般将它们看成两个特殊值。

  对象是最复杂的数据类型，又可以分成三个子类型。

  + 狭义的对象（object）
  + 数组（array）
  + 函数（function）

  狭义的对象和数组是两种不同的数据组合方式，除非特别声明，本教程的”对象“都特指狭义的对象。函数其实是处理数据的方法，JavaScript 把它当成一种数据类型，可以赋值给变量，这为编程带来了很大的灵活性，也为 JavaScript 的“函数式编程”奠定了基础。

### typeof 运算符

  JS有三种方法确定一个值是什么类型。

  + typeof 运算符
  + instanceof 运算符
  + Object.prototype.toString 方法
```js
    var a = 3
    typeof a // "number"

    typeof null // "object" 注意: null 返回的是object

    // 常见使用
    if (typeof a === "undefined") {

    }
```
### `null` 和 `undefined`

    二者语法效果几乎没区别
```js
  var a = undefined;
  var b = null;

  a === b // true
```
    谷歌开发的JS的替代品Dart语言，明确规定只有'null'没有'undefined'

    区别点:

    + null表示一个'空'的对象，转换为数值时为0
    + undefined表示一个'此处无定义'的原始值，转为数值时为NaN
```js
    // 变量声明了 但是没赋值
    var i;
    i // undefined 

    // 调用函数，应该提供的参数没提供
    function f(x) {
        return x;
    }
    f() //undefined

    // 对象没有赋值的属性
    var o = new Object();
    o.p // undefined

    // 函数没有返回值时，默认返回 undefined 
    function f() {}
    f() // undefined
```
### boolean 布尔值 true / false

+ 前置逻辑运算符 `!(Not)`
+ 相等运算符 `===` `!==` `==` `!=`
+ 比较运算符 `>` `>=` `<` `<=`

如果JS预期某个位置应该是boolean，出现在该位置的值自动转为boolean。除了下面的会被转为`false`，其他都会转为`true`

+ `undefined`
+ `null`
+ `false`
+ `0`
+ `NaN`
+ `""`或者`''`(空字符串)

### 数值 Number

JS内部，所有数字都是以64位浮点数形式储存，即使整数也是如此。所以，1与1.0是相同的，是同一个数。这就是说，JavaScript 语言的底层根本没有整数，所有数字都是小数

数值的表示:

+ 十进制 12
+ 十六进制 0xFF
+ 科学计数法 123e3 (123000)。以下两种情况，JavaScript 会自动将数值转为科学计数法表示，其他情况都采用字面形式直接表示
   - 小数点前的数字多于21位。
   - 小数点后的零多于5个。

数值的进制: 

+ 十进制: 没有前导0的数值。
+ 八进制: 有前缀`0o`或`0O`的数值，或者有前导0、且只用到0-7的八个阿拉伯数字的数值。
+ 十六进制: 有前缀`0x`或`0X`的数值
+ 二进制: 有前缀`0b`或`0B`的数值。

特殊的值:

+ 正0 负0

    几乎所有场合，正零和负零都会被当作正常的0。

        -0 === +0 // true
    唯一有区别的场合是，+0或-0当作分母，返回的值是不相等的。

        (1 / +0) === (1 / -0) // false

+ NaN

    表示 Not a number。主要出现在将字符串解析成数字出错的场合.

        5 - 'x' // NaN

    0除以0结果也是NaN

        0 / 0 // NaN
    `NaN`不等于任何值，包括自身

        NaN === NaN // false

+ `Infinity` 无穷。表示两种场景。

    + 正数值太大，或者负数的值太小
    + 非0的值除以0，得到`Infinity`
    ```js
        // `Infinity`大于一切数值(除了`NaN`) 
        Infinity > 10000 // true

        // `-Infinity`小于一切数值(除了`NaN`)
        -Infinity < -10000 // ture

        // `Infinity`和`NaN`比较，总是返回`false`
        Infinity > NaN // false
        Infinity < NaN // false
        -Infinity > NaN // false
        -Infinity < NaN // false
    ```
    - 加减乘除
    ```js
        5 * Infinity // Infinity
        5 - Infinity // -Infinity
        Infinity / 5 // Infinity
        5 / Infinity // 0

        Infinity * Infinity // Infinity
        Infinity + Infinity // Infinity

        Infinity - Infinity // NaN
        Infinity / Infinity // NaN

        // Infinity与null计算。null会转为0 等同于与0计算
        null * Infinity // NaN
        null / Infinity // 0
        Infinity / null // Infinity

        // Infinity与undefined计算，返回都是`NaN`
        undefined + Infinity // NaN
        undefined - Infinity // NaN
        undefined * Infinity // NaN
        undefined / Infinity // NaN
        Infinity / undefined // NaN
    ```
### 与数值有关的全局方法

+ parseInt() 将字符串转为整数
```js
  parseInt('1.23') // 1
  parseInt('x1')   // NaN
  parseInt(12, 10) // 第二个参数是进制，默认10
```
+ parseFloat() 将字符串转为float
+ isNaN()
+ isFinite()
```js
// 除了Infinity、-Infinity、NaN和undefined这几个值会返回false，isFinite对于其他的数值都会返回true。

    isFinite(Infinity) // false
    isFinite(-Infinity) // false
    isFinite(NaN) // false
    isFinite(undefined) // false
    isFinite(null) // true
    isFinite(-1) // true
```
### 字符串

    放在`' '`或者`" "`之中

    字符串可以被视为字符数组
```js
  var temp = 'who am i'
  console.log(temp[1]) // h

  // 如果方括号中的数字超过字符串的长度，或者方括号中根本不是数字，则返回undefined。
  'abc'[3] // undefined
  'abc'[-1] // undefined
  'abc'['x'] // undefined

  // 但是，字符串与数组的相似性仅此而已。实际上，无法改变字符串之中的单个字符。
  var s = 'hello';

  delete s[0];
  s // "hello"

  s[1] = 'a';
  s // "hello"

  s[5] = '!';
  s // "hello"

  // length 属性
  console.log(temp.length) //返回长度

  // 字符集。解析代码的时候，JavaScript 会自动识别一个字符是字面形式表示，还是 Unicode 形式表示。输出给用户的时候，所有字符都会转成字面形式。 

  var s = '\u00A9';
  s // "©"
```
### 字符串 base64 转码

+ btoa()：任意值转为 Base64 编码
+ atob()：Base64 编码转为原来的值

### 对象

对象就是一组“键值对”（key-value）的集合，是一种无序的复合数据集合。

```js
  var obj = {
      name :'xiao liang',
      age : 23
  }
```
对象的所有键名都是字符串（ES6 又引入了 Symbol 值也可以作为键名），所以加不加引号都可以。上面的代码也可以写成下面这样。

对象的属性之间用逗号分隔，最后一个属性后面可以加逗号（trailing comma），也可以不加。

如果不同的变量名指向同一个对象，那么它们都是这个对象的引用，也就是说指向同一个内存地址。修改其中一个变量，会影响到其他所有变量。
```js
  var o1 = {};
  var o2 = o1;

  o1.a = 1;
  o2.a // 1

  o2.b = 2;
  o1.b // 2
```
### 表达式还是对象?
    
    对象采用大括号表示，这导致了一个问题：如果行首是一个大括号，它到底是表达式还是语句？
```js
    // JavaScript 引擎读到上面这行代码，会发现可能有两种含义。第一种可能是，这是一个表达式，表示一个包含foo属性的对象；第二种可能是，这是一个语句，表示一个代码区块，里面有一个标签foo，指向表达式123。

    { foo: 123 }

// 为了避免这种歧义，V8 引擎规定，如果行首是大括号，一律解释为对象。不过，为了避免歧义，最好在大括号前加上圆括号。

    eval('{foo: 123}') // 123
    eval('({foo: 123})') // {foo: 123}
```
### 对象属性的操作

+ 属性读取

    读取对象的属性，有两种方法，一种是使用点运算符，还有一种是使用方括号运算符。
```js
  var obj = {
      p: 'Hello World'
  };

  obj.p // "Hello World"
  obj['p'] // "Hello World"
```
+ 属性赋值

    点运算符和方括号运算符，不仅可以用来读取值，还可以用来赋值。

+ 查看属性
```js
  var obj = {
   name: "liu",
   age:  12,
  }   
  // ["name", "age"]
```   
+ 删除属性
```js
  var obj = {
   name: "liu",
   age:  12,
  }
  var is = delete obj.age //删除属性，成功后返回true
  console.log(Object.keys(obj), is)
  // ["name"] true

  delete obj.sss // 删除一个不存在的属性 返回 true
```
只有一种情况，delete命令会返回false，那就是该属性存在，且不得删除。

另外，需要注意的是，delete命令只能删除对象本身的属性，无法删除继承的属性 

+ in 运算符

检查对象是否包含某个属性
```js
  var obj = {
   'name' : 'liuyifei',
   'age' : 23
  }

  console.log('u' in obj, 'age' in obj)  // false true
```
`in` 运算符的一个问题是，它不能识别哪些属性是对象自身的，哪些属性是继承的。 
```js
  var obj = {}
  'toString' in obj // true . 'toString'属性是继承的，返回还是true。

  // 可以使用 hasOwnProperty 方法判断

  var obj = {}
  if ('toString' in obj) {
      console.log(obj.hasOwnProperty('toString'))  // false
  }
```     
`for`...`in` 遍历对象属性
```js
  var obj = {
   'name' : 'liu',
   'sex' : 0
  }
  for (var i in obj) {
      console.log(i); 
  }
  //  name sex
```
+ 它遍历的是对象所有可遍历（enumerable）的属性，会跳过不可遍历的属性。
+ 它不仅遍历对象自身的属性，还遍历继承的属性。

`with` 语句

它的作用是操作同一个对象的多个属性时，提供一些书写的方便。
```js 
  var obj = {
      'name' : 'liu',
      'age' : 13
  }
  with (obj) {
      name = 'su',
      age = 7
  }
  console.log(obj.name, obj.age)
    // su 7
```
注意，如果 `with` 区块内部有变量的赋值操作，必须是当前对象已经存在的属性，否则会创造一个当前作用域的全局变量。

这是因为 `with` 区块没有改变作用域，它的内部依然是当前作用域。这造成了 `with` 语句的一个很大的弊病，就是绑定对象不明确。
```js
  var obj = {
      'name' : 'liu',
      'age' : 13
  };
  with (obj) {
      sex = 1
  }
  console.log(obj.sex, sex)
    // undefined  1
```
### 函数

+ 函数声明的三种方式
```js
  // 1. function 命令
  function testMethod (a) {
   console.log(a);
  }
  testMethod(12)  // 12

  // 2. 函数表达式
  var testMethod2 = function(s) {
      console.log(s);
  };
  testMethod2('test method 2') // test method 2

  // 3. Function构造函数 - 几乎无人用
  var foo = new Function(
      'return "hello world";'
  );
```  
+ 函数的重复声明

    如果同一个函数被多次声明，后面的声明就会覆盖前面的声明。
```js
  function temp(s, n) {
       console.log(s - n);
  }  
  function temp(s, n) { // 重复声明
      console.log(s + n);
  }

  temp(3,1) // 4
```
+ `()` 和 `return`

    调用函数使用`()`，括号里面传参
    `return`语句表示返回，不写的话，默认返回`undefined`

+ 一等公民

    JavaScript 语言将函数看作一种值，与其它值（数值、字符串、布尔值等等）地位相同。凡是可以使用值的地方，就能使用函数。比如，可以把函数赋值给变量和对象的属性，也可以当作参数传入其他函数，或者作为函数的结果返回。函数只是一个可以执行的值，此外并无特殊之处。

### Node.js

0. 参考文档

    + [`Node.js`教程](http://www.runoob.com/nodejs/nodejs-tutorial.html) 

1. 下载`node.js` https://nodejs.org/en/download/

2. 打开终端 `node -v`查看当前`node`版本号。

3. 输入`node`进入命令交互模式，输入`.exit`退出命令交互模式。
 