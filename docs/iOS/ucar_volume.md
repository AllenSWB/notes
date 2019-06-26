需求： 全屏播放视频时候，不显示系统的音量框，而是使用自定义的音量条

用到的知识点

+ 隐藏系统音量框
+ NSHashTable
+ UIWindow

---

## 隐藏系统音量框

先来看两个截图

即刻App 

![](http://ww1.sinaimg.cn/large/006hznE2ly1fxvuirhpnaj30ku112gur.jpg)

优酷App 

![](http://ww1.sinaimg.cn/large/006hznE2ly1fxvuktbi1aj31120ku7wh.jpg)

同样是在全屏播放的情况下调节音量。即刻app的音量条在箭头指向的那里，优酷app则是系统的弹窗。明显优酷的挡住了视频，用户体验没有即刻的好。

那如何隐藏系统的音量调节框呢？解决办法就是加上下面两句代码就OK了，把volumeView设置到界面外

    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame: CGRectMake(-100, -100, 10, 10)];
    [self.view addSubview: volumeView];
    
    // MPVolumeView有个属性showsVolumeSlider设置为NO并不能隐藏音量条

既然隐藏了系统的音量调节框，下一步就是自定义我们自己的音量条了。

首先，要监听到系统音量的变化，代码如下。

    // KVO 的方式

    // 1. 添加监听
    [[AVAudioSession sharedInstance] addObserver:self forKeyPath:@"outputVolume" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];

    //2. 监听回调
    - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
        CGFloat volume = [AVAudioSession sharedInstance].outputVolume;
        [self sysVolumeChangeTo:volume];
    }

    //3. 移除监听
    [[AVAudioSession sharedInstance] removeObserver:self forKeyPath:@"outputVolume"];

然后，自定义一个window，把音量条放到这个window上。

显示音量条的时候，window层级为 Status + 1
隐藏音量条的时候，window层级为 Normal

自定义了一个UCARVolume。代码路径是  `SGPlayer-master/demo/demo-ios/demo-ios/UCARVolume`

## NSHashTable

[官方文档地址](https://developer.apple.com/documentation/foundation/nshashtable)

vs NSSet/NSMutableSet

![](http://ww1.sinaimg.cn/large/006hznE2ly1fxx8et2xf5j30kk05mq3j.jpg)

+ NSSet/NSMutableSet 强引用放入其中的元素 ; NSHashTable可以weak-references弱引用元素
+ NSHashTable也可以copy一份值放入其中
+ NSHashTable的成员可以包含指针，不是对象也行
+ NSHashTable是可变的，没有不可变的版本

UCARVolume的例子如下

    //1. UCARVolume单例 持有一个 UCARSysVolumeManager实例
    
    self.sysVolumeManager = [[UCARSysVolumeManager alloc] init];

    [self.sysVolumeManager ucarAddObserver:self];

    //2. UCARSysVolumeManager有个集合属性存放所有的observers
    
    @property (nonatomic, strong) NSHashTable <UCARSysVolumeProtocol>*observers;


## UIWindow

主要是UIWindow的level 可以根据这个来控制window显示的层级 

    UIWindowLevelNormal
    UIWindowLevelAlert
    UIWindowLevelStatusBar // tvOS不可用
