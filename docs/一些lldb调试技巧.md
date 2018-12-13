1. 最常用的几个命令

    + `po`： 打印

        ![](http://ww1.sinaimg.cn/large/006hznE2ly1fy4xh3kp3sj30a101ojre.jpg)

    + `breakpoint`： 打断点

        ![](http://ww1.sinaimg.cn/large/006hznE2ly1fy4xz14lwaj30ak01z748.jpg)
    
    控制流快捷键对应的命令

    ![](http://ww1.sinaimg.cn/large/006hznE2ly1fy4y0w9khtj309i00va9w.jpg)

    + `c`： 继续，程序恢复执行
    + `n`： step over，单步执行 
    + `s`： step in，进入执行。eg: 断点打在方法调用处，执行step in操作，进入方法内部

        ![](http://ww1.sinaimg.cn/large/006hznE2ly1fy4y27kggoj30ku08lta0.jpg)

    + `finish`： step out，跳出。eg: 在方法内部，执行step out操作，跳出当前方法

        ![](http://ww1.sinaimg.cn/large/006hznE2ly1fy4y2tmsycj30fg07sjsg.jpg)

    查看帮助

    + `help`：查看所有可用的`lldb`命令
    + `help xx`：查看`xx`命令的帮助。类似终端中的`man`命令。eg: `help po`

        ![](http://ww1.sinaimg.cn/large/006hznE2ly1fy4ydnczh4j30q007pab5.jpg)

2. 调试过程中自动创建标签页

    如果当前停留在A页面，断点打在了B页面，开启这个功能。走过断点的时候Xcode会自动为B页面创建一个新的tab。

    设置 -> Behaviors -> Runing -> Pause - 选中 show Tab Name xxx in active window

    ![](http://ww1.sinaimg.cn/large/006hznE2ly1fxuiiegomij311v06htav.jpg)


3. 修改状态: `expr` 命令

    走到第30行代码的时候，在控制台输入命令`expr`，修改news.author为"林肯"，最后打印出来的就是我们修改后的值

    ![](http://ww1.sinaimg.cn/large/006hznE2ly1fxuirbw9k0j30gq081gn6.jpg)

4. 断点编辑功能

    1> 打断点，右键，Edit Breakpoint

    ![](http://ww1.sinaimg.cn/large/006hznE2ly1fxuiz6ihrnj30dn04a74w.jpg)

    2> 输入条件 `condition`；在 `action` 一栏输入一些调试命令

    ![](http://ww1.sinaimg.cn/large/006hznE2ly1fxuj133ie4j30j8066jsw.jpg)

    ![](http://ww1.sinaimg.cn/large/006hznE2ly1fxuj2u5912j30cy04h0tp.jpg)

    3> 执行

    ![](http://ww1.sinaimg.cn/large/006hznE2ly1fxuj235ubij30ie09ctb9.jpg)

5. `Symbolic Breakpoint`

    1> 增加全局断点 

    ![](http://ww1.sinaimg.cn/large/006hznE2ly1fxunxutdtmj307l04kjru.jpg)

    2> 设置`Symbol`

    ![](http://ww1.sinaimg.cn/large/006hznE2ly1fxuny4gdd6j30d9063q4c.jpg)

    3> 程序走到断点位置

    `po $arg1` ; `po $arg2` 打印

    ![](http://ww1.sinaimg.cn/large/006hznE2ly1fxunzesbfmj30uc0a276l.jpg)

6. [chisel by facebook](https://github.com/facebook/chisel) 

    lldb还支持Python脚本扩展，chisel就是facebook团队开源的一个lldb扩展集，提供了一些很方便的操作接口。

    [wiki地址](https://github.com/facebook/chisel/wiki)
    
    安装步骤：

    + `brew install chisel`
    
    + `cd ~`切到home目录下，查看有没有`.lldbinit`这个文件，如果没有的话创建一个`touch .lldbinit`。
    
    + 执行`open .lldbinit`，打开`.lldbinit`文件。
    
    + 把下面两行添加到文件末尾，保存退出。下次打开Xcode就可以使用chisel里的扩展命令了~

            command script import /usr/local/opt/chisel/libexec/fblldb.py
            command script import /path/to/fblldb.py

    使用：

    + `pviews`：打印当前视图层级。

        ![](http://ww1.sinaimg.cn/large/006hznE2ly1fy521xsk4pj312907177b.jpg)

        使用lldb命令能达到同样的效果 `po [[[UIApplication sharedApplication] keyWindow] recursiveDescription]`

        ![](http://ww1.sinaimg.cn/large/006hznE2ly1fy52bou0lij312n06ktbv.jpg)
    
    + `flicker`：闪烁视图，以便开发者能快速找到它。

        eg: `flicker 0x100903850`，执行这个命令，看到手机上对应的UIButton按钮闪烁了一下。

        另，此时我用一个image view挡住了这个button，执行这个命令是看不到闪烁的，因为被挡住了😅

    + `hide` & `show`： 隐藏或者显示一个view/layer

        eg: 执行`hide 0x1005136d0`，可以看到手机上这个image view被隐藏了，露出来了它下面的button按钮。
        执行`show 0x1005136d0`又显示出来了。

    + `mask` & `unmask`：`mask`是给view加个框。`unmask`相反效果。

        ![](http://ww1.sinaimg.cn/large/006hznE2ly1fy52v5escaj3032028dfs.jpg)
    
    + `pbundlepath`：打印main bundle路径

       ![](http://ww1.sinaimg.cn/large/006hznE2ly1fy52ytspayj30s301lmxg.jpg)

    + `plass`：打印一个实例的继承关系

        ![](http://ww1.sinaimg.cn/large/006hznE2ly1fy531bi69cj309t03wmxe.jpg)

    + `caflush`：强制刷新界面. force Core Animation flush

        示例：将当前控制器的背景色改成红色。

        - `pviews`：打印当前视图层级。得到self.view的ID是`0x13be12330`
        - `expr id $tempView = (id)0x13be12330`：将self.view绑定到tempView
        - `expr (void)[$tempView setBackgroundColor:[UIColor redColor]]`：设置tempView的背景色为红色
        - `caflush`：强制刷新界面。可以看到此时手机背景色成了红色了。

        ![](http://ww1.sinaimg.cn/large/006hznE2ly1fy53c0ckwbj312o0a8gpy.jpg)

        ![](http://ww1.sinaimg.cn/large/006hznE2ly1fy53cjklq7j30ku1120t8.jpg)

