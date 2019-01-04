## Java相关知识

### JDK JRE JVM

+ JDK(Java Development Kit) 是 Java 语言的软件开发工具包(SDK)。在JDK的安装目录下有一个jre目录，里面有两个文件夹bin和lib，在这里可以认为bin里的就是jvm，lib中则是jvm工作所需要的类库，而jvm和 lib合起来就称为jre。

+ JRE（Java Runtime Environment，Java运行环境），包含JVM标准实现及Java核心类库。JRE是Java运行环境，并不是一个开发环境，所以没有包含任何开发工具（如编译器和调试器）

+ JVM是Java Virtual Machine（Java虚拟机）的缩写，JVM是一种用于计算设备的规范，它是一个虚构出来的计算机，是通过在实际的计算机上仿真模拟各种计算机功能来实现的。 

    JDK是整个Java的核心，包括了Java运行环境JRE、Java工具和Java基础类库。JRE是运行JAVA程序所必须的环境的集合，包含JVM标准实现及Java核心类库。JVM是整个java实现跨平台的最核心的部分，能够运行以Java语言写的程序。

### Java SE 、Java EE、Java ME

+ Java SE 是做电脑上运行的软件。

+ Java EE 是用来做网站的-（我们常见的JSP技术）

+ Java ME 是做手机软件的。

### 电脑上存在多个Java版本切换

+ [切换jdk版本](https://www.imooc.com/article/24194?block_id=tuijian_wz)


`cd` 到 `/Library/Java/JavaVirtualMachines/` 路径下，`ls` 查看

    ls /Library/Java/JavaVirtualMachines/

我的终端输出如下，说明我的电脑上现在有两个版本的jdk了。  
        
    jdk-11.0.1.jdk		jdk1.8.0_191.jdk

在`~`目录下，打开`.bash_profile`文件。添加以下内容

    # 设置java各个版本路径
    export JAVA_8_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_191.jdk/Contents/Home  
    export JAVA_11_HOME=/Library/Java/JavaVirtualMachines/jdk-11.0.1.jdk/Contents/Home  

    # 设置默认java版本
    export JAVA_HOME=$JAVA_11_HOME
     
    # 设置切换java版本快捷键
    alias jdk8='export JAVA_HOME=$JAVA_8_HOME' 
    alias jdk11='export JAVA_HOME=$JAVA_11_HOME' 

终端输入命令

    jdk8

查看当前java版

    java --version

此时查看当前jdk路径

    echo $JAVA_HOME

    // 输出eg:
    /Library/Java/JavaVirtualMachines/jdk1.8.0_191.jdk/Contents/Home

### 踩坑

我执行`jdk8`，命令，然后查看java版本`java --version`出错。但是此时查看`echo $JAVA_HOME`可以看到是起了作用的。
![](http://ww1.sinaimg.cn/large/006hznE2ly1fyizekvstkj30op07xgn2.jpg)


我的解决办法如下

+ 卸载java11 

      sudo rm -rf /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/
      sudo rm -rf /Library/PreferencePanes/JavaControlPanel.prefPane

      ls /Library/Java/JavaVirtualMachines/

      sudo rm -rf /Library/Java/JavaVirtualMachines/jdk-11.0.1.jdk/

+ 安装jdk8

+ 配置 `.bash_profile` 文件

      # 设置java各个版本路径
      JAVA_8_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_191.jdk/Contents/Home  

      # 设置默认java版本
      JAVA_HOME=$JAVA_8_HOME
        
      export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH

+ 我的`.bash_profile`文件后面又改了一次，如下

      export PATH="/usr/local/bin:$PATH"

      export PUB_HOSTED_URL=https://pub.flutter-io.cn  
      export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn 
      export PATH=/Users/wenbo.sun/Documents/dev/flutter/bin:$PATH

      # 设置java各个版本路径
      JAVA_8_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_191.jdk/Contents/Home  
      
      # 设置默认java版本
      JAVA_HOME=$JAVA_8_HOME
      JRE_HOME=$JAVA_HOME/jre

      PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
      CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib

      export JAVA_HOME
      export JRE_HOME

      export PATH  


### 安装MySql 

+ 安装

        brew install mysql

+ 重装

        brew reinstall mysql

    ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyj298ocwbj30oy0e7diz.jpg)

+ 卸载

        brew uninstall mysql

+ 踩坑

    ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyj29racrij30ol02mmxp.jpg)

    连接localhost通常通过一个Unix域套接字文件进行，一般是/tmp/mysql.sock。如果套接字文件被删除了，本地客户就不能连接。这可能发生在你的系统运行一个cron任务删除了/tmp下的临时文件。

    如果你因为丢失套接字文件而不能连接，你可以简单地通过重启服务器重新创建得到它。因为服务器在启动时重新创建它。

+ 我的解决办法。

    不用brew安装。去[这里](https://dev.mysql.com/downloads/mysql/)下载安装包。下载dmg类型的那个。