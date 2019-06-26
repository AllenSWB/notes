# 实现一个全屏返回手势

## 原理
 
>+ [FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture)
>+ [利用runtime自定义pop动画](https://www.jianshu.com/p/d39f7d22db6c)

1. 获取系统侧滑返回手势的 `target` 和 `action`
2. 利用第一步获取到的值，再自己创建一个`pan`手势

## 准备

系统的侧滑返回手势是`UINavigationController`的`interactivePopGestureRecognizer`。这是一个`readonly`属性，`po` 查看下它的真面目，结果如下：


    <UIScreenEdgePanGestureRecognizer: 0x103b19b00; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x103b14330>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x103b177f0>)>>

可以看到这个属性是`UIScreenEdgePanGestureRecognizer`类型的，继承自`UIGestureRecognizer`。

在`target`项里，可以看到这个手势的的`target`是一个`_UINavigationInteractiveTransition`实例；`action`是`handleNavigationTransition:`

打印`UIGestureRecognizer`的实例变量

    unsigned int count = 0;
    Ivar *var = class_copyIvarList([UIGestureRecognizer class], &count);
    for (int i = 0; i < count; i++) {
        Ivar _v = *(var + i);
        NSLog(@"[name -> %s], [类型 -> %s] \n", ivar_getName(_v), ivar_getTypeEncoding(_v));
    }

    // 打印结果 
    [name -> _targets], [类型 -> @"NSMutableArray"] 

可以看到有个`_targets`实例，类型是`NSMutableArray`，再来看下它里面有什么

    NSMutableArray *targets = [self.navigationController.interactivePopGestureRecognizer valueForKey:@"_targets"];
    NSLog(@"%@",targets.firstObject);
    NSLog(@"%@",[targets.firstObject className]);

    // 打印结果
    2018-11-21 18:16:21.072445+0800 UcarShareDemo[8673:2140105] (action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x10111bfc0>)
    2018-11-21 18:16:21.074751+0800 UcarShareDemo[8673:2140105] UIGestureRecognizerTarget

`UIGestureRecognizerTarget`这个类里面存储了`UIGestureRecognizer`所需的`target-action`

## 代码实现

    + (void)load {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class class = [self class];
            
            SEL originalSEL = @selector(pushViewController:animated:);
            SEL usSEL = @selector(us_pushViewController:animated:);
            
            Method originalMethod = class_getInstanceMethod(class, originalSEL);
            Method usMethod = class_getInstanceMethod(class, usSEL);
            
            BOOL success = class_addMethod(class, usSEL, method_getImplementation(usMethod), method_getTypeEncoding(originalMethod));
            if (success) {
                class_replaceMethod(class, usSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, usMethod);
            }
        });
    }

    - (void)us_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
        if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.us_fullScreenPopGestureRecognizer]) {
            // 添加自己创建的手势到view上
            [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.us_fullScreenPopGestureRecognizer];
            
            // 给自己创建的手势设置`target-action`
            NSArray *targets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
            id obj = targets.firstObject;
            id internalTarget = [obj valueForKey:@"target"];
            SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
            [self.us_fullScreenPopGestureRecognizer addTarget:internalTarget action:internalAction];
            
            // 设置手势代理
    //        self.us_fullScreenPopGestureRecognizer.delegate = self.us_fullscreenPopGestureRecognizerDelegate;
            
            // 禁止系统的侧滑手势
            self.interactivePopGestureRecognizer.enabled = NO;
        }
        
        if (![self.viewControllers containsObject:viewController]) {
            [self us_pushViewController:viewController animated:YES];
        }
    }

## `load`方法的调用时机

1. 调用时机

当`Objective-C`运行时初始化的时候，会通过 `dyld_register_image_state_change_handler` 在每次有新的镜像加入运行时的时候，进行回调。执行 `load_images` 将所有包含 `load` 方法的文件加入列表 `loadable_classes` ，然后从这个列表中找到对应的 `load` 方法的实现，调用 `load` 方法。

比`main`函数先调用

2. 调用顺序

+ 父类先于子类调用
+ 类先于category调用