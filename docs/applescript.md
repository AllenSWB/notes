# 一个上传图片到GitHub的workflow



![](https://github.com/AllenSWB/notes/blob/master/src/imgs/屏幕快照%202019-01-08%20下午6.39.39.png)

![](https://github.com/AllenSWB/notes/blob/master/src/imgs/屏幕快照%202019-01-08%20下午6.37.53.png)


    on alfred_script(q)

      set originFileAlias to alias choose file

      tell application "Finder"
        move file originFileAlias to folder "Macintosh HD:Users:wenbo.sun:Desktop:git:notes:src:imgs"
      end tell

      tell application "Terminal"
        do script "cd ~/Desktop/git/notes"
      end tell

      delay 0.1

      tell application "Terminal"
        do script "git add ." in first window
        do script "git commit -m '上传一个图片' " in first window
      end tell

      delay 0.3

      tell application "Terminal"
        do script "git push" in first window
      end tell

      delay 3
      
      tell application "Safari"
        tell window 1
          set current tab to (make new tab with properties {URL:"https://github.com/AllenSWB/notes/tree/master/src/imgs"})
        end tell
      end tell

    end alfred_script