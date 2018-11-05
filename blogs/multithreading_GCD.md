
## 多线程 - GCD
 
### 0. 参考
 
   + [细说GCD by 戴铭](https://www.jianshu.com/p/fbe6a654604c)
   
   + https://opensource.apple.com/source/libdispatch/
   
   + https://github.com/apple/swift-corelibs-libdispatch
 
### 1. 开发者需要做的是定义想执行的任务，并追加到适当的Dispatch Queue中
 
    dispatch_async 异步执行
    dispatch_sync 同步执行
 
### 2. 队列 dispatch_queue_t
 
#### 1> 队列的分类
 
serial dispatch queue 串行队列, 等待现在执行中处理结束
    concurrent dispatch queue 并行队列, 不等待现在执行中处理结束
 
⚠️ 无论是serial串行还是concurrent并行队列，执行任务都是FIFO先进先出的方式执行的。
        serial queue只会开一个线程
        concurrent queue会开多个线程(系统自己决定)
 
 #### 2> 队列的创建
 
队列的命名规范: 推荐使用app identifier这种逆序全程序域名的方式
 
    // 生成并行队列
    dispatch_queue_t myConcurrentQueue = dispatch_queue_create("com.sun.ucarshare.gcdCreateExample.concurrent", DISPATCH_QUEUE_CONCURRENT);

    // 生成串行队列
    dispatch_queue_t mySerialQueue = dispatch_queue_create("com.sun.ucarshare.gcdCreateExample.serial", NULL);
 
#### 3> 获取系统标准提供的队列
 
Q1: 系统提供的队列有哪些？

A1: 

a> main dispatch queue 在主线程中执行的队列。主线程只有一个, main dispatch queue当然是串行队列serial queue；
       
b> global dispatch queue, 有四个优先级
 
                a. 高优先级 high priority
                b. 默认优先级 default priority
                c. 低优先级 low priority
                d. 后台优先级 background priority
 
Q2: 具体怎么获取各个系统队列

A2: 

a> main dispatch queue
 
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
 
b> global dispatch queue
 
    dispatch_queue_t globalQueueHigh = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_queue_t globalQueueDefault = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t globalQueueLow = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_queue_t globalQueueBackground = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
 
#### 4> 变更队列的执行优先级
 
使用 dispatch_queue_create 函数生成的队列，和默认优先级的全局队列优先级相同。

使用 dispatch_set_target_queue 变更队列的优先级
 
    dispatch_queue_t globalQueueBackground = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);

    dispatch_queue_t myConcurrentQueue = dispatch_queue_create("com.sun.ucarshare.gcdCreateExample.concurrent", DISPATCH_QUEUE_CONCURRENT);

    // 要变更优先级的queue为第一个参数、目标优先级的queue为第二个参数
    dispatch_set_target_queue(myConcurrentQueue, globalQueueBackground);
 
 
### 3. dispatch_after 指定时间后执行处理
 
    // 参数1: 指定时间，dispatch_time_t类型，使用dispatch_time或者dispatch_walltime函数生成。在指定时间追加处理到queue(并不是指定时间后执行处理)，和在指定时间后使用dispatch_async函数追加block到queue相同
    // 参数2: 指定要追加处理的queue
    // 参数3: 指定记述要执行处理的block
     dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3ull * NSEC_PER_SEC);
     dispatch_after(time, dispatch_get_main_queue(), ^{
         NSLog(@"3秒之后");
     });
 
### 4. Dispatch Groupe
 
#### 1> Dispatch Group是专门来监视多个异步任务。
 
#### 2> 当Group里的所有事件都完成，有两种方式发送通知
 
+ dispatch_group_wait 会阻塞当前进程，等所有任务都完成或等待超时
 
         dispatch_queue_t myQueue = dispatch_queue_create("com.sun.test", DISPATCH_QUEUE_CONCURRENT);
         dispatch_group_t myGroup = dispatch_group_create();
 
         dispatch_group_async(myGroup, myQueue, ^{
            NSLog(@"哈哈 1");
         });
 
         dispatch_group_async(myGroup, myQueue, ^{
            NSLog(@"哈哈 2");
         });
 
         dispatch_group_wait(myGroup, DISPATCH_TIME_FOREVER);
 
         NSLog(@"the end");
 
        // 控制台打印
         2018-10-29 15:28:41.438106+0800 UcarShare[1659:334852] 哈哈 1
         2018-10-29 15:28:41.438150+0800 UcarShare[1659:334850] 哈哈 2
         2018-10-29 15:28:41.438226+0800 UcarShare[1659:334783] the end
 
+ dispatch_group_notify 异步执行闭包，不会阻塞。
 
         dispatch_queue_t myQueue = dispatch_queue_create("com.sun.test", DISPATCH_QUEUE_CONCURRENT);
         dispatch_group_t myGroup = dispatch_group_create();
 
         dispatch_group_async(myGroup, myQueue, ^{
            NSLog(@"哈哈 1");
         });
 
         dispatch_group_async(myGroup, myQueue, ^{
            NSLog(@"哈哈 2");
         });
 
         dispatch_group_notify(myGroup, dispatch_get_main_queue(), ^{
            NSLog(@"the end noti");
         });
 
         NSLog(@"the end");
 
        // 控制台打印
         2018-10-29 15:30:09.434812+0800 UcarShare[1673:335295] the end
         2018-10-29 15:30:09.434866+0800 UcarShare[1673:335386] 哈哈 2
         2018-10-29 15:30:09.434836+0800 UcarShare[1673:335380] 哈哈 1
         2018-10-29 15:30:09.459527+0800 UcarShare[1673:335295] the end noti
 
