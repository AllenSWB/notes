## 概述

1. `KVO(key value observing)`允许对象监听另一个对象特定属性的改变，并在改变时接收到事件。一般继承自`NSObject`的对象都支持`KVO`

2. `KVO`和`NSNotificationCenter`都是iOS中观察者模式的一种实现，区别如下。
    
    + 在于观察者和被观察者之间，KVO是一对一，NSNotificationCenter是一对多的关系。   
    + `KVO`对被监听对象无侵入性，不需要修改其内部代码即可实现监听。

3. 参考文章
    
    + KVO原理分析及使用进阶 https://www.jianshu.com/p/badf5cac0130
    + iOS底层原理汇 - 探索KVO本质 https://www.jianshu.com/p/b0c5461cc3a8
    + KVOController https://github.com/facebook/KVOController
    + 深入理解 KVC 实现机制 http://www.cnblogs.com/zy1987/p/4616063.html

## 基本使用

分三步

1. 注册观察者。`addObserver: forKeyPath: options: context:`

        第一个参数observer：监听者
        第二个参数keyPath：要监听的属性
        第三个参数options：
            NSKeyValueObservingOptionNew 新值
            NSKeyValueObservingOptionOld 旧值
            NSKeyValueObservingOptionInitial 初始值
            NSKeyValueObservingOptionPrior 在属性发生更改之前和之后收到两次通知，而不是改变之后才收到一次通知
        第四个参数context：传入任意类型的对象，是kvo的一种传值方式
    
    调用此方法后，不会对观察者形成强引用。所以要注意观察者的释放时机，防止出现因观察者被释放导致crash

2. 在观察者中实现回调方法。`observeValueForKeyPath: ofObject: change: context:`

    有多种方式都会触发KVO。

        // 点语法
        weakSelf.car.carName = @"丰田FJ";
        // setter方法
        [weakSelf.car setCarName:@"丰田FJ"];
        // setValue: forKey:
        [weakSelf.car setValue:@"丰田FJ" forKey:@"carName"];
        // setValue: forKeyPath:
        [weakSelf setValue:@"丰田FJ" forKeyPath:@"car.carName"];

3. 移除观察者。`removeObserver: forKeyPath:`

        // 声明一个类 USTestCar

        @interface USTestCar : NSObject
        @property (nonatomic, strong) NSString *carName;
        @end

        @implementation USTestCar
        @end

        // 基本使用  
        // USKVODemoController.m 
        @interface USKVODemoController () 
        @property (nonatomic, strong) USTestCar *car;  
        @end

        @implementation USKVODemoController 
        - (void)viewDidLoad {
            [super viewDidLoad];
            self.title = @"KVO";
            
            self.car = [[USTestCar alloc] init];
            self.car.carName = @"本田CR-V";
            
            // 1. 注册监听者
            [self.car addObserver:self forKeyPath:@"carName" options:(NSKeyValueObservingOptionNew) context:@"我想传啥就传啥 nil也行"];
            
            // 2s之后改变属性carName的值
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.car.carName = @"丰田FJ"; 
            }); 
        }

        // 2. 监听回调方法
        - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
            if ([object isKindOfClass:[USTestCar class]]) {
                USTestCar *obj = (USTestCar *)object;
                NSLog(@"汽车名变化 %@",obj.carName);
            }
        }

        - (void)dealloc {
            // 3. 移除监听者
            [self.car removeObserver:self forKeyPath:@"carName"];
        }

注意事项

1. `addObserver: forKeyPath: options: context:` 和 `removeObserver: forKeyPath:`两个方法必须成对出现。如果不调用移除监听者方法会导致崩溃。因为被监听对象并不会持有监听者。
2. `observeValueForKeyPath: ofObject: change: context:(void *)context` 方法必须实现，否则会导致崩溃

## KVO原理

通过`isa-swizzling`技术实现。

