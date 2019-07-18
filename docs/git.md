# Git

1. 常用

    https://www.liaoxuefeng.com/wiki/896043488029600

    ![giteasy](../src/imgs/git/git_easy.JPG)

2. 回退

   ```shell
     git reset
   ```

3. git库更换地址，不丢失原来的提交记录

4. git关联远端仓库

    ![flutter_native_talk1](../src/imgs/git/git_remote_link.png)

5. 忽略文件 .gitignore

    - 已经纳入版本管理的文件，加入.gitignore不生效的问题
        
        .gitignore只能忽略那些原来没有被track的文件，如果某些文件已经被纳入了版本管理中，则修改.gitignore是无效的。

        只能clone到本地，删除后，再进行忽略。
        
    - iOS 工程
       - 忽略`Pods`
       - 提交`Podfile.lock`

6. git子模块submodule

    - 添加submodule : `git submodule add https://github.com/xxx.git`

        ```shell
           $ git submodule add https://github.com/xxx.git
            Cloning into 'xxx'...
            remote: Counting objects: 11, done.
            remote: Compressing objects: 100% (10/10), done.
            remote: Total 11 (delta 0), reused 11 (delta 0)
            Unpacking objects: 100% (11/11), done.
            Checking connectivity... done.
        ```
    - 删除submodule
      - `cd .git` 切换到.git目录，修改config，删掉 submodule
      - `cd modules` 删除子模块目录
      - `cd 项目根目录` 删除子模块目录

    - 直接clone下来submodule的代码 `git clone --recursive http://xxx.git`

        ![git clone](../src/imgs/git/gitclone.png)

        ![git clone 2](../src/imgs/git/gitclone2.png)