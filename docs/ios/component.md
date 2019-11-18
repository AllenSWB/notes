## 当我们谈组件化的时候，要关注那些点

+ 解耦
+ 通信
+ 组件粒度

## 常见的方案有那些

+ `protocol`
+ `target-action`
+ 路由 

  ```shell
  https://github.com/meili/MGJRouter
  https://github.com/casatwy/CTMediator
  https://github.com/alibaba/BeeHive
  ``` 

## 聊聊 `CTMediator`

`CTMediator`是用target-action方式实现组件化的。它的核心类只有一个`CTMediator`，大约200行代码。在`.h`中提供了两个调用方法，一个远程调用方法`performActionWithUrl:completion:`，一个本地调用方法`performTarget:action:params:shouldCacheTarget`。这两个方法内部都是通过`performTarget`方法调用服务方组件的`target` `action`. `CTMediator`类的调用时通过`runtime`主动发现服务的，所以服务方对此类是完全解耦的。 （👈 解耦和通信）


每个组件都创建一个`CTMediator`的分类，将对组件的`performTarget`调用放到对应的分类里。这些分类就属于`ctmediator`的中间件，从而实现了感官上的接口分离。

每个组件又有一个`target`类，在`target`类中声明`action`方法。`target`类是当前组件对外提供的一个`服务类`。`ctmediator`通过runtime主动发现服务。

传参通过`param`传递，这是它的**去model化**的概念。在`action`中方法实现中，对传进来的字典参数进行解析，再调用组件内部的类和方法。

+ [iOS模块化](https://www.jianshu.com/c/32e98d5f3216)

## 怎么做`AppDelegate`瘦身的

创建一个`BWAppService`协议


