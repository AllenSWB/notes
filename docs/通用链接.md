## 通用链接能做什么？

用户在手机上点开一个链接，打开网站。如果手机上已经安装应用，可以直接跳转到应用，而不用经过Safari。如果没安装应用，打开Safari。

常见一个使用场景是：分享一个链接到微信，点击链接，直接从微信跳到我们自己的app。

## 怎么让应用支持通用链接? 

1. 前提条件

    要分享出去的链接要支持HTTPS

2. 把一个名字是 'apple-app-site-association' 的文件放到服务器某个路径下 

    文件内容如下：


    ![Apple 官方文档示例](http://upload-images.jianshu.io/upload_images/1487139-c85d9866d45e44f6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

    appID ： Team ID + Bundle Identifier


    ![Team ID 查看](http://upload-images.jianshu.io/upload_images/1487139-d8b13582cd3d4e45.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

    paths ： 域名路径

     例如 :
     ["/doc/*"]   // 点击 https://www.domain.com/doc就可以跳转app 


    ⚠️ 文件 'apple-app-site-association' 没有后缀。

    [IIS](https://baike.baidu.com/item/iis/99720?fr=aladdin)默认不支持无后缀文件，所以需要修改IIS配置使其支持文件没有后缀。

    找到[IIS](https://baike.baidu.com/item/iis/99720?fr=aladdin)配置中[MIME](https://baike.baidu.com/item/MIME/2900607?fr=aladdin)那一项，添加

   |后缀|MIME类型|
   |:--:|:--:|
   |.|application/octet-stream| 


3. 开启 Associated Domains。

    打开Xcode ，Capabilities -> Associated Domains


    ![屏幕快照 2017-09-12 16.33.28.png](http://upload-images.jianshu.io/upload_images/1487139-35a0255273cfc80d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

    打开开关，添加域名。 ⚠️ 域名格式，'applinks:' 开头。

    ![添加域名](http://upload-images.jianshu.io/upload_images/1487139-4cd7afbbd69c0136.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

    这时候左侧可能会出现一个 .entitlements 文件

    ![屏幕快照 2017-09-12 16.28.48.png](http://upload-images.jianshu.io/upload_images/1487139-0bdc6dee80f67d39.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

    此时打开开发者网站，Certificates, Identifiers & Profiles -> Identifiers -> App IDs 找到对应的app ID ，会发现  Associated Domains 已经支持了


    ![屏幕快照_2017-09-12_16_36_29.png](http://upload-images.jianshu.io/upload_images/1487139-2bc1d03bd2d1112e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


4. 处理通用链接。

    指定域名之后，就可以在AppDelegate中添加方法，处理从通用链接跳转过来的事件

    
         - (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
          
              if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
                  NSURL *webpageURL = userActivity.webpageURL;
                  NSString *host = webpageURL.host;
              }
          
              return YES;
        }

## 相关链接

[官方开发文档](https://developer.apple.com/library/content/documentation/General/Conceptual/AppSearch/UniversalLinks.html#//apple_ref/doc/uid/TP40016308-CH12-SW1)

[API验证工具](https://search.developer.apple.com/appsearch-validation-tool/)

[stackoverflow 相关问题](https://stackoverflow.com/questions/32751225/ios9-universal-links-does-not-work)

[iOS 通用链接（UniversalLinks）+ 分享功能的一些看法](http://www.cocoachina.com/ios/20170818/20290.html)