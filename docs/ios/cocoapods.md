# Cocoapods
- [Cocoapods](#cocoapods)
  - [封装私有库](#%e5%b0%81%e8%a3%85%e7%a7%81%e6%9c%89%e5%ba%93)
  - [索引库位置](#%e7%b4%a2%e5%bc%95%e5%ba%93%e4%bd%8d%e7%bd%ae)
  - [更新索引库](#%e6%9b%b4%e6%96%b0%e7%b4%a2%e5%bc%95%e5%ba%93)
  - [Podfile](#podfile)

## 封装私有库

  [封装私有库](./how_to_create_private_third_party_repo_cocoapods.md)

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