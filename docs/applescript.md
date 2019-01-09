# 一个上传图片到GitHub的workflow

![](https://github.com/AllenSWB/notes/blob/master/src/imgs/屏幕快照%202019-01-08%20下午6.39.39.png)

      # 第一步、将要上传的图片移到本地repo的目录下
      set currentDesktopPath to path to desktop folder

      set myImgList to alias choose file with prompt "选取要上传的图片，允许多选" default location currentDesktopPath with multiple selections allowed

      set myRepoPath to alias choose folder with prompt "选择本地git repo的路径"

      set myRepoImgsPath to alias choose folder with prompt "选择本地git repo存放imgs的路径"

      tell application "Finder"
        move myImgList to folder myRepoImgsPath
      end tell

      # 第二步、在终端执行git命令
      set myRepoPOSIXPath to POSIX path of myRepoPath

      tell application "Terminal"
        do script "cd " & myRepoPOSIXPath
        delay 0.5
        do script "git add ." in first window
        do script "git commit -m '上传图片' " in first window
        delay 0.5
        do script "git push" in first window
      end tell

      # 第三步、在浏览器打开origin repo

      tell application "Safari"
        tell window 1
          set current tab to (make new tab with properties {URL:"https://github.com/AllenSWB/notes/tree/master/src/imgs"})
        end tell
      end tell