# Cocoapods
- [Cocoapods](#Cocoapods)
  - [封装私有库](#%E5%B0%81%E8%A3%85%E7%A7%81%E6%9C%89%E5%BA%93)
  - [索引库位置](#%E7%B4%A2%E5%BC%95%E5%BA%93%E4%BD%8D%E7%BD%AE)
  - [更新索引库](#%E6%9B%B4%E6%96%B0%E7%B4%A2%E5%BC%95%E5%BA%93)

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
