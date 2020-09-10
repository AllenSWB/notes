## 'React/RCTBridgeDelegate.h' file not found
```shell
# 解决：切到 ios 目录 pod install
cd ios/
pod install
```
## 执行命令 /RNProject/node_modules/.bin/react-native run-ios --simulator --no-packager --verbose 时出错 (error code 101)

1. 删掉 node_modules 文件夹
2. 根目录运行 npm install
3. 重启 VSCode