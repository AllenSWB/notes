- [关于布局的几个方法](#关于布局的几个方法)
- [参考链接](#参考链接)

## 关于布局的几个方法

1. `layoutSubviews`： 系统在这个方法里根据你设置的约束计算视图的大小和位置。如果没设置约束，可以重写这个方法，直接在方法内设置视图大小和位置
2. `setNeedsLayout` & `layoutIfNeeds`: If you want to force a layout update, call the `setNeedsLayout()` method instead to do so prior to the next drawing update. If you want to update the layout of your views immediately, call the `layoutIfNeeded()` method.

## 参考链接

- [深入剖析Auto Layout，分析iOS各版本新增特性](http://www.starming.com/2015/11/03/deeply-analyse-autolayout/)
- [读 SnapKit 和 Masonry 自动布局框架源码](http://www.starming.com/2018/04/07/read-snapkit-and-masonry-source-code/)