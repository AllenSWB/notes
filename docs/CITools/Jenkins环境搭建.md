# Jenkins环境搭建

## 准备

+ Java环境
+ 安装homebrew

## 安装Jenkins

    brew install jenkins
  
  安装完成结果如下

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fynpzh01vwj30qn0cdmzb.jpg)

  在终端执行命令

    jenkins

  此时终端会显示以下内容，复制红框里一串字符。

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fynq1t1ne8j30vc0c3abb.jpg)

  打开浏览器 `localhost:8080`，显示以下界面。输入上面复制的一串字符。

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fynq3dxrh4j30ft07zwfy.jpg)

  开始安装。选择默认安装，后续也可以自己再根据需要下载新的插件。

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fynq49ljrij30p40f8q5t.jpg)

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fynq5030baj30p40q9jub.jpg)

  安装完成，会展示如下界面。根据提示，一步步往下就行。

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fynqch2yl6j30ir0acaar.jpg)

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fynqgykgmcj30lq09swfr.jpg)

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fynqh8g0xcj30dz0763z0.jpg)

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fynqhgox0jj30p50j575x.jpg)

  至此，Jenkins安装完成！！！

## 关闭和重启Jenkins

+ 开启。终端输入`jenkins start`
+ 关闭
  + 终端 `Crl + C`
  + 浏览器输入

            http://localhost:8080/exit
+ 重启

        http://localhost:8080/restart
+ 重新加载配置信息

        http://localhost:8080/reload