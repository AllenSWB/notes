- [介绍](#%E4%BB%8B%E7%BB%8D)
- [实现一个栈的结构](#%E5%AE%9E%E7%8E%B0%E4%B8%80%E4%B8%AA%E6%A0%88%E7%9A%84%E7%BB%93%E6%9E%84)
  - [顺序栈 - 用数组](#%E9%A1%BA%E5%BA%8F%E6%A0%88---%E7%94%A8%E6%95%B0%E7%BB%84)
  - [链式栈 - 用链表](#%E9%93%BE%E5%BC%8F%E6%A0%88---%E7%94%A8%E9%93%BE%E8%A1%A8)
- [栈的应用](#%E6%A0%88%E7%9A%84%E5%BA%94%E7%94%A8)
  - [例子一：表达式求值](#%E4%BE%8B%E5%AD%90%E4%B8%80%E8%A1%A8%E8%BE%BE%E5%BC%8F%E6%B1%82%E5%80%BC)
  - [例子二：导航栏的push和pop](#%E4%BE%8B%E5%AD%90%E4%BA%8C%E5%AF%BC%E8%88%AA%E6%A0%8F%E7%9A%84push%E5%92%8Cpop)
  
## 介绍

![](https://diycode.b0.upaiyun.com/photo/2018/96b3ad3bce0f7a21ca229b78e490a9e7.gif)

这是一个栈的gif图

可以看出栈是一种**LIFO**(last in first off 后进先出)的**线性**结构。

只能从栈顶插入或者移除元素

与之配套的，是一些特定的方法

+ push: 在最顶层加入数据
+ pop: 返回并移除最顶层的数据
+ top: 返回最顶层数据的值，但不移除它
+ isempty: 返回一个bool值，表示当前stack是否为空

刚才说了，栈只能在栈顶操作，有一定的限制性。

而从功能上来说，链表或者数组是可以替代栈的。那么栈的存在肯定也是有它的意义的，它存在的意义就是针对下面的特定场景：
    
+ 当某个数据集合只涉及在一端插入和删除数据，并且满足后进先出、先进后出的特性，我们就应该 首选“栈”这种数据结构

## 实现一个栈的结构 

栈主要的两个操作就是‘出栈pop’和‘入栈push’。下面我们就来用代码实现一个栈结构，包含这两个主要操作。

+ 用数组实现的栈叫做顺序栈
+ 用链表实现的栈叫做链式栈

### 顺序栈 - 用数组


    @interface ArrayStack : NSObject

    @property (nonatomic, assign) NSInteger count;
    @property (nonatomic, assign) NSInteger size;
    @property (nonatomic, strong) NSMutableArray *items;

    @end

    @implementation ArrayStack

    - (instancetype)initWithSize:(NSInteger)size {
        self = [super init];
        if (self) {
            self.size = size;
            self.count = 0;
            self.items = [NSMutableArray arrayWithCapacity:size];
        }
        return self;
    }

    /// 入栈
    - (BOOL)push:(id)item {
        if (!item) {
            return NO;
        }
        if (self.count >= self.size) {
            return NO;//空间不够用了，入栈失败
        }
        [self.items addObject:item];
        self.count += 1;
        return YES;
    }

    /// 出栈
    - (id)pop {
        if (self.count == 0) {
            return nil;//已经是空栈了。
        }
        id tempItem = self.items.lastObject;
        [self.items removeObject:tempItem];
        self.count -= 1;
        return tempItem;
    }

    @end

测试

    ArrayStack *stack = [[ArrayStack alloc] initWithSize:2];
    BOOL isSuccess00 = [stack push:@"liu"];   // yes
    BOOL isSuccess11 = [stack push:@"mei"];   // yes
    BOOL isSuccess22 = [stack push:@"zong"];  // no
    
    id obj00 = [stack pop]; // "mei"
    id obj11 = [stack pop]; // "liu"
    id obj22 = [stack pop]; // nil

上面的例子是一个固定大小的顺序栈。那如果我需要能够自动扩容的顺序栈，需要怎么做？

解决方法就是，当数组空间不够时，我们就申请一个更大的内存，将原来数组中的数据都copy过去，这样就实现了一个动态扩容的顺序栈了。

![](http://ww1.sinaimg.cn/large/006hznE2ly1fybw1mrl2rj30s50kftik.jpg)

### 链式栈 - 用链表

链表节点

    @interface Node : NSObject

    @property (nonatomic, assign) id value;
    @property (nonatomic, strong) Node *next;

    @end

    @implementation Node

    - (instancetype)initWithValue:(id)value {
        self = [super init];
        if (self) {
            self.value = value;
        }
        return self;
    }

    @end

用链表实现的栈

    @interface ListStack : NSObject

    @property (nonatomic, strong) Node *top;

    @end

    @implementation ListStack

    - (BOOL)isEmpty {
        return self.top == nil;
    }

    - (BOOL)push:(id)value {
        Node *newTop = [[Node alloc] initWithValue:value];
        newTop.next = self.top;
        self.top = newTop;
        return YES;
    }

    - (id)pop {
        if ([self isEmpty]) {
            return nil;// stack为空
        }
        id value = self.top.value;
        self.top = self.top.next;
        return value;
    }

测试

![](http://ww1.sinaimg.cn/large/006hznE2ly1fyc3j1ngo2j30j90e90vl.jpg)

## 栈的应用

### 例子一：表达式求值

例如：3 + 5 * 8 - 6

我们来计算的话，一眼就能看出先乘法，再加减。最后结果是37

计算机则是通过两个栈来实现这个计算过程的。一个保存操作数的栈，一个保存运算符的栈。

从左到右的遍历表达式，遇到数字，直接压入操作符的栈。

遇到运算符，就与运算符栈顶元素进行比较。如果比栈顶的元素优先级高，就将当前运算符压入栈。如果比栈顶的优先级低或者相同，从运算符栈中取出栈顶元素，从操作数栈中取出两个元素，进行计算，再把计算的结果压入操作符栈，继续比较。

![](http://ww1.sinaimg.cn/large/006hznE2ly1fybwd6reiqj30qx0jhgtv.jpg)

### 例子二：导航栏的push和pop

iOS里导航栏的push和pop操作的实现就是基于栈的。刚开始栈里只有当前界面一个元素，push一次，就压入栈一个新页面。pop一次，就从栈顶取出一个元素，直到当前栈剩下一个就不能再pop了。

浏览器都有前进和后退功能。则是利用两个栈x和y。我们把新打开的页面压入栈x，点击后退时候，从x栈中取出，压入y栈。点击前进时候，从y栈取出，放入x栈。当x没有新数据了，就不能后退了。当y没有数据了，就不能前进了。

一个小小测试：微博客户端一直push下去，会不会崩溃？



