# Flutter中的状态管理

## 使用`setState`方法

  - 使用StatefulWidget时候，一些属性设置成final的 todo

## 使用Bloc

  + [官方文档](https://felangel.github.io/bloc/#/gettingstarted)
  
  + 核心概念

    - Event：Events are the input to a Bloc. They are commonly dispatched in response to user interactions such as button presses or lifecycle events like page loads.
    - State：States are the output of a Bloc and represent a part of your application's state. UI components can be notified of states and redraw portions of themselves based on the current state.

  - 添加依赖
  
    ```yaml
      dependencies:
          flutter:
            sdk: flutter
          flutter_bloc: ^0.19.0
          bloc: ^0.14.4 
    ```
  
  - 使用

    ```dart
      import 'package:flutter/material.dart';
      // 1. 引入头文件
      import 'package:bloc/bloc.dart';
      import 'package:flutter_bloc/flutter_bloc.dart';

      void main() => runApp(MyApp());

      class MyApp extends StatelessWidget {
        @override
        Widget build(BuildContext context) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: MyHomePage(title: 'Flutter Demo Home Page'),
          );
        }
      }


      // 2. 创建Event
      enum MyEvent {
        add,
      }

      // 3. 创建Bloc
      class MyBloc extends Bloc<MyEvent, int> {
        @override
        int get initialState => 0;  // 初始化状态 (本例中状态是个num值传递)

        @override
        Stream<int> mapEventToState(
          MyEvent event,
        ) async* {  // 响应event，修改状态
          if (event == MyEvent.add) {
            print('来了 老弟');
            yield currentState + 1;
          }
        }
      }

      class MyHomePage extends StatelessWidget {
        MyHomePage({Key key, this.title}) : super(key: key);

        final String title;

        final MyBloc _myBloc = MyBloc();

        @override
        Widget build(BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('我是title'),
            ),
            body: BlocProvider(
              builder: (BuildContext context) => MyBloc(),
              child: BlocBuilder( // 4. 用一个BlocBuilder包裹
                bloc: _myBloc,
                builder: (BuildContext context, int state) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('新状态来了 $state'),  // 接受新的state
                        MaterialButton(
                          onPressed: (){
                            _myBloc.dispatch(MyEvent.add);  // 触发bloc，传递event
                          },
                          child: Text('点我'),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  );
                },
              )
            ),
          );
        }

      }
      

    ```

    ![bloc_example](../../src/imgs/flutter/state_manage/bloc_example.GIF)
  
  - VSCode扩展
    
    ![bloc_extension](../../src/imgs/flutter/state_manage/bloc_extension.png)

## 使用Provider

  + [provider](https://github.com/rrousselGit/provider)

## 使用fish-redux

  + [fish-redux](https://github.com/alibaba/fish-redux) 
  
## 参考链接

+ blog by Vadaski
  + [状态管理探索篇——Scoped Model（一）](https://juejin.im/post/5b97fa0d5188255c5546dcf8)
  + [状态管理探索篇——Redux（二）](https://juejin.im/post/5ba26c086fb9a05ce57697da)
  + [状态管理探索篇——BLoC(三)](https://juejin.im/post/5bb6f344f265da0aa664d68a)
  + [状态管理特别篇 —— Provide](https://juejin.im/post/5c6d4b52f265da2dc675b407)
  + [状态管理指南篇——Provider](https://juejin.im/post/5d00a84fe51d455a2f22023f)