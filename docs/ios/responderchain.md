# 事件的产生和传递 - 响应者链

1. 找到响应者链中的响应者a

2. 在a上添加点击效果

 ![tapbutton](./src/tapbutton.png)

---


- [UITouch](https://developer.apple.com/documentation/uikit/uitouch?language=objc)

- [UIEvent](https://developer.apple.com/documentation/uikit/uievent?language=objc)

- [UIResponder](https://developer.apple.com/documentation/uikit/uiresponder?language=objc)

  + 子类
     + uiview 
        + uiwindow 
        + uicontrol
     + Uiapplication 
     + UIViewController

  + 三种事件
    + 触摸
    + 加速计
    + 远程控制

- 只在能响应事件的view上whoops （还是要时刻追踪点击点？）

- hook hittest方法。如果hittest被重写了怎么办？

- tap longpress 各种手势

- 友好的集成方式aop 直接pod就完事了 pod = [Debug] 







 点green：

​	uiapplication -> uiwindow -> self.view -> back0 -> back1 -> green

---

## 事件的传递和处理流程

1. 事件传递 
  
    `UIApplication` -> `UIWindow` -> `Super View` -> `Sub View`

2. 找到合适的响应者 `hittest:withEvent:` -> `pointInside:withEvent:`
    > 不接受触摸事件的几个原因：
    > + userInteractionEnabled = NO
    > + Hidden = YES
    > + Alpha = 0.0 ~ 0.01

    
   + 调用`hitTest:withEvent:`

     - 判断是否能响应事件
       - 不能的话return nil，
       - 能的话继续下一步

     - 调用`pointInside:withEvent:`，判断点击位置是否处于当前视图范围内。
       - 如果不在范围内，return nil。
       - 如果在范围内，向当前视图的所有子视图发送`hitTest:withEvent:`消息。子视图的遍历顺序是从subviews数组末尾向前遍历，直到有子视图返回非空对象，或者全部子视图遍历完毕。
         - 如果第一次有子视图返回非空对象，则`hitTest:withEvent`返回此对象，处理结束
         - 如果所有子视图都返回nil，则`hitTest:withEvent`返回自身。

     ```objc
     // point是该视图的坐标系上的点
     - (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
         // 1.判断自己能否接收触摸事件
         if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;
         // 2.判断触摸点在不在自己范围内
         if (![self pointInside:point withEvent:event]) return nil;
         // 3.从后往前遍历自己的子控件，看是否有子控件更适合响应此事件
         int count = self.subviews.count;
         for (int i = count - 1; i >= 0; i--) {
             UIView *childView = self.subviews[i];
             CGPoint childPoint = [self convertPoint:point toView:childView];
             UIView *fitView = [childView hitTest:childPoint withEvent:event];
             if (fitView) {
                 return fitView;
             }
         }
         // 没有找到比自己更合适的view
         return self;
     }
     ```

3. 事件的响应

    `Sub View` -> `Super View` -> `UIWindow` -> `UIApplication`

--- 
**响应者**

继承UIResponder的对象称之为响应者对象，能够处理touchesBegan等触摸事件。

**响应者链条**

由很多响应者链接在一起组合起来的一个链条称之为响应者链条。

每个能执行`hitTest:withEvent`方法的view都属于事件传递的一部分，但是，只有`pointInside:withEvent`返回YES的view才属于**响应者链条**

---

touchesBegan:withEvent:   点self.view上的按钮不走，点空白视图走这个方法






+ 点击产生event，传给UIapplication
+ 传递、找到合适的响应者，
+ 处理


---

扩大响应区域

事件穿透



----

[响应链探究 - hou](http://wiki.10101111.com/pages/viewpage.action?pageId=180835636)

[iOS视图响应与渲染 - hou](http://wiki.10101111.com/pages/viewpage.action?pageId=183142691)

https://juejin.im/post/5d396ef7518825453b605afa#heading-17
