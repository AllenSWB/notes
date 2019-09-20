# 使用Mac
- [使用Mac](#%e4%bd%bf%e7%94%a8mac)
  - [新Mac配置](#%e6%96%b0mac%e9%85%8d%e7%bd%ae)
  - [Sourcetree免登陆使用](#sourcetree%e5%85%8d%e7%99%bb%e9%99%86%e4%bd%bf%e7%94%a8)
  - [Sourcetree每次pull和push都需要输入密码解决](#sourcetree%e6%af%8f%e6%ac%a1pull%e5%92%8cpush%e9%83%bd%e9%9c%80%e8%a6%81%e8%be%93%e5%85%a5%e5%af%86%e7%a0%81%e8%a7%a3%e5%86%b3)
  - [Xcode快捷键](#xcode%e5%bf%ab%e6%8d%b7%e9%94%ae)


## 新Mac配置

- [x] 输入法
- [x] 百度网盘
- [x] CleanMyMac
- [x] 迅雷
- [ ] 1Password
- [ ] 全能解压 (Dr. Unarchiver)
- [ ] 微信
- [x] QQ
- [ ] 企业微信
- [x] IINA播放器
- [ ] 印象笔记-圈点
- [ ] Microsoft Word / WPS
- [ ] Proxyee-down
- [x] 有道词典

- [x] ShadowSocksX

- [x] Alfred 
- [x] Chrome
- [x] Homebrew 
- [ ] mounty (brew cask install mounty)

- [x] Xcode
- [x] Cocoapods (sudo gem install cocoapods -v 1.6.1 另外 pod setup)
- [x] Postman
- [x] Visual Studio Code
- [x] SourceTree
- [ ] homebrew

- [ ] Sketch
- [ ] PS

- [x] 设置四个触发角
- [x] 设置Chrome为默认浏览器
- [x] MAC应用无法打开或文件损坏的处理方法 ： 设置允许任何来源的app  (打开终端，输入sudo spctl --master-disable然后按回车)
- [x] 切换输入法快捷键 系统输入法大写按钮



- [ ] 命令行安装 command line developer tool
    ```shell
    xcode-select --install
    ```


+ xclient.info
+ https://wxkxsw.com/link/Ce6mLeDTepd5W34C?mu=0
+ https://support.apple.com/zh-cn/HT204012
  
## Sourcetree免登陆使用

![sourcetree_withoutlogin](../src/imgs/sourcetree_withoutlogin.png)

## Sourcetree每次pull和push都需要输入密码解决

终端输入：(第一次需要输入密码，以后都不需要了)

```shell
git config --global credential.helper osxkeychain  
```

## Xcode快捷键

+ Ctrl + Command + ⬆️or⬇️ : 切换.h和.m
+ Shift + Command + O : 打开quick open  
+ Option + Command + [or] : 整体上下挪动一行代码