## SDWebImage 类图

1. 分类

    // MAC OS平台
    NSButton+WebCache 
    NSImage+WebCache

    UIView+WebCache

    UIButton+WebCache
    UIImageView+HighlightedWebCache
    UIImageView+WebCache 

    NSData+ImageContentType
    UIImage+GIF
    UIImage+ForceDecode
    UIImage+MultiFormat
    UIView+WebCacheOperation
 
2. 核心类

    SDWebImageManager

    SDWebImageDownloader 
    SDWebImageDownloaderOperation
    
    SDImageCache
    SDImageCacheConfig
      
    SDWebImageCoder
    SDWebImageCoderHelper
    SDWebImageCodersManager
    SDWebImageCompat
    SDWebImageGIFCoder
    SDWebImageImageIOCoder

3. protocol

    SDWebImageOperation

4. 其他

    SDAnimatedImageRep 
    SDWebImageFrame
    SDWebImageTransition
    SDWebImagePrefetcher


## SDWebImage核心方法
 
 1. 调用 `UIImageView+WebCache` 中 `sd_setImageWithURL:placeholderImage:`方法

        // 最全的一个方法

        /** 
        * @param url            图片地址链接.
        * @param placeholder    占位图.
        * @param options        下载策略
        * @param progressBlock  进度回调block。在一个优先级为 background 的队列里执行
        * @param completedBlock 图片下载完成回调block。
                                有四个参数：图片image；
                                          图片下载错误信息error；
                                          缓存枚举cacheType(SDImageCacheTypeNone无缓存、SDImageCacheTypeDisk磁盘缓存、SDImageCacheTypeMemory内存缓存)；
                                          图片链接imageURL； 
        */
        - (void)sd_setImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                           options:(SDWebImageOptions)options
                          progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                         completed:(nullable SDExternalCompletionBlock)completedBlock;
 
 2. 走到 `UIView+WebCache` 中的 `sd_internalSetImageWithURL: placeholderImage: options: operationKey: setImageBlock: progress: completed:
 context:` 方法


        取消当前图片下载

        利用runtime把url绑定到`sd_imageURL`属性上

        if (options策略不是延迟展示占位图) {
            主线程设置占位图
        }

        if (url校验是否为空) {

            if (是否显示菊花loading) {
                显示菊花loading
            }

            调用 `SDWebImageManager`单例类的`-loadImageWithURL: options: progress: completed:`方法 (查看step3) 。这个方法返回一个 SDWebImageCombinedOperation 实例operation (遵循SDWebImageOperation协议，协议里有个`cancle`方法，用于取消下载) {

                completed:里走成功回调
            }
 
            保存这个 operation 到一个 NSMapTable  

        } else { // url校验不通过
            走 completedBlock 回调。抛出错误: 'Trying to load a nil url'
        }



    `SDWebImageCombinedOperation` 类

        // todo
        @interface SDWebImageCombinedOperation : NSObject <SDWebImageOperation>

        @property (assign, nonatomic, getter = isCancelled) BOOL cancelled;
        @property (strong, nonatomic, nullable) SDWebImageDownloadToken *downloadToken;
        @property (strong, nonatomic, nullable) NSOperation *cacheOperation;
        @property (weak, nonatomic, nullable) SDWebImageManager *manager;

        @end

