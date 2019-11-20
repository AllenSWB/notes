- [函数响应式编程](#%e5%87%bd%e6%95%b0%e5%93%8d%e5%ba%94%e5%bc%8f%e7%bc%96%e7%a8%8b)
- [RAC](#rac)
- [RAC中的主要类](#rac%e4%b8%ad%e7%9a%84%e4%b8%bb%e8%a6%81%e7%b1%bb)
- [冷信号 热信号](#%e5%86%b7%e4%bf%a1%e5%8f%b7-%e7%83%ad%e4%bf%a1%e5%8f%b7)
- [副作用](#%e5%89%af%e4%bd%9c%e7%94%a8)
- [`map`、`fliter` ...](#mapfliter)
- [RACObserve 宏](#racobserve-%e5%ae%8f)
- [RAC双向绑定](#rac%e5%8f%8c%e5%90%91%e7%bb%91%e5%ae%9a)
- [RAC里的设计模式](#rac%e9%87%8c%e7%9a%84%e8%ae%be%e8%ae%a1%e6%a8%a1%e5%bc%8f)
- [RAC使用注意内存问题](#rac%e4%bd%bf%e7%94%a8%e6%b3%a8%e6%84%8f%e5%86%85%e5%ad%98%e9%97%ae%e9%a2%98)
- [RACObserve宏为什么会报 `Unknown warning group '-Wreceiver-is-weak', ignored`](#racobserve%e5%ae%8f%e4%b8%ba%e4%bb%80%e4%b9%88%e4%bc%9a%e6%8a%a5-unknown-warning-group--wreceiver-is-weak-ignored)
- [`@weakify(...)` 和 `@strongify(...)` 两个宏的定义](#weakify-%e5%92%8c-strongify-%e4%b8%a4%e4%b8%aa%e5%ae%8f%e7%9a%84%e5%ae%9a%e4%b9%89)
- [rac中的 `materialize` && `dematerialize`](#rac%e4%b8%ad%e7%9a%84-materialize--dematerialize)
- [RAC通知监听的移除](#rac%e9%80%9a%e7%9f%a5%e7%9b%91%e5%90%ac%e7%9a%84%e7%a7%bb%e9%99%a4)
- [链接](#%e9%93%be%e6%8e%a5)

## 函数响应式编程

常见编程范式

  + 命令式
  + 函数式
  + 逻辑式
  + 响应式
  + ...
      
**函数式编程**中的`函数`，不是计算机中的函数，而是数学上的函数。即自变量映射。函数式强调的函数：
      
   + 不改变外部状态
   + 不依赖外部状态

函数是一等公民，可以在任何地方定义，在函数内或函数外，可以作为函数的参数和返回值，可以对函数进行组合。

函数式语言特点
   
   + 高阶函数
   + 偏应用函数
   + 柯里化 ？
   + 闭包

**纯函数：**  就是返回值只由输入值决定，而且没有可见副作用的函数或者表达式。纯函数的调用在相同参数下的返回值第二次不需要计算。

**响应式**是一个专注于数据流和变化传递的异步编程范式。这意味着可以在编程语言中很方便地表达静态或动态的数据流，而相关的计算模型会自动将变化的值通过数据流进行传播。  

## RAC
  
rac是函数响应式编程框架。

rac统一了kvo、UIevent、网络请求、async异步工作

+ `RACObserve(self.viewModel, inputPhoneNumber);`
+ `textfield.rac_textSignal`
+ 一个异步网络请求，可以返回一个`RACSubject`，然后将`RACSubject`绑定到一个subscriber或信号

任何的信号转换即是对原有信号进行订阅从而产生新的信号。

## RAC中的主要类

  ```objc
  RACStream 
  ----RACSignal 
  ------- RACSubject
  RACSequence
  ```

+ `RACStream`： 抽象类
  + RACSignal：一个随着时间改变值得信号。最常用的。 
    + `RACSubject`：RACSubject是继承自RACSignal，并且它还遵守RACSubscriber协议。这就意味着它既能订阅信号，也能发送信号。（网络失败）
  + `RACSequence`
+ `RACCommand`： 封装网络请求的时候用这个类
+ `RACSubscriber`

RACSubject使用的时候需要注意内存泄漏，RACSignal可以放心的使用。
 
## 冷信号 热信号 

+ [ReactiveCocoa 中 RACSignal 冷信号和热信号底层实现分析](https://www.jianshu.com/p/21beb4c59bcc)

**冷信号**

+ 冷信号是被动的，只有订阅的时候才会完整的发布消息。
+ 冷信号只能一对一，当有不同的订阅者，消息重新完整发送。

```objc
// 冷信号 eg:
RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    // 触发信号
    [subscriber sendNext:@"hahaha"];
    [subscriber sendNext:@"hahahaee3"];
    [subscriber sendCompleted];
    
    return nil;
}] replay];

[signal subscribeNext:^(id  _Nullable x) {
    NSLog(@"订阅 %@",x);
}];

dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [signal subscribeNext:^(id  _Nullable x) {
           NSLog(@"新的订阅者 %@",x);
    }];
});
```
  
**热信号** RAC中所有的热信号都属于一个类RACSubject

+ 热信号是主动的，尽管你没有订阅事件，它会时刻推送；
+ 可以有多个订阅者，是一对多，集合可以与订阅者共享信息
  
```objc
// 1. 继承自RACSignal，且遵循协议RACSubscriber。意味着RACSubject既可以发送信号，也能订阅信号
@interface RACSubject<ValueType> : RACSignal<ValueType> <RACSubscriber>
@end


//2. RACSubject 把它的所有订阅者全部都保存到了NSMutableArray的数组里。既然保存了所有的订阅者，那么sendNext，sendError，sendCompleted时候遍历数组里的元素然后发送信号。
#pragma mark Subscription
- (RACDisposable *)subscribe:(id<RACSubscriber>)subscriber {
	NSCParameterAssert(subscriber != nil);

	RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];
	subscriber = [[RACPassthroughSubscriber alloc] initWithSubscriber:subscriber signal:self disposable:disposable];

	NSMutableArray *subscribers = self.subscribers;
	@synchronized (subscribers) {
		[subscribers addObject:subscriber];
	}
	
	[disposable addDisposable:[RACDisposable disposableWithBlock:^{
		@synchronized (subscribers) { 
			NSUInteger index = [subscribers indexOfObjectWithOptions:NSEnumerationReverse passingTest:^ BOOL (id<RACSubscriber> obj, NSUInteger index, BOOL *stop) {
				return obj == subscriber;
			}];

			if (index != NSNotFound) [subscribers removeObjectAtIndex:index];
		}
	}]];

	return disposable;
}
 ``` 

RACSubject满足了热信号的特点，它即使没有订阅者，因为自己继承了RACSubscriber协议，所以自己本身就可以发送信号。冷信号只能被订阅了才能发送信号。

RACSubject可以有很多订阅者，它也会把这些订阅者都保存到自己的数组里。RACSubject之后再发送信号，订阅者就如同一起看电视，播放过的节目就看不到了，发送过的信号也接收不到了。接收信号。而RACSignal发送信号，订阅者接收信号都只能从头开始接受，如同看点播节目，每次看都从头开始看。


**冷信号如何转化为热信号**

+ 冷信号转换成热信号需要用到`RACMulticastConnection 广播`这个类。 

    冷信号和热信号的本质区别在于是否保持状态。冷信号的多次订阅是不保持状态的，而热信号的多次订阅可以保持状态。
    
    一种将冷信号转为热信号的方法就是，将冷信号订阅，订阅到的每一个时间通过RACSubject发送出去，其他订阅者只订阅这个RACSubject。

## 副作用

RACMulticastConnection 用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。

 以下几个副作用的场景: 

  + 函数的处理过程中，修改了外部的变量，例如全局变量。
  + 函数的处理过程中，触发了一些额外的动作，例如发送了一个全局的Notification，在console里输入了一行信息，保存了文件，触发了网络，更新了屏幕等。
  + 函数的处理过程中，受到外部变量的影响，例如全局变量，方法中用到的成员变量。block中捕获的外部变量也算副作用。
  + 函数的处理过程中，受到线程锁的影响算副作用。


## `map`、`fliter` ...

![](../../src/imgs/ios/map_emoji.jpg)

## RACObserve 宏

+ [RAC 中的 RACObserve 监听流程分析](https://www.jianshu.com/p/dbeb0b45fdc8)

```objc
#define _RACObserve(TARGET, KEYPATH) \
({ \
	__weak id target_ = (TARGET); \
	[target_ rac_valuesForKeyPath:@keypath(TARGET, KEYPATH) observer:self]; \
})

#if __clang__ && (__clang_major__ >= 8)
#define RACObserve(TARGET, KEYPATH) _RACObserve(TARGET, KEYPATH)
#else
#define RACObserve(TARGET, KEYPATH) \
({ \
	_Pragma("clang diagnostic push") \
	_Pragma("clang diagnostic ignored \"-Wreceiver-is-weak\"") \
	_RACObserve(TARGET, KEYPATH) \
	_Pragma("clang diagnostic pop") \
})
```  
![](../../src/imgs/ios/racobserve.png) 

```objc
NSLock *lock = [[NSLock alloc] init]; 
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ 
    static void (^RecursiveMethod)(int); 
    RecursiveMethod = ^(int value) { 
        [lock lock];
        if (value > 0) { 
            NSLog(@"value = %d", value);
            sleep(2);
            RecursiveMethod(value - 1); // 递归的调用了这个block，上次的还没解锁，所以它需要等待锁被解除，这样就导致了死锁，线程被阻塞住了。
        }
        [lock unlock];
    }; 
    RecursiveMethod(5);
});

// 这个case里会造成死锁，终端里只会打印出 5 。
// 解决办法是换成递归锁 NSRecursiveLock
 NSRecursiveLock *lock = [[NSRecursiveLock alloc] init]; // 终端里会打印出 5 4 3 2 1
```

## RAC双向绑定 

+ [RAC双向绑定](https://www.jianshu.com/p/3bd2d3ca6210)

```objc
// 常见使用
RACChannelTo(self.viewModel, username) = self.usernameTextField.rac_newTextChannel;
```

```objc 
/* 
    1. RACChannelTermianl
    2. RACChannel -> leadingTerminal & followlingTerminal
    3. 直接使用RACChannel实现双向绑定，会出现堆栈溢出的错误。解决方案在RACKVOChannel
*/
#define RACChannelTo(TARGET, ...) \
    metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__)) \
        (RACChannelTo_(TARGET, __VA_ARGS__, nil)) \
        (RACChannelTo_(TARGET, __VA_ARGS__))
 
#define RACChannelTo_(TARGET, KEYPATH, NILVALUE) \
    [[RACKVOChannel alloc] initWithTarget:(TARGET) keyPath:@keypath(TARGET, KEYPATH) nilValue:(NILVALUE)][@keypath(RACKVOChannel.new, followingTerminal)]
```

## RAC里的设计模式

+ [从ReactiveCocoa中能学到什么？不用此库也能学以致用](https://www.jianshu.com/p/39e27fef38fa)

  ![](../../src/imgs/ios/rac_command.png)
  ![](../../src/imgs/ios/rac_lterator.png)
  ![](../../src/imgs/ios/rac_observer.png)

## RAC使用注意内存问题

**RACObserve**

这个宏里面已经引用了self，使用的时候注意加上weakify strongify

**RACSubject**

+ 对subject进行map这样的操作，这时就需要sendCompleted
+ subject会持有订阅者
 
    + RACSubject
        - RACSubject和RACSignal虽然都是信号，但是他们有个本质的区别。
        - RACSubject会持有订阅者，而RACSignal不会持有订阅者。

**使用RAC必须保证信号SendError或者SendComplete**

 
## RACObserve宏为什么会报 `Unknown warning group '-Wreceiver-is-weak', ignored`


在之前的Xcode中如果消息接受者是一个weak对象，clang编译器会报receiver-is-weak警告，所以加了这段push&pop，最新的clang已经把这个警告给移除，所以没必要加push&pop了。

```objc
  #define RACObserve(TARGET, KEYPATH) \
({ \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wreceiver-is-weak\"") \
__weak id target_ = (TARGET); \
[target_ rac_valuesForKeyPath:@keypath(TARGET, KEYPATH) observer:self]; \
_Pragma("clang diagnostic pop") \
})

  // 修改后的observe宏
  #define MTObserve(TARGET, KEYPATH) \
  ({ \
  __weak id target_ = (TARGET); \
  [target_ rac_valuesForKeyPath:@keypath(TARGET, KEYPATH) observer:self]; \
  })
```

## `@weakify(...)` 和 `@strongify(...)` 两个宏的定义

```objc

#define weakify(...) \
    rac_keywordify \
    metamacro_foreach_cxt(rac_weakify_,, __weak, __VA_ARGS__)

#define strongify(...) \
      rac_keywordify \
      _Pragma("clang diagnostic push") \
      _Pragma("clang diagnostic ignored \"-Wshadow\"") \
      metamacro_foreach(rac_strongify_,, __VA_ARGS__) \
      _Pragma("clang diagnostic pop")


  /**
      id foo = [[NSObject alloc] init];
      id bar = [[NSObject alloc] init];

      @weakify(foo, bar);

      // this block will not keep 'foo' or 'bar' alive
      BOOL (^matchesFooOrBar)(id) = ^ BOOL (id obj){
          // but now, upon entry, 'foo' and 'bar' will stay alive until the block has
          // finished executing
          @strongify(foo, bar);

          return [foo isEqual:obj] || [bar isEqual:obj];
      };
  */
```

## rac中的 `materialize` && `dematerialize`
   
 ```objc
 // .h文件

  1. materialize 将原signal的每个事件包装成RACEvent，通过返回的新signal的subscriber的sendNext:方法发送出去

  /// Converts each of the receiver's events into a RACEvent object.
  /// Returns a signal which sends the receiver's events as RACEvents, and
  /// completes after the receiver sends `completed` or `error`.
  - (RACSignal *)materialize;

  1. dematerialize 将RACEvent转为signal的事件

  /// Converts each RACEvent in the receiver back into "real" RACSignal events.
  /// Returns a signal which sends `next` for each value RACEvent, `error` for each
  /// error RACEvent, and `completed` for each completed RACEvent.
  - (RACSignal *)dematerialize;

  // .m文件

  - (RACSignal *)materialize {
      return [[RACSignal createSignal:^(id<RACSubscriber> subscriber) {
          return [self subscribeNext:^(id x) {
	    [subscriber sendNext:[RACEvent eventWithValue:x]];
   	} error:^(NSError *error) {
	    [subscriber sendNext:[RACEvent eventWithError:error]];
	    [subscriber sendCompleted];
    } completed:^{
	    [subscriber sendNext:RACEvent.completedEvent];
	    [subscriber sendCompleted];
    }];
   }] setNameWithFormat:@"[%@] -materialize", self.name];
  }
  
  - (RACSignal *)dematerialize {
   return [[self bind:^{
    return ^(RACEvent *event, BOOL *stop) {
	    switch (event.eventType) {
	    	case RACEventTypeCompleted:
		    	*stop = YES;
		    	return [RACSignal empty];
		    case RACEventTypeError:
		    	*stop = YES;
		    	return [RACSignal error:event.error];
		    case RACEventTypeNext:
		    	return [RACSignal return:event.value];
	    }
    };
   }] setNameWithFormat:@"[%@] -dematerialize", self.name];
  }
 ```

## RAC通知监听的移除
  
+ [RAC中监听通知的坑](https://juejin.im/post/5a30974ef265da433562bec2)

一个实例：

点击车控先去校验实名状态，因为实名状态可能会在后台被更改，所以要请求后台实时的数据。请求完最新实名状态后，再继续后面的操作。

  ```objc
  // UserRealNameAuthTool类
  - (void)commanVerifyRealNameWithDic:(NSDictionary *)params {

    RACSignal *ss = [[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UserSyncVerifyInfoWithServerSuccessNoti" object:nil];
    
    self.disposableObj = [ss subscribeNext:^(id  _Nullable x) {
        NSLog(@"更新认证信息成功~!!!!!!");

        NSNotification *noti = (NSNotification *)x;
        BOOL syncSuccess = ((NSNumber *)noti.object).boolValue;
        if (syncSuccess) {
            NSLog(@"同步后台成功 - 更新认证信息成功~!!!!!");
        } else {
            NSLog(@"同步后台失败");
        }
        
        [UserRealNameAuthTool _handleToRealNameAuth:params];
        [self.disposableObj dispose];//rac 移除通知监听。这里如果不移除的话， 第n次调用commanVerifyRealNameWithDic的时候，就会打印n遍 "更新认证信息成功~!!!!!!""
    }];
    
    // 更新个人信息
    NSNotification *noti = [NSNotification notificationWithName:@"UserNeedUpadteUserVerifyInfoNoti" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
  } 

  // ------------------- 分割线 --------------------

  // UserHomePageViewController类
  @weakify(self)
  [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UserNeedUpadteUserVerifyInfoNoti" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
      @strongify(self)
      [self.viewModel requestApiSuccess:^{
          dispatch_async(dispatch_get_main_queue(), ^{
              NSNotification *noti = [NSNotification notificationWithName:@"UserSyncVerifyInfoWithServerSuccessNoti" object:@(YES)];
              [[NSNotificationCenter defaultCenter] postNotification:noti];
          });
          
          
          @strongify(self)
          [self _updateUserHeaderView];
          [self.myTableView reloadData];
      } fail:^(NSError * _Nonnull error) {
          dispatch_async(dispatch_get_main_queue(), ^{
              NSNotification *noti = [NSNotification notificationWithName:@"UserSyncVerifyInfoWithServerSuccessNoti" object:@(NO)];
              [[NSNotificationCenter defaultCenter] postNotification:noti];
          });
      }];
  }]; 
  ```


<!-- 
 RAC vs rxSwift  
 -->  



## 链接

+ [ReactiveCocoaStudy](https://github.com/AllenSWB/ReactiveCocoaStudy)  
+ [iOS函数响应式编程以及ReactiveCocoa的使用](http://www.starming.com/2016/08/09/how-to-use-reactivecocoa/)
+ [ReactiveCocoa v2.5 源码解析 之 架构总览](http://www.cocoachina.com/articles/14880)
+ [EasyReact](https://juejin.im/post/5d3fac90e51d4561ad654843)
+ iOS开发高手课 


<!--  
今天分享的重点：

    + 函数响应式编程？
    + rac里主要的类：racstream racsignal racsubject ；概念：冷信号、热信号、副作用
    + rac使用的注意事项 ：内存
    + 我接触rac的感受。 上手难度？难调试？为什么前端群react.js火，iOS里rac不是很火？
    + rac里的设计模式

Q&A: 
> 1. RAC中的冷信号和热信号是什么，有什么区别
> 2. RAC的双向绑定怎么做到的，为什么没有引起循环引用
> 3. RAC中如何监听方法调用的 
> 4. rac使用注意事项

 -->