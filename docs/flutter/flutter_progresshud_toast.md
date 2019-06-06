# Flutter进度条和Toast

```dart
  // 提供loading动画，文本toast
  // 参考 https://github.com/limhGeek/flutter_loading

  /*
    使用方法： 目前loading和toast都是居中的，所以如果二者同时存在会有遮挡。 如果需要的话告诉我再改~

    1. 仅loading
    return WbProgressToast(
      loading: true,
      toastString: null,  // 这一个参数可不写，或者传null，或者传''
      child: Container(color: Colors.white),  // 内容视图
    );

    1. 仅toast
    return WbProgressToast(
      loading: false, // 这一个参数可不写，或者传false，或者传null
      toastString: '我是一个提示啊',  
      child: Container(color: Colors.white),  // 内容视图
    );

  */

  import 'package:flutter/material.dart';
  import './tool_device_info.dart';

  class WbProgressToast extends StatelessWidget {
    final bool loading; // 显示loading hud
    final Widget child; // 需要显示ProgressToast的widget

    final String toastString; // 要toast的文案

    const WbProgressToast({Key key, this.loading, this.child, this.toastString}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      List <Widget> widgetLists = [];
      widgetLists.add(child);
      if (loading) {
        // 添加黑色背景框
        widgetLists.add(Center(
          child: SizedBox(
            width: 90,
            height: 90,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              padding: EdgeInsets.only(top: 14),
              child: Column(
                children: <Widget>[
                  CircularProgressIndicator(
                      strokeWidth: 2.0, 
                      backgroundColor: Colors.grey, 
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  SizedBox(height: 5),
                  Text('正在加载', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ));
      }

      if (toastString != null && toastString.length > 0) {
        // if (this.loading) { // TODO 有loading时，把toast往下挪一点，防止遮挡

        // } else {
          widgetLists.add(Center(
            child: ToastStringWidget(toastString: this.toastString,),
          ));
        // }
      }

      return Stack(children: widgetLists);
    } 

  }

  class ToastStringWidget extends StatelessWidget {
    final String toastString;

    const ToastStringWidget({Key key, this.toastString}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return ConstrainedBox(          
        constraints: BoxConstraints(maxWidth: ucarScreenWidth(context) - 40, maxHeight: double.infinity),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          // constraints: BoxConstraints(maxWidth: ucarScreenWidth() -  90),
          child: Text(
            this.toastString,
            // maxLines: 1,
            style: (TextStyle(
              fontSize: 16,
              color: Colors.white,
            )),
          ),
        ),
      );
    }
    
  }


```