3. `SDWebImageManager`单例

    1. SDWebImageManager 单例

        创建的时候回会绑定两个属性 
            
        + `imageCache` (`SDImageCache`类型)，单例，负责缓存; 
        + `imageDownloader` (`SDWebImageDownloader`类型)，单例，负责下载图片；

    2. 类的`-loadImageWithURL: options: progress: completed:`方法
        
            校验url是否是NSURL类型，如果是一个NSString类型，则尝试转换

            创建一个 SDWebImageCombinedOperation 实例operation ，最后把它return给方法调用者

            if ( 信号量semaphore加锁。查看 self.failedURLs(下载失败的集合 - 黑名单) 中是否包含此 url ) {

                if (黑名单包含url && 下载策略不是SDWebImageRetryFailed ) {  
                    调用 completionBlock 回调
                    return operation;
                } 
            }

            信号量semaphore加锁，将operation加到【当前正在执行任务数组】中

            得到url对应的缓存key

            调用 self.imageCache 的 `- queryCacheOperationForKey: options: done:` 方法(具体见step4)，返回值是一个 NSOperation {
                
                // 走doneBlock回调，此回调有三个参数 
                //              cachedImage 缓存的image；
                //              cachedData 缓存的image二进制数据；
                //              cacheType 缓存类型，三种(无、硬盘、磁盘)

                if (先判断此operation是否被取消了) {
                    return; // operation 取消了
                }

                if (检查是否需要下载图片) { 
                    // (不是 SDWebImageFromCacheOnly) 
                    && (没缓存 || SDWebImageRefreshCached) 
                    && (实现 SDWebImageManagerDelegate 协议的 imageManager:shouldDownloadImageForURL: 方法(只从url下载，不拿缓存))

                    if (有缓存 && 需要刷新图片) {
                        a>. 调用 [self callCompletionBlockForOperation: completion: image: data: error: cacheType: finished: url:]
                    }

                    调用 self.imageDownloader 的 `- downloadImageWithURL: options: progress: completed:` 方法(见step5) 。返回一个令牌类`SDWebImageDownloadToken`，这个令牌和每个下载相关，可以用来取消下载， {
                        // 走 completed 回调

                        if (判断operation是否取消了) {
                            // 如果取消了，啥也不做 See #699 for more details
                        } else if (下载出错了error) {

                            a>. 调用 [self callCompletionBlockForOperation: completion: image: data: error: cacheType: finished: url:]

                            检查是否需要将url加入黑名单。需要的话就加入self.failedURLsLock (此处用信号量)

                        } else {
                            // 没取消 && 没出错

                            if (检查策略是不是 SDWebImageRetryFailed) {
                                是的话将url从黑名单移除
                            }

                            将下载好的图片data写入缓存 `[self.imageCache storeImage:]`

                            a>. 调用 [self callCompletionBlockForOperation: completion: image: data: error: cacheType: finished: url:]
                        }

                        if (下载完成finished) {
                            b>. 将此次operation从【当前正在执行任务数组】移除
                        } 
                    }

                } else if (cachedImage 有缓存图片) {
                    a>. 调用 [self callCompletionBlockForOperation: completion: image: data: error: cacheType: finished: url:]；
                    b>. 将此次operation从【当前正在执行任务数组】移除；
                } else {
                    // 没缓存图片 && 下载策略不让从url下载
                    a>. 调用 [self callCompletionBlockForOperation: completion: image: data: error: cacheType: finished: url:]；参数 -> (图片nil 二进制数据nil 错误nil 缓存类型none 完成YES 图片链接url)；
                    b>. 将此次operation从【当前正在执行任务数组】移除；
                }
                
            }

4. 调用 `self.imageCache` (`SDImageCache`单例) 的 `- queryCacheOperationForKey: options: done:` 方法

        if (!key) {
            return nil;
        }

        // 先从内存缓存查 
        if (从内存中找到image) {
            走 doneBlock
            return nil;
        }

        创建一个operation
        创建一个disk查找的block
            if (从硬盘找到image) {
                将image写入memory内存缓存
            }

        // 默认 memory内存查找是sync同步 disk硬盘查找是async异步
        if (下载策略SDImageCacheQueryDiskSync 要求disk查找是同步) {
            // sync从硬盘缓存查 
        } else {
            // async从硬盘缓存查 
        }

        return operation
        
5. 调用 `self.imageDownloader` (`SDWebImageDownloader`单例) 的 `- downloadImageWithURL: options: progress: completed:`  

        // 这个方法是创建一个 SDWebImageDownloaderOperation 操作
        调用 [self addProgressCallback: completedBlock: forURL: createCallback:] ，返回一个 SDWebImageDownloadToken 令牌 {

            // 在 createCallback 里面
            设置超时时间 ，默认15s
        }
        