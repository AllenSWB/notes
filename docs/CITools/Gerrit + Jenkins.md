- [Gerrit + Jenkins](#%08gerrit--jenkins)
  - [Jenkins配置](#jenkins%E9%85%8D%E7%BD%AE)
  - [Gerrit配置](#gerrit%E9%85%8D%E7%BD%AE)
  
# Gerrit + Jenkins

+ 链接

  - https://www.cnblogs.com/kevingrace/p/5651447.html
  - https://blog.csdn.net/vector090/article/details/19482491
  - https://www.cnblogs.com/276815076/p/7299860.html

## Jenkins配置

  登录Jenkins页面

+ 工作台 -> 系统管理 -> 插件管理 -> 可选插件 

  安装以下两个插件

    -  Gerrit trigger 
    -  Git plugin

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fymmkk7ph1j31gv0b9mzp.jpg)

+ 工作台 -> 系统管理 -> Gerrit Trigger

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fymk3xb2xlj30c501waa2.jpg)

  Add New Server 

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fymk4oivfdj307v07pglv.jpg)

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fymk64m1mhj30ku07swf4.jpg)

  详细配置如下

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fymkprvmpgj317q0hv42p.jpg)

  遇到了以下错误，解决方法如图：

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fymkqqpihij30el093dgj.jpg)

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fymkrxt6wcj311x09ljsw.jpg)

  Gerrit Reporting Values 配置：用于Jenkins向Gerrit传信息

  在Jenkins项目配置里

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyy0a5fmn1j30q305rglx.jpg)

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyy092axr5j313o0bgjs8.jpg)

  在gerrit的project配置里，给用户加上verified权限

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyy0cuct3ej30u20jxjv1.jpg)

## Gerrit配置

  + 需要gerrit安装 verified label 功能。

    查看是否有这个功能，可以登录gerrrit。
  
    在 Projects -> list -> all-projects -> access -> edit -> add permission 看看里面是否有`verified`选项

    ![](http://ww1.sinaimg.cn/large/006hznE2ly1fymluhxct2j30kx0oywib.jpg)

    如果没有的话，需要给Gerrit加上这个功能。方法如下

    ![](http://ww1.sinaimg.cn/large/006hznE2ly1fymmg585mdj30ej08edgy.jpg)

    给`All-Projectes`工程加上功能之后，所有子工程也都有这个功能了(需要restart服务)。加上之后再看：

    ![](http://ww1.sinaimg.cn/large/006hznE2ly1fymmgt347uj30ib0m2q63.jpg)

+ 给工程加上verified label 功能。方法如下

  Projects -> Access -> Edit(新版UI没有edit功能，旧版UI才有) -> Reference: refs/heads/* 项

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fymn32gm7hj30mo06nacv.jpg)

  添加`Label Verified`功能，增加一个Group，名字是`Non-Interactive Users`。保存更改

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fymn0pdrayj30ib0r9q6h.jpg)

  注意： 需要把Jenkin用户加到`Non-Interactive Users`组内。

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fymn5weszej30el06ymxy.jpg)

+ 一次完整code review示例

  + clone 工程

          git clone ssh://wenbo.sun@10.99.57.65:29418/jenkinsTest.git

  + 安装git review

          brew install git-review

    使用
    
    - 本地修改后，将修改提交到work space
    - 将修改提到gerrit
    
          git review

  + 推送本地更改到gerrit

          git push origin <branch name>

  + 在Gerrit平台上review code

---

+ 测试工程Jenkins下载地址  https://10.99.33.133/ota/jenkinsTest/develop/debug/jenkinsTest_V1++_2018122917-30-48.ipa
