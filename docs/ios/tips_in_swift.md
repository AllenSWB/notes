- [Swift Syntax](#swift-syntax)
- [从 `OC` 到 `Swift`](#%e4%bb%8e-oc-%e5%88%b0-swift)
## Swift Syntax

1. `for-in`

   ```swift
    /* 遍历数组 */
    let scores = [23, 43, 65]
    var newScores : [Int] = []
    for s in scores {
        if s > 30 {
            newScores.append(s)
        }
    }
    print(newScores) // [43, 65]

    /* 
    遍历字典:
        a. 字典是无序的，遍历也是无序的！
        b. 每一个元素都返回一个元组
    */
    let keyValue = ["三班": 23,
                    "四班": 32,
                    "五班": 99]
    for (key, value) in keyValue {
        print("key is \(key), value is \(value)")
    } 
   ```

2. 用`if`和`let`操作可能丢失的值

   ```swift
    var food: String?
    if let f = food { // 如果可选项值为nil，则跳过大括号里的代码
        print("i have \(f)")
    }
   ```

3. 可选项的默认值 `??`

   ```swift
    var food: String? = "饺子"
    print(food ?? "西瓜")
   ```

4. `switch`支持任意类型的数据和各种类型的比较操作，不再限于整型和测试相等上

   ```swift
    let vegetable = "red pepper"
    switch vegetable {
        case "西红柿":
            print("西红柿很好吃")
        case let x where x.hasPrefix("red"):
            print(vegetable)
        default:
            "all good"
    }

    //console: red pepper
   ```

5. 元组类型

   ```swift
    let http404Error: (Int, String) = (404, "Not Found")
    let (errCode, errMsg) = http404Error
    print("error code is \(errCode), error message is '\(errMsg)'") // error code is 404, error message is 'Not Found'
   ```

6. 可选项

   ```swift
    let str = "32"
    var numResult: Int? = Int(str)  

    // 强制展开
    if numResult != nil { // 确定有值可以用!强制展开
        print("string转成int值为\(numResult!)")
    }
   ```

7. 函数定义

   ```swift
   func <#name#>(<#parameters#>) -> <#return type#> {
         <#function body#>
   }
   ```
 
 1. 函数的形参和实参

    每个函数的形式参数都包含*实际参数标签*和*形式参数名*。默认情况下，形式参数名就是实际参数标签。
    
      ```swift
       override func viewDidLoad() {
           super.viewDidLoad()

           let s0 = test0(32)
           let s1 = test1(realTag: 43)
           let s2 = test2(code: 89)
           let s3 = test3() // 参数不传，则默认code=90
           let s33 = test3(code: 99) // 传入参数，则按传入的值来
           let s4 = test4(code: 9,3,2)
           print(s0, s1, s2, s3, s33, s4)

           var tempCode = 9
           _ = test5(code: &tempCode)
           print("tempCode new value is \(tempCode)")
       }

       // 省略实参标签
       func test0(_ code: Int) -> String {
           return String(code)
       }

       // 指定实参标签
       func test1(realTag code: Int) -> String {
           return String(code)
       }

       // 默认实参标签
       func test2(code: Int) -> String {
           return String(code)
       }

       // 默认形式参数值
       func test3(code: Int = 90) -> String {
           return String(code)
       }

       // 可变形式参数
       func test4(code: Int...) -> String {
           let codeType = type(of: code)
           return "code type is \(codeType)"
       }

       // 输入输出形式参数
       func test5(code: inout Int) -> String {
           code += 1
           return String(code)
       }

       // 函数类型：由形式参数类型，返回类型组成
       print(type(of: test5(code:))) // (inout Int) -> String 
      ```

8. 内嵌函数

    全局范围内定义的函数叫做*全局函数*
    
    在函数内部定义的函数叫做*内嵌函数*
    
   ```swift
    override func viewDidLoad() {
        super.viewDidLoad()
         
        print(test(plus: true)(4))  // 5
        print(test(plus: false)(4)) // 3
    }

    func test(plus: Bool) -> (Int) -> (Int) {
        func plusMethod(num: Int) -> Int {return num + 1}
        func subtractMethod(num: Int) -> Int {return num - 1}
        return plus ? plusMethod : subtractMethod
    } 
   ```

9.  闭包

    + 全局函数是一个有名字但不会捕获任何值得闭包
    + 内嵌函数是一个有名字且能从其上层函数捕获值的闭包
    + 闭包表达式是一个轻量级语法所写的可以捕获其上下文中常量或变量值得没有名字的闭包
    ```swift
    // 闭包表达式语法
    {(<#params#>) -> (<#return type#>) in
        <#statements#>
    }
    ```
    + 闭包和函数都是引用类型

10. 枚举

    + 枚举成员可以指定任意类型的值与不同的成员值关联存储
    + Swift中的枚举是具有自己权限的一类类型。支持了许多一般只被类所支持的特性。例如计算属性用来提供关于枚举当前值得额外信息，并且实例方法用来提供与枚举表示的值相关的功能。
    + 可以定义初始化器来初始化成员值
    + 能够遵循协议来提供标准功能

11. 遍历枚举 

    ```swift
    enum Sex : CaseIterable { // 遵循CaseIterable协议
        case male
        case female
    }

    print("性别种类:\(Sex.allCases.count)") // 性别种类:2
    ```

12. 枚举的关联值

    ```swift
    // 将其他类型的关联值和成员值一期存储
    enum BarCode {
        case upc(Int, Int, Int, Int)
        case qrCode(String)
    }

    var bar1 = BarCode.upc(23, 32, 423, 543) 
    bar1 = .qrCode("二维码携带的信息")

    switch bar1 {
    case .upc(let left, let up, let down, let right):
        print("UPC \(left), \(right), \(up), \(down)")
    case let .qrCode(msg):
        print("信息是 : \(msg)")
    }
    
    //console log:  信息是 : 二维码携带的信息
    ```

13. 枚举的原始值
     + 定义枚举时指定`rawValue`的类型
     + 隐式指定的原始值，默认比上一个成员值大一
     
     ```swift
      enum EdgeInsetEnum: Int {
          case top = 1
          case left = 4
          case bottom
          case right
      }
      
      let s = EdgeInsetEnum.right
      print(s.rawValue) // 6
     ```

14. 从原始值初始化枚举
    
    ```swift
    /* 
    用原始值类型定义一个枚举，那么这个枚举就会自动收到一个可以接收原始值类型的初始化器（`rawValue`的形参）,返回一个枚举成员或者nil
    */
    enum EdgeInsetEnum: Int { 
        case top
        case left
        case bottom
        case right
    }
    
            
    let s0: EdgeInsetEnum? = EdgeInsetEnum.init(rawValue: 9)
    print(s0 ?? "没有值")
    print(EdgeInsetEnum.init(rawValue: 2) ?? "没有值")
    
    // console log :
    //              没有值
    //              bottom 
    ```
    
15. 类和结构体的定义

    ```swift
    class TestClass {

    }

    struct TestStuct {

    } 
    ```

16. 结构体类型的成员初始化器
    
    所有结构体都有一个自动生成的*成员初始化器*，类不会自动生成。
    ```swift
    struct TestStuct {
        var para1: Int
    }
    
    let s = TestStuct.init(para1: 32)
    print(s.para1) // 32
    ```

18. 值类型和引用类型
    
    **值类型：** 是一种当它被指定到常量或者变量，或者被传递给函数时会被拷贝的类型
    + 结构体和枚举是值类型
    + Swift中所有的基本类型：整数、浮点数、布尔、字符串、数组、字典都是值类型，并且以结构体的形式在后台实现
    + OC中的集合类型(`NSDictionary` `NSArray` `NSString`等)是类，swift中是结构体
    
    **引用类型：** 当它被指定到常量或变量或被传递给函数时，不会被拷贝，而是对现存实例的引用。
    + 类是引用类型
    + 函数和闭包是引用类型 

19. 特征运算符 
    
    + `===` 相同于. 
        - `相同于 ===` 意味着两个变量引用相同的实例
        - `等于 ==` 
    + `!==` 不相同于

    ```swfit
    class TestClass {
      var name: String = ""
    }

    let c0 = TestClass()
    c0.name = "yu" 
    let c1 = c0

    if c0 === c1 {
      print("c1和c0引用的是同一个实例")
    } 
    ```

20. 类和结构体的选择

    类是引用类型，结构体是值类型。
    
    当符合以下一个或几个条件时，应当考虑使用结构体：
    + 结构体的主要目的是封装一些相关的简单数据值
    + 需要封装的数据想要拷贝而不是引用
    + 任何存储在结构体中的属性是值类型，也将被拷贝而非引用
    + 结构体不需要从一个已存在类型继承属性或者行为
    

21. `OC`和`Swift`的区别
    
    + `OC`中 `NSDictionary NSArray NSString`是引用类型，而在 `Swift`中`Array Dictionary String`是值类型。 

22. 属性
    
    属性：可以将值与特定的类、结构体或者枚举联系起来。
    
    + 存储属性：会存储常量或变量作为实例的一部分
        - 只能由类和结构体定义
    + 计算属性：会计算值（而非存储）
        - 可以由类、结构体和枚举定义
    
22. 常量结构体实例的存储属性
    
    一个常量结构体实例，即便它的存储属性被定义为变量，也会成为一个常量。 

    ```swift
    struct TestStruct {
        var para1: Int
        let para2: Int
    }

    let s = TestStruct.init(para1: 1, para2: 2)
    s.para1 = 32 // 这一行会报错: Cannot assign to property: 's' is a 'let' constant
    ```

23. `lazy` 延迟存储属性    
    
    ```swift
    struct TestStuct {
        /*
            1. lazy只能修饰var变量；必须有一个初始化的值
            2. 必须有一个初始化的值
        */ 
        lazy var para1 = [String]() 
        var para2: Int = 0
    }
    ```
24. 存储属性和实例变量

    `OC`里有两种方式(`.`和`_`)存储和引用值 。`Swift`把这些概念统一到了属性声明里。
    
25. 计算属性
    
    只读计算属性: 只有*读取器get* 没有*设置器set*
 
    ```swift
    struct Point {
        var x = 0.0, y = 0.0
    }

    struct Size {
        var width = 0.0, height = 0.0
    }

    struct Rect {
        var origin = Point()
        var size = Size()
        var center: Point {
            get {
                Point(
                    x: origin.x + size.width / 2,
                    y: origin.x + size.height / 2
                )
            }
            set { // 如果计算属性的设置器没有为将要被设置的值定义一个名字，会默认命名为newValue
                origin.x = newValue.x - (size.width / 2)
                origin.y = newValue.y - (size.height / 2)
            }
        }
    } 
    ```

26. 属性观察者 `willSet` `didSet`

    + 可以为任意存储属性添加属性观察者（延迟存储属性除外）
    + 可以通过在子类里重写属性为继承属性（无论是存储属性还是计算属性）添加属性观察者
    + `willSet`会在该值被存储之前被调用
    + `didSet`会在一个新值被存储后被调用
    + 父类属性的`willSet`和`didSet` 观察者会在子类初始化器中设置时被调用。它们不会在类
的父类初始化器调用中设置其自身属性时被调用。


    ```swift
    struct Size {
        var width = 0.0 {
            willSet{
                print("新的宽度(willSet) \(newValue)")
            }
            didSet {
                print("新的宽度(didSet) \(width) 旧的宽度(didSet) \(oldValue)")
                
                width = 89
            }
        }
        var height = 0.0
    }

    var size0 = Size(width: 99, height: 99)
    size0.width = 32
    print("在didSet设置了新的值 \(size0.width)")

    // console log : 
    // 新的宽度(willSet) 32.0
    // 新的宽度(didSet) 32.0 旧的宽度(didSet) 99.0
    // 在didSet设置了新的值 89.0
    ```

28. 全局和局部变量

  + 全局变量：定义在任何函数、方法、闭包或类型环境之外的变量
  + 局部变量：定义在函数、方法或者闭包环境之中的变量
  + 类似存储属性、计算属性，也有存储变量、计算变量。且和属性有一样的能力。

29. 类型属性

  + 无论创建了多少个实例，类型属性只有一个拷贝

    ```swift
    class TestClass {
      static var para1 = "类型属性"
    }

    print(TestClass.para1) // 类型属性
    ```

30. 方法

    方法：是关联了特定类型的函数。类、结构体、枚举都能定义实例方法

31. `self`属性

    每个类的实例都隐含一个叫做`self`的属性

    ```swift
    class TempRootViewController: UIViewController { 
        func test() {
            print(TestClass.para1)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor.white 
            
            self.test() // 调用方法
        }
    }
    ```

32. 在实例方法中修改值类型 `mutating`

  + 结构体和枚举是值类型。默认情况下，值类型属性不能被自身的实例方法修改。
  + 用`mutating`修饰实例方法，就可以在方法中修改属性值。
  
    ```swift
    struct TestStruct {
      var name = "fs"
      
      mutating func testM() {  
          self.name = "fd"
      }
    }

    var s = TestStruct.init()
    print(s.name) /* fs */
    print(s.testM())   /* fd */
    ```

33. 类方法

  ```swift
  class TestClass {
    class func test() -> String{
        return "类方法"
    }
  } 

  print(TestClass.test()) // 类方法
  ```

34. 类

  + 基类：不继承任何类
  + 子类：继承现有的类的特征

    ```swift
    class Vehicle {
      var brand: String {
          get { "没有品牌" }
      }
     }

    class  Borgward : Vehicle {
      override var brand: String {  // 重写属性
          get {"宝沃"}
      }
    } 


    let v = Vehicle()
    print(v.brand) // 没有品牌

    let v1 = Borgward()
    print(v1.brand) // 宝沃
    ```

35. 为存储属性设置初始化值

    创建类和结构体的实例时候，必须为所有的存储属性设置一个合适的初始值。可以在初始化器里为存储属性设置一个初始值，或者分配一个默认的属性值。

    ```swift
    class Vehicle {
        let wheels: Int
        var brand: String = "没牌子"   /* 直接分配一个默认值 */
        init() {   /* 在初始化器里设置初始值 */
            wheels = 4
        }
    }
    ```
36. 扩展

    扩展可以为现有的类、结构体、枚举或协议增加新功能，也包括了为无权限访问的源代码扩展类型的能力（逆向建模）
    
    `Swift`中的扩展可以：
    
    + 添加计算实例属性和计算类型属性
    + 定义实例方法和类型方法
    + 提供新初始化器
    + 定义下标
    + 定义和使用新内嵌类型
    + 使现有类型遵循某协议
      ```swift
      extension Array {
          /* Array取值的安全方法 */
          func objectOrNilAtIndex(index: Int) -> Any? {
              if self.count > index {
                  return self[index]
              }
              return nil
          }
      } 
      ```


## 从 `OC` 到 `Swift`

1. `Swift`中的初始化器不返回值，`OC`中初始化方法返回一个实例
2. `UIbutton` 添加响应事件
     ```swift
      override func viewDidLoad() {
          super.viewDidLoad()
          btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
      }

      @objc func btnAction() { 
          let v = WBTestViewController()
          v.modalPresentationStyle = .fullScreen
          self.present(v, animated: true, completion: nil)
      }
     ```

3. 类方法

    ```swift
      class TestClass {
        class func testMethod () {

        }
      }
    ```
4. 单例

    ```swift
    class User {
        static let sharedInstance = User()
        var name: String?
    }

    let s1 = User.sharedInstance
    s1.name = "小明" 
    let s2 = User.sharedInstance
    print(s2.name ?? "无名氏") // 小明 
    ```

5. Xcode11新建swift项目，去除SceneDelegate.swift

   - 删除SceneDelegate.swift文件
   - info.plist中移除`Application Scene Manifest`项
    ![](../../src/imgs/ios/swift_tip/secen_plist.png)
   - 注释掉相关代码
     ```swift
     func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration { 
     }

     func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { 
     }
     ```
   - 新增window属性
     ```swift
     var window: UIWindow?

     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { 
         window = UIWindow.init()
         window?.frame = UIScreen.main.bounds
         window?.makeKeyAndVisible()
         window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
         return true
       } 
     ```  

6. `Moya`报错`'Method' is ambiguous for type lookup in this context`

    ```swift
    extension BWService : TargetType {
        var method: Moya.Method {   // 这里要指定Moya.Method，否则就会报错'Method' is ambiguous for type lookup in this context
        }
    }
    ```
 

<!-- ## todo 
+ 错误处理do-catch try! try?
+ 断言
+ 引用类型 值类型？？
+ rxSwfit vs Combine 
+ SwiftUI
+ 递归枚举??
+ 混编
+ 网络请求库
+ Swift中类方法和实例方法
+ 全局导入头文件 (pch作用)
+ public方法和private方法
+ KVO in Swift
+ Runtime in Swift -->