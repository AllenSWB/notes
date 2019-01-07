# Gerrit

+ [wiki地址](https://gerrit-documentation.storage.googleapis.com/Documentation/2.16.2/index.html)
+ 安装Gerrit指南
  - [默认配置安装](https://gerrit-documentation.storage.googleapis.com/Documentation/2.16.2/linux-quickstart.html)
  - [标准安装](https://gerrit-documentation.storage.googleapis.com/Documentation/2.16.2/install.html)
+ [etc/gerrit.config 配置文件](https://gerrit-documentation.storage.googleapis.com/Documentation/2.16.2/config-gerrit.html#_file_etcgerrit_config)

## 准备

+ 一个类unix系统。例如Mac OS
+ JAVA SE Runtime环境1.8。 不能使用JAVA 9或者更新的环境。 [Java下载地址](https://www.oracle.com/technetwork/java/javase/downloads/index.html) 、[Java8 下载地址](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)、[JAVA历史版本下载地址](https://www.oracle.com/technetwork/cn/java/archive-139210-zhs.html)
+ Gerrit默认使用[NoteDB](https://gerrit-documentation.storage.googleapis.com/Documentation/2.16.2/note-db.html)。也可以换成其他数据库。

## 下载Gerrit

+ [下载地址](https://www.gerritcodereview.com/index.html)。最新的是2.16.2.下载下来的安装包名为`gerrit-2.16.2.war`
+ [lucene下载地址](http://www.apache.org/dyn/closer.lua/lucene/java/7.6.0/lucene-7.6.0-src.tgz)

## 安装和初始化Gerrit

+ 打开terminal，运行一下命令

        java -jar gerrit-2.16.2.war init --batch --dev -d ./gerrit_test_site

    这个命令有两个参数：

    + `--batch`：设置配置默认值。详细配置见 [这里](https://gerrit-documentation.storage.googleapis.com/Documentation/2.16.2/config-gerrit.html)
    + `--dev`：配置Gerrit服务器选项为`DEVELOPMENT_BECOME_ANY_ACCOUNT`。这个选项的意思是允许你在不同用户间切换。 更多信息请看[这里](https://gerrit-documentation.storage.googleapis.com/Documentation/2.16.2/dev-readme.html)

  初始化成功显示以下界面：

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyj1pu9gf6j30os0an40y.jpg)

  这时候打开浏览器输入`localhost:8080`，会显示以下界面

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyj1rao45wj30t206175m.jpg)

  因为我们使用的是默认配置，这时候需要改下配置文件。配置文件路径是 `./gerrit_test_site/etc/gerrit.config`。

  Gerrit配置网站看 [这里](https://gerrit-documentation.storage.googleapis.com/Documentation/2.16.2/config-gerrit.html)

## 使用Gerrit

  开启Gerrit服务

      ./gerrit.sh start

  停止Gerrit服务

      ./gerrit.sh stop

  重启Gerrit服务

      ./gerrit.sh restart
