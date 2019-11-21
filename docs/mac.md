### 新Mac安装软件

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
- [x] Shadow[违规xxx]SocksX 
- [x] Alfred 
- [x] Chrome
- [x] Homebrew 
- [ ] mounty (brew cask install mounty)

- [x] Xcode
- [x] Cocoapods (sudo gem install cocoapods -v 1.6.1 另外 pod setup)
- [x] Postman
- [ ] Charles
- [x] Visual Studio Code
- [x] SourceTree
- [ ] homebrew 
- [ ] Sketch
- [ ] PS
- [ ] `brew install annie` 视频下载
- [ ] Ummy Video Downloader (YouTube视频下载)

 
——

- [x] 设置四个触发角
- [x] 设置Chrome为默认浏览器
- [x] MAC应用无法打开或文件损坏的处理方法 ： 设置允许任何来源的app  (打开终端，输入`sudo spctl --master-disable`然后按回车)
- [x] 切换输入法快捷键 系统输入法大写按钮
- [x] 命令行安装 `command line developer tool` : `xcode-select --install` 


——

- [软件资源站 xclient](xclient.info)  
- https://wxkxsw.com/link/Ce6mLeDTepd5W34C?mu=0

### 启用`root`用户

![](https://user-gold-cdn.xitu.io/2019/11/13/16e6391f49d95772?w=554&h=385&f=png&s=55381)

### Alfred 设置百度搜索

![](https://user-gold-cdn.xitu.io/2019/11/13/16e63920cf7b442b?w=2192&h=1430&f=jpeg&s=305686)

```shell
    # 百度搜索
    http://www.baidu.com/s?ie=UTF-8&wd={query}
    # github搜索
    https://github.com/search?q={query}&ref=opensearch
    # 掘金搜索
    https://juejin.im/search?query={query}
```

### Alfred 常用快捷键

+ `command` + `option` + `c` 最近复制的内容

### SourceTree免登陆使用
 
![sourcetree_withoutlogin](../src/imgs/sourcetree_withoutlogin.png)

### SourcegTree每次pull/push都要输入密码解决方法

终端输入:(第一次需要输入账号密码，以后就不用了)
```shell
git config --global credential.helper osxkeychain  
```

### Xcode常用的快捷键 

+ `Ctrl` + `command` + `上/下箭头` 切换`.h`和`.m`
+ `shift` + `command` + `O` 打开`quick open`
+ `option` + `command` + `[ / ]` 整行的上下移动代码