# shell

---

+ [shell教程](http://www.runoob.com/linux/linux-shell.html)
  
---

1. 第一个shell脚本

    创建一个文件 `a.sh`，写入以下代码

        #! /bin/bash
        echo "hello world"

    - `#!` 是一个约定的标记，告诉系统使用什么解释器来执行这个脚本。
    - 这里文件扩展名是`sh`。但其实扩展名不影响程序的执行，见名知意就行。如果使用php写shell脚本，扩展名就用php就好。
    - `echo` 用于向窗口输出文本

2. 运行shell脚本有两个方法

  + 作为可执行程序

    终端执行以下命令，改变权限

        chmod +x ./a.sh

    终端执行以下命令，执行脚本

        ./a.sh

         hello world // 输出

  + 作为解释器参数

    这种方式，直接运行解释器，参数就是shell脚本的文件名

        /bin/sh test.sh
        /bin/php test.php

    这种方式，不需要在第一行指定解释器信息，写了也没用。

3. shell变量命名

     + 命名只能使用英文字母，数字和下划线，首个字符不能以数字开头。
     + 中间不能有空格，可以使用下划线（_）。
     + 不能使用标点符号。
     + 不能使用bash里的关键字（可用help命令查看保留关键字）。

            name='liuyifei'

4. shell变量使用

    使用一个定义过的变量，只要在变量名前面加美元符号即可，如：

        echo $name

        myage="23"
        echo $myage
        myage="24"
        echo $myage

5. 只读变量

        #!/bin/bash
        myname="allen"
        readonly myname
        myname="joe"
  
    运行脚本，结果如下：

        /bin/sh: NAME: This variable is read only.

6. 删除变量 `unset` 命令

        unset variable_name

    变量被删除后不能再次使用。unset 命令不能删除只读变量。
