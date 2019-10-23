- [Swift Tips](#swift-tips)
  - [UIButton响应方法](#uibutton%e5%93%8d%e5%ba%94%e6%96%b9%e6%b3%95)
  - [Xcode11新建swift项目，去除SceneDelegate.swift](#xcode11%e6%96%b0%e5%bb%baswift%e9%a1%b9%e7%9b%ae%e5%8e%bb%e9%99%a4scenedelegateswift)
  
# Swift Tips

<!-- ## Swift中类方法和实例方法

## 全局导入头文件 (pch作用)

## public方法和private方法

## KVO in Swift

## Runtime in Swift -->

## UIButton响应方法

```swift
  override func viewDidLoad() {
        super.viewDidLoad()
    btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
  }

  @objc func btnAction() {
        print("按钮。。。。。。")
        let v = WBTestViewController()
        v.modalPresentationStyle = .fullScreen
        self.present(v, animated: true, completion: nil)
    }
```  

## Xcode11新建swift项目，去除SceneDelegate.swift

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