1. 在运行时创建一个原类的子类，有固定格式 `NSKVONotifying_XXX`
2. 将对象的`isa`指针指向新创建的类，重写`NSKVONotifying_XXX`的`-class`方法，返回原类的`Class`

        // 1. 重写UITestCar类的`description`方法

        @implementation USTestCar

        - (NSString *)description {
            
            NSLog(@"obj is %p \n",self);
            
            IMP carNameIMP = class_getMethodImplementation(object_getClass(self), @selector(setCarName:));
            NSLog(@"IMP setCarName is %p \n",carNameIMP);

            Class objClass = [self class];
            NSLog(@"obj class is %@ \n", objClass);
            
            Class objRuntimeClass = object_getClass(self);
            NSLog(@"obj runtime class is %@ \n", objRuntimeClass);

            NSLog(@"obj method list is: \n");
            unsigned int count;
            Method *methodList = class_copyMethodList(objRuntimeClass, &count);
            for (NSInteger i = 0; i < count; i++) {
                Method method = methodList[i];
                NSString *methodName = NSStringFromSelector(method_getName(method));
                NSLog(@"method%ld = %@ \n", (long)i, methodName);
            } 
            NSLog(@"\n"); 
            return @"";
        } 
        @end

        // 2. 在添加监听者前后分别调用`description`方法

        [self.car description]; 

        // 添加监听者
        [self.car addObserver:self forKeyPath:@"carName" options:(NSKeyValueObservingOptionNew) context:@"我想传啥就传啥 nil也行"];

        [self.car description];

        // 3. 打印结果如下

        // 注册监听者之前调用的 description
        obj is 0x281368880
        IMP setCarName is 0x1001cbe3c
        obj class is USTestCar
        obj runtime class is USTestCar
        obj method list is:
        method0 = setCarName:
        method1 = carName
        method2 = .cxx_destruct
        method3 = description

        // 注册监听者之后调用的 description
        obj is 0x281368880
        IMP setCarName is 0x1f5a46340 // setter方法重写
        obj class is USTestCar
        obj runtime class is NSKVONotifying_USTestCar // 生成的子类
        obj method list is:
        method0 = setCarName:
        method1 = class
        method2 = dealloc
        method3 = _isKVOA // KVO自动生成的子类标识



3. 子类重写`setter`方法。在修改值之前调用 `willChangeValueForKey:`；修改值之后调用`didChangeValueForKey`，这两个方法最终都会被调用到`observeValueForKeyPath: ofObject: change: context:`这个回调方法中

        // 可以自己调用`willChangeValueForKey`和`didChangeValueForKey`。即可在不改变属性值的情况下手动触发KVO。

        // 手动触发KVO 这两个方法必须同时调用。
        // [self.car willChangeValueForKey:@"carName"];
        // [self.car didChangeValueForKey:@"carName"];

## KVOController  

`KVOController`提供一种更安全的方式来使用`KVO`。它本质上是对系统的`KVO`进行了封装。

KVOController的基本使用

    - (void)viewDidLoad {
        [super viewDidLoad];
        self.title = @"KVO";
        
        self.car = [[USTestCar alloc] init];
        self.car.carName = @"本田CR-V"; 
        
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.car.carName = @"丰田FJ";
        });
        
        // 使用KVOController更方便简单。支持block回调方式。
        // 使用方式一：
        self.kvoController = [FBKVOController controllerWithObserver:self];
        [self.kvoController observe:self.car keyPath:@"carName" options:(NSKeyValueObservingOptionNew) block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
            if ([object isKindOfClass:[USTestCar class]]) {
                USTestCar *obj = (USTestCar *)object;
                NSLog(@"汽车名变化 %@",obj.carName);
            }
        }];


        // 使用方式二：action回调
        [self.KVOController observe:self.car keyPath:@"carName" options:(NSKeyValueObservingOptionNew) action:@selector(newValueAction:)];

    }

    - (void)newValueAction:(id)obj {
    }

这个库的文件有如下5个：

    // 头文件 
    KVOController.h 

    // category
    NSObject+FBKVOController.h
    NSObject+FBKVOController.m

    // 类
    FBKVOController.h
    FBKVOController.m

分类Category文件

    // 分类里定义了两个属性 KVOController KVOControllerNonRetaining 
    // 调用这两个属性的getter，会以懒加载的方式创建一个FBKVOController实例。

    @interface NSObject (FBKVOController) 

    // 会对observer产生强引用
    @property (nonatomic, strong) FBKVOController *KVOController; 
    
    // 不会对observer产生强引用
    @property (nonatomic, strong) FBKVOController *KVOControllerNonRetaining; 

    @end

