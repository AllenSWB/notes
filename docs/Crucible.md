# Crucible：代码审查工具

+ [官网地址](https://www.atlassian.com/software/crucible)
+ [文档地址](https://confluence.atlassian.com/crucible/crucible-documentation-home-298977323.html)

    官网下载最新版 4.6.1 的Crucible，默认已经包含了FishEye 

## 平台要求

+ Java: JDK 1.8
+ 操作系统: Mac OS 、Linux
+ 数据库：MySQL
+ 浏览器：Chrome
+ Git
+ Atlassian applications： Jira

## 下载安装Circible

+ [下载地址 mac版](https://www.atlassian.com/software/crucible/download?_ga=2.118771913.1514170800.1545731801-328847260.1545638015)
+ [安装Circible](https://confluence.atlassian.com/crucible/installing-crucible-on-linux-and-mac-298977373.html)

  检查java版本

      java -version
  
  检查系统是否可以找到java

      echo $JAVA_HOME

  我是把下载下来的crucible放到了`~/Documents/crucible`路径下

  启动Crucible

      ./bin/start.sh

  在浏览器输入 `localhost:8060` 就能看到Crucible界面了！

## 使用Crucible

### 配置邮件

  - 点击'Admin'按钮计入管理员界面 
  - 点击'Global Setting -> Server'进入设置服务器界面
  - 在'Mail Server'一栏设置邮箱。我使用的是163邮箱，配置如下。设置完可以发下测试邮件，检测是否成功了。
  
    ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyjx8ipzquj31gk0pxwk7.jpg)

    ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyjxbf6o7wj30ix066dg6.jpg)

    ![](http://ww1.sinaimg.cn/mw690/006hznE2ly1fyjxdl0d7nj30oa0jswgx.jpg)

### 用户管理

  用户可以自己注册，也可以由管理员直接注册好。

  下面介绍管理员直接添加用户的方法。

  + 进入Admin界面。在'User Settings -> User'。点击'Add User'按钮

      ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyjxy7xuyhj310y0jhtd3.jpg)

### Code Review 代码审查

  登录，点击'Creat Review'。

  + 进入选择工程界面。只有一个工程的话，就会跳过这步。

      ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyjya9cqzkj30gr064q37.jpg)

    
  + 下个界面，选择要review的更改。点击按钮'Browse Changesets'
      
      ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyjycgzqjtj30xc0jfq50.jpg)
    
  + 选择要review的分支、提交。点击'Edit Details'
      
      ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyjyduk8ssj30xf0jgdj3.jpg)

  + 添加这次负责review的用户。然后点击开始‘Start Review’

      ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyjyj5kdwzj30mc0k8dhs.jpg)

  + 可以在'Review Dashboard'中查看和管理所有的review

      ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyjyn5ednsj31hc0q2n1f.jpg)

  + 刚刚我们创建了一个review，指定了'feifei'来负责这次的review。这时候'feifei'打开Crucible，就会收到一个这个review。可以看到，此时的状态是`TO REVIEW`。

      ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyjyoxgmw7j31hc07m75l.jpg)

  + 'feifei'可以针对这次的提交，提一些意见。'wenbo'就会收到邮件提醒。

      ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyjyt9t7ebj31h90k9gp7.jpg)
    
      ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyjz9br5iwj30qt0j340o.jpg)

  + 'feifei'完成review后，可以把状态改成`Complete`，然后就可以`Close`这次的review啦。

      ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyjz14fbvmj31hb0jegpk.jpg)

  + close之后，这次的review的工作就算完成了。此时状态变成 `Closed`。以后想要查看的话，可以在'Review Dashboard -> Archive'找到这次的review

      ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyjz5pzslrj31h70fhmzq.jpg)


## 参考链接

+ [Docker 建立 Crucible4.6.1 以及與 Crowd3.3.2 實現 SSO 單點登入](https://tw.saowen.com/a/d3fe024777662a971c5c6d3caa4e79dd8653813efafd60dcc6de22bb659f10ca)
+ [Atlassian系列软件破解研究记录](https://www.jianshu.com/p/20dbcf85f962)