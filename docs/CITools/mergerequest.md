# Merge Request & Code Review

## 形式

1. 代码评审会。就是将团队成员都组织起来开会，让代码Owner上去讲自己代码的实现和思路，其它人发表意见和进行讨论，也有把这种叫做team review。
2. 一对一评审。就是项目owner提交代码之后，让reviewer在空闲的时候帮忙评审代码，并且写出批注，owner收到批注后，进行修改或者回复。

## 工具

1. [Gerrit by Google](https://www.gerritcodereview.com/)
2. [Phabricator by facebook](https://www.phacility.com/)
3. 基于Pull Request工作流，结合gitlab或者GitHub来用。 租车团队使用这个方法。

## 基于 Gitlab 的 Code Review 流程

  gitlab用户角色有四种：Guest Reporter Developer Maintainer。

  + Guest：能在web上看，但是不能clone工程到本地
  + Reporter：能clone工程到本地，但是不能push修改到远端
  + Developer：能clone能push代码到远端非'master'分支
  + Maintainer：权限最大。

  下面，我们就以一个testProj工程，演示下Developer角色用户'孙文博'提Merge Request和Maintainer用户角色'objcMan'进行Code Review和Merge的过程。

### 流程如下

1. 'objcMan'创建了空工程'testProj'，邀请'孙文博'用户加入工程，分配角色为Developer
  
  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyehb1qngkj31ch0m478w.jpg)

2. 这时候有个新的任务来了，需要我们创建个模板工程放进来，把这个任务分配给了'孙文博'。

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyehf8rsjwj30e006o3yp.jpg)

  '孙文博'这时候来创建个新分支'initProj'，这个版本的任务就在这个分支上开发了。等到完成任务后，把代码推到远端。这时候打开gitlab网页。

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyehjqs7jjj30rn0lw41f.jpg)

  这次开发任务完成了，现在要把'initProj'分支上的内容合并到'master'分支上，但是当前用户'孙文博'没有访问master分支的权限，这时候就要提一个Merge Request了。看图片右上角箭头所指的按钮，点击!

  填写Merge Request内容。注意写好title desc ，选择正确的source branch和target branch。

  ![](http://ww1.sinaimg.cn/large/006hznE2ly1fyehpli2obj30hz0qn0y0.jpg)

3. 这时候'objcMan'用户就会收到一个提醒，有人发起MR了，去看看吧~

![](http://ww1.sinaimg.cn/large/006hznE2ly1fyeht8hw8dj30ed09jaai.jpg)

点进去，就能看到一个todo列表

![](http://ww1.sinaimg.cn/large/006hznE2ly1fyehu7kjhsj30ib02baaa.jpg)

选中这个事件，进入详情。点击 'open web IDE'按钮，进行Code Review，查看本次'孙文博'做了哪些更改。

![](http://ww1.sinaimg.cn/large/006hznE2ly1fyei84a0wdj30ro0pvtcx.jpg)

![](http://ww1.sinaimg.cn/large/006hznE2ly1fyehze1h31j31hc0qj45b.jpg)

检查完毕，觉得没问题，'objcMan'就可以点击第一个图上的'Merge'按钮，把代码合并到'master'分支上，这次开发工作就算完成了。

如果觉得不行，把意见写好，close这次merge。'孙文博'会收到通知，进行更改，然后再次提MR，重复上面流程就行了。