FBKVOController文件

    提供了一个FBKVOController类，还有两个私有类 _FBKVOSharedController 和 _FBKVOInfo 

    // FBKVOController 类

    - (void)observe:(nullable id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(FBKVONotificationBlock)block {
    
        // 如果必要参数缺失，直接抛出
        NSAssert(0 != keyPath.length && NULL != block, @"missing required parameters observe:%@ keyPath:%@ block:%p", object, keyPath, block);

        if (nil == object || 0 == keyPath.length || NULL == block) {
            return;
        }

        // 创建一个 _FBKVOInfo 实例
        _FBKVOInfo *info = [[_FBKVOInfo alloc] initWithController:self keyPath:keyPath options:options block:block];

        // KVO
        [self _observe:object info:info];
    }

    ////////////////////////////////////////////////////

    // _FBKVOInfo 类。保存了KVO的所有信息

    @implementation _FBKVOInfo {
    @public
        __weak FBKVOController *_controller;
        NSString *_keyPath;
        NSKeyValueObservingOptions _options;
        SEL _action;
        void *_context;
        FBKVONotificationBlock _block;
        _FBKVOInfoState _state;
    }

    ////////////////////////////////////////////////////

    // _FBKVOSharedController 类。 是一个单例，用于接收和转发KVO通知。

    - (void)observe:(id)object info:(nullable _FBKVOInfo *)info {
        if (nil == info) {
            return;
        }

        // 存储KVO信息到_infos (类型是 NSHashTable<_FBKVOInfo *> *)
        
        pthread_mutex_lock(&_mutex);
        [_infos addObject:info];
        pthread_mutex_unlock(&_mutex);

        // 系统的KVO注册监听者方法
        [object addObserver:self forKeyPath:info->_keyPath options:info->_options context:(void *)info];

        if (info->_state == _FBKVOInfoStateInitial) {
            info->_state = _FBKVOInfoStateObserving;
        } else if (info->_state == _FBKVOInfoStateNotObserving) {
            // 系统KVO移除监听者
            [object removeObserver:self forKeyPath:info->_keyPath context:(void *)info];
        }
    }

    - (void)unobserve:(id)object info:(nullable _FBKVOInfo *)info {
        if (nil == info) {
            return;
        }

        // 移除info
        pthread_mutex_lock(&_mutex);
        [_infos removeObject:info];
        pthread_mutex_unlock(&_mutex);

        // 系统KVO移除监听者
        if (info->_state == _FBKVOInfoStateObserving) {
            [object removeObserver:self forKeyPath:info->_keyPath context:(void *)info];
        }
        info->_state = _FBKVOInfoStateNotObserving;
    }


    // 系统的KVO回调方法
    - (void)observeValueForKeyPath:(nullable NSString *)keyPath
                          ofObject:(nullable id)object
                            change:(nullable NSDictionary<NSString *, id> *)change
                           context:(nullable void *)context {
    NSAssert(context, @"missing context keyPath:%@ object:%@ change:%@", keyPath, object, change);
    _FBKVOInfo *info;

    {   // 取出info
        pthread_mutex_lock(&_mutex);
        info = [_infos member:(__bridge id)context];
        pthread_mutex_unlock(&_mutex);
    }

    if (nil != info) {  
        FBKVOController *controller = info->_controller;
        if (nil != controller) { 
            id observer = controller.observer;
            if (nil != observer) {
                // 回调。block或者action两种方式
                if (info->_block) {
                    NSDictionary<NSString *, id> *changeWithKeyPath = change;
                    if (keyPath) {
                        NSMutableDictionary<NSString *, id> *mChange = [NSMutableDictionary dictionaryWithObject:keyPath forKey:FBKVONotificationKeyPathKey];
                        [mChange addEntriesFromDictionary:change];
                        changeWithKeyPath = [mChange copy];
                }
                info->_block(observer, object, changeWithKeyPath);
            } else if (info->_action) { 
                [observer performSelector:info->_action withObject:change withObject:object];
            } else {
                [observer observeValueForKeyPath:keyPath ofObject:object change:change context:info->_context];
            }
        }
        }
    }
    }
 
## 自己实现一个KVO

    [self.car us_addObserver:self forKeyPath:@selector(carName) options:(NSKeyValueObservingOptionNew) context:nil kvoNotiBlock:^(id observer, NSString *keyPath, id oldValue, id newValue) {
        NSLog(@"新值 %@",newValue);
    }];

    [self.car us_removeObserver:self forKeyPath:@selector(carName)];


## 几个问题

#### Q1: `KVO`会强引用监听者`observer`吗？
 
A1: 不会
 
#### Q2: 为什么通过`KVC`给属性赋值，也会触发`KVO`

A2: `KVC`通过`setValue:forKey:`或`setValue:forKeyPath:`方法赋值步骤如下：

    1. 首先搜索`setKey:`方法
    2. 上面的setter方法没找到，如果类方法accessInstanceVariablesDirectly返回YES。那么按 _key，_isKey，key，iskey的顺序搜索成员名。（NSKeyValueCodingCatogery中实现的类方法，默认实现为返回YES）
    3. 如果没有找到成员变量，调用setValue:forUnderfinedKey:

所以，`KVC`也会调用属性的`setter`方法，也会触发`KVO`


#### Q3: 简述KVO原理

A3: 

    1. runtime时生成一个中间类`NSKVONotifying_XXX`，将原类的isa指针指向中间类
    2. `NSKVONotifying_XXX`重写父类该属性的setter方法。在setter方法会调用`_NSSetIntValueAndNotify`方法、`_NSSetIntValueAndNotify`方法内部调用`willChangeValueForKey` `super setXxx`和`didChangeValueForKey`。`willChangeValueForKey`和`didChangeValueForKey`这两个方法都会走到`observeValueForKeyPath: ofObject: change: context:`回调方法。这个回调方法要在监听者observer里实现。

#### Q4: 可不可以不改变属性值，触发KVO回调方法

A4: 可以。手动调用`willChangeValueForKey:`和`didChangeValueForKey:`。注意，这两个方法必须同时调用。

    [self.car willChangeValueForKey:@"carName"];
    [self.car didChangeValueForKey:@"carName"];

## 其他

1. `isa` http://www.cnblogs.com/treejohn/p/3594157.html

        typedef struct objc_class *Class;

        struct objc_class {
            Class _Nonnull isa; // 指向metaClass
            Class _Nullable super_class; // 父类，如果该类已经是顶层类，此值为NULL
            const char *name;
            long version; // 类的版本信息 默认0
            long info; // 供运行期使用的位标识
            long instance_size; // 该类实例变量的大小
            struct objc_ivar_list *ivars; // 成员变量数组
            struct objc_method_list *methodLists; 
            struct objc_cache *cache; // 缓存最近使用的方法，以提高效率
            struct objc_protocol_list *protocols;
        };

        typedef struct objc_object *id;

        struct objc_object {
            Class _Nonnull isa;
        };

    `Class`是一个`objc_class`类型的指针；`id`是一个`objc_object`类型的指针。他们俩里面都包含`isa`，`isa`是一个`Class`类型的指针。

    每个实例对象(`id`)都有个`isa`指针，指向对象的类。`Class`里面也有`isa`指针，指向`metaClass元类`。元类保存了类方法的列表。当类方法被调用时，会先从本身查找类方法的实现。如果没有，元类会向它的父类查找该方法。*元类也是类，也是对象*，元类也有`isa`指针，元类的`isa`指针指向`root metaClass根元类`。根元类的`isa`指针指向本身，形成一个封闭的内循环。

2. `IMP` 方法的实现
 
3. `NSHashTable`

    `NSHashTable`看上去就像`NSSet`的替代品，对比`NSSet`/`NSMutableSet`，`NSHashTable`有以下的特性：

    + `NSSet`/`NSMutableSet` 拥有所包含对象的strong refrence。
    + `NSHashTable`是`mutable`可变的，没有不可变的类。
    + `NSHashTable`可以拥有成员的`weak refrence`；
    + `NSHashTable`可以在输入的时候`copy`成员。
    + `NSHashTable`可以包含任意的指针，可以使用指针去比较或者`hash`校验。
    + `NSHashTable`在初始化的时候可以传入一个参数`option`，有以下几种选项 

4. `pthread_mutex_t`