+ 注意项
 
    + dispatch_group_async 等价于 dispatch_group_enter()和dispatch_group_leave()的组合
    + dispatch_group_enter()和dispatch_group_leave()必须成对出现，且dispatch_group_enter()在dispatch_group_leave()之前
 
### 5. dispatch_barrier_async
 
配合dispatch_queue_create函数生成的concurrent queue队列使用。

dispatch_barrier_async 会等待追加到并行队列上的处理全部结束后，再将指定的处理追加到该并行队列。然后在diapatch_barrier_async函数追加的处理执行完毕后，后续追加到并行队列的其他处理才会并行执行。
 
eg: 操作文件/数据库的时候，读取操作可以多个并行执行。而写入处理不能能够与其他写入处理，以及包含读取处理的其他某些处理并行执行。
 
    dispatch_queue_t myConcurrentQueue = dispatch_queue_create("com.sun.test.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
 
    dispatch_async(myConcurrentQueue, ^{  // 事件1
        NSLog(@"读文件/数据库 --- 1");
     });
    dispatch_async(myConcurrentQueue, ^{   // 事件2
        NSLog(@"读文件/数据库 --- 2");
     });
    dispatch_barrier_sync(myConcurrentQueue, ^{    // 事件5
        NSLog(@"写操作!!!");
     });
    dispatch_async(myConcurrentQueue, ^{   // 事件3
        NSLog(@"读文件/数据库 --- 3");
     });
    dispatch_async(myConcurrentQueue, ^{   // 事件4
        NSLog(@"读文件/数据库 --- 4");
     });
 
    如果不加'事件5'，则事件1、2、3、4并发执行，顺序不一定。
    加了'事件5'，事件1、2一定比事件3、4先执行完。可能的一个执行路径是 (2,1),5,(4,3)
 
### 6. dispatch_sync dispatch_async
 
#### 1> dispatch_sync 同步追加处理到指定的队列中，在追加block结束之前，dispatch_sync函数会一直等待。
 
eg: 同步追加一个处理到serial queue会导致死锁。
 
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    NSLog(@"test 1");
    dispatch_sync(mainQueue, ^{
        NSLog(@"add sync block to main queue");
    });
    // 只会打印出 test 1，死锁崩溃
 
#### 2> dispatch_async 异步追加处理到指定队列中
 
### 7. dispatch_apply
 
按指定的次数将指定的block追加到指定的queue中，并等待全部处理执行结束。
 
    dispatch_queue_t globalQueueDefault = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(5, globalQueueDefault, ^(size_t index) {
        NSLog(@"[index]: %zu",index);
     });
    NSLog(@"the end");
    // 打印结果。因为是追加到global queue ，所以block内处理的执行顺序不确定。但是 the end 一定是最后执行，因为dispatch_apply是等待全部处理结束才会继续执行。
     2018-10-29 19:13:10.740109+0800 UcarShare[24905:690187] [index]: 1
     2018-10-29 19:13:10.740065+0800 UcarShare[24905:689676] [index]: 0
     2018-10-29 19:13:10.740133+0800 UcarShare[24905:690194] [index]: 2
     2018-10-29 19:13:10.740146+0800 UcarShare[24905:690188] [index]: 3
     2018-10-29 19:13:10.740258+0800 UcarShare[24905:690187] [index]: 4
     2018-10-29 19:13:10.740931+0800 UcarShare[24905:689676] the end
 
### 8. dispatch_suspend & dispatch_resume
 
    dispatch_suspend 挂起指定队列，队列中已经指定的处理不受影响，尚未执行的处理停止执行。
    dispatch_resume 使得刚才挂起队列中尚未执行的处理继续执行。
 
### 9. Dispatch Semaphore
    
dispatch semaphore 是持有计数的信号，该计数是多线程编程中的计数类型信号。计数为0时等待，计数为1或大于1时，减去1而不等待。

eg: SDWebImage 通过信号量加锁，安全的访问url黑名单 


    // 宏定义
    #define LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    #define UNLOCK(lock) dispatch_semaphore_signal(lock);

    // 创建信号量
    dispatch_semaphore_t failedURLsLock = dispatch_semaphore_create(1);

    LOCK(self.failedURLsLock);
    isFailedUrl = [self.failedURLs containsObject:url]; // 返回黑名单是否已经包含此url
    UNLOCK(self.failedURLsLock);
 
dispatch_semaphore_signal 函数给计数加1；

dispatch_semaphore_wait 函数，一直等待，直到semaphore计数值大于等于1；

### 10. dispatch_once

    @interface User : NSObject
    + (instancetype)sharedUser;
    @end

    @implementation User 
    + (instancetype)sharedUser {
        static User *user  = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            user = [[User alloc] init];
        });
        return user;
    } 
    @end
 
