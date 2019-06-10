# flutter学习系列
- [flutter学习系列](#flutter%E5%AD%A6%E4%B9%A0%E7%B3%BB%E5%88%97)
  - [相关链接](#%E7%9B%B8%E5%85%B3%E9%93%BE%E6%8E%A5)
  - [开发环境配置](#%E5%BC%80%E5%8F%91%E7%8E%AF%E5%A2%83%E9%85%8D%E7%BD%AE)
  - [更新环境变量](#%E6%9B%B4%E6%96%B0%E7%8E%AF%E5%A2%83%E5%8F%98%E9%87%8F)
  - [配置VSCode作为开发工具](#%E9%85%8D%E7%BD%AEvscode%E4%BD%9C%E4%B8%BA%E5%BC%80%E5%8F%91%E5%B7%A5%E5%85%B7)
  - [创建第一个flutter工程](#%E5%88%9B%E5%BB%BA%E7%AC%AC%E4%B8%80%E4%B8%AAflutter%E5%B7%A5%E7%A8%8B)
  - [遇到的问题](#%E9%81%87%E5%88%B0%E7%9A%84%E9%97%AE%E9%A2%98)
  
## 相关链接

+ 官方文档 [中](https://flutterchina.club/docs/) [英](https://flutter.io/docs/get-started/install) 
+ [闲鱼技术flutter](https://www.yuque.com/xytech/flutter)
+ [头条 Flutter iOS 混合工程实践 by 张星宇](https://xiaozhuanlan.com/topic/1538692074)
+ [flutter库](https://flutterawesome.com/)

## 开发环境配置

1. 安装`flutter` https://flutter.io/docs/get-started/install
2. 解压下载的文件，放到 `/Users/wenbo.sun/Documents/dev`路径下
3. 在当前路径，运行命令

        export PATH=`pwd`/flutter/bin:$PATH

4. 接着执行命令

        flutter doctor

## 更新环境变量

1. `cd ~`切到`home`目录下
2. 打开`.bash_profile`文件。如果没有就创建它`touch .bash_profile`
3. 编辑`.bash_profile`文件，添加以下三行。

        export PUB_HOSTED_URL=https://pub.flutter-io.cn  
        export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn 
        export PATH=/Users/wenbo.sun/Documents/dev/flutter/bin:$PATH
    
        /Users/wenbo.sun/Documents/dev/flutter/ 是我的flutter路径，你们可以根据实际替换。

4. 运行`source $HOME/.bash_profile`刷新当前`terminal`
5. 通过运行`flutter/bin`命令验证目录是否在已经在PATH中:

        echo $PATH

## 配置VSCode作为开发工具

1. `Shift + Command + P` 打开命令模式
2. 输入`doctor`，选择`Flutter: Run flutter doctor`执行。查看输出有没有错误，如果有错根据提示修改。

## 创建第一个flutter工程

1. 打开VSCode命令模式，选择`Flutter: New Project`执行。
2. 根据提示输入工程名，选择存放工程的目录。最后会自动生成一个工程模板，并打开`main.dart`文件

## 遇到的问题

+ 执行`flutter doctor`时候，检查出如下问题。

    ![执行flutter doctor](http://ww1.sinaimg.cn/large/006hznE2ly1fxh0uivphhj30on0eydje.jpg)

    提示我没装`libimobiledevice`和`ideviceinstaller`。没关系，我们可以先用模拟器跑工程。

    ![](http://ww1.sinaimg.cn/large/006hznE2ly1fxhuqgbgwnj311v0kmn4g.jpg)

+ 运行命令`brew install --HEAD usbmuxd `报错如下

  
    ```shell
    ./configure: line 16735: syntax error near unexpected token `libplist,'
./configure: line 16735: `PKG_CHECK_MODULES(libplist, libplist >= $LIBPLIST_VERSION)'
    
    READ THIS: https://docs.brew.sh/Troubleshooting
    ```
    
    解决方法：
    
    执行命令
    
    ```shell
    brew link  pkg-config  
    ```
    
    之后再执行命令
    
    ```shell
    brew install --HEAD usbmuxd
    brew unlink usbmuxd
    brew link usbmuxd
    brew install --HEAD libimobiledevice
    brew install ideviceinstaller
    ```
    
    
