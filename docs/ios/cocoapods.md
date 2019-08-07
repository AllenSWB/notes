# Cocoapods
- [Cocoapods](#cocoapods)
  - [封装私有库](#%e5%b0%81%e8%a3%85%e7%a7%81%e6%9c%89%e5%ba%93)
  - [封装开源库](#%e5%b0%81%e8%a3%85%e5%bc%80%e6%ba%90%e5%ba%93)
  - [索引库位置](#%e7%b4%a2%e5%bc%95%e5%ba%93%e4%bd%8d%e7%bd%ae)
  - [更新索引库](#%e6%9b%b4%e6%96%b0%e7%b4%a2%e5%bc%95%e5%ba%93)
  - [Podfile](#podfile)

## 封装私有库

  [封装私有库](./how_to_create_private_third_party_repo_cocoapods.md)

## 封装开源库

1. 创建 WBNetwork.podspec 
   ```shell
    pod spec create WBNetwork 
   ```
2. 编辑 WBNetwork.podspec 文件, 下面是个示例

    ```ruby
        #  Be sure to run `pod spec lint WBNetwork.podspec' to ensure this is a
        #  valid spec and to remove all comments including this before submitting the spec.

        Pod::Spec.new do |s|

        s.name         = "WBNetwork"
        s.version      = "0.1.3"
        s.summary      = "iOS 基于 AFN 封装的链式网络请求框架" 
        s.homepage     = "https://github.com/AllenSWB/WBNetwork"
        s.license      = "MIT"
        s.author       = "AllenSWB"
        s.platform     = :ios, "8.0"
        s.source       = { :git => "https://github.com/AllenSWB/WBNetwork.git", :tag => "#{s.version}" }
        s.frameworks   = "Foundation",'UIKit'
        s.source_files = "WBNetworkDemo/WBNetwork/*.{h,m}" 
        s.dependency "AFNetworking"

        end
    ```
3. pod lib lint WBNetwork.podspec , 本地验证 .podspec 文件。可以加上参数 --allow-warnings --verbose

      ```shell
        pod lib lint WBNetwork.podspec --vrebose --allow-warnings
      ```
    + --verbose 校验过程会log处详情
    + --allow-warnings 有警告也允许验证通过
4. 把本地更新推送到origin
5. 远端验证文件
    ```shell
      pod spec lint WBNetwork.podspec
    ```
6. 打tag
   ```shell
    git tag 0.1.3
    git push --tags
   ```
7. 注册 trunk 
    ```shell
      pod trunk register 276476869@qq.com 'allenswb'
    ```
8. 查看注册信息
    ```shell
      pod trunk me 
    ```
9.  去邮箱验证 trunk 发过来的邮件
10. 推送库到cocoapods
    ```shell
      pod trunk push --allow-warnings

      pod search WBNetwork # 这时候就能搜索到自己的库了
    ```

## 索引库位置

  1. 远端 https://github.com/CocoaPods/Specs
      
      ![originspecs](../../src/imgs/ios/cocoapods/cocoapods_originspecs.png)

  2. 本地 `~/.cocoapods/repos/master/`
     
      ![localspecs](../../src/imgs/ios/cocoapods/cocoapods_local_specs.png)

## 更新索引库

  + 更新所有索引库
      ```shell
        $ pod repo update
      ```
  + 单独更新某一个索引库
      ```shell
        $ pod repo update wbSpecs 
      ```
  + install时候更新索引库
    > out-of-date source repos which you can update with `pod repo update` or with `pod install --repo-update`.

      ```shell
        $ pod install --repo-update
      ```

## Podfile

> Podfile中的代码是ruby

```ruby

  # 本地导入指明podspec文件路径
  pod 'Whoops', :path => '../'

  # 版本号
  pod 'ZCComponent', '0.1.2' # 指定版本号
  pod 'ZBarSDK', '~> 1.3.1' # 不小于1.3.1版本

  # tag

  # 分支

  # 仅Debug
  pod 'UCARRobot', :configurations => ['Debug']

```