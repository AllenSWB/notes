# Tips in iOS
- [Tips in iOS](#tips-in-ios)
  - [iOS开发随手记](#ios%e5%bc%80%e5%8f%91%e9%9a%8f%e6%89%8b%e8%ae%b0)
  - [多target](#%e5%a4%9atarget)
    - [创建多target方法](#%e5%88%9b%e5%bb%ba%e5%a4%9atarget%e6%96%b9%e6%b3%95)
    - [创建一个新target的注意点：](#%e5%88%9b%e5%bb%ba%e4%b8%80%e4%b8%aa%e6%96%b0target%e7%9a%84%e6%b3%a8%e6%84%8f%e7%82%b9)
    - [多target设置`GCC_PREPROCESSOR_DEFINITIONS`引起的问题](#%e5%a4%9atarget%e8%ae%be%e7%bd%aegccpreprocessordefinitions%e5%bc%95%e8%b5%b7%e7%9a%84%e9%97%ae%e9%a2%98)
  - [加快编译速度](#%e5%8a%a0%e5%bf%ab%e7%bc%96%e8%af%91%e9%80%9f%e5%ba%a6)
  - [安装多个版本的cocoapods](#%e5%ae%89%e8%a3%85%e5%a4%9a%e4%b8%aa%e7%89%88%e6%9c%ac%e7%9a%84cocoapods)
  - [扩大button响应区域](#%e6%89%a9%e5%a4%a7button%e5%93%8d%e5%ba%94%e5%8c%ba%e5%9f%9f)
  - [UILabel文本靠左上角](#uilabel%e6%96%87%e6%9c%ac%e9%9d%a0%e5%b7%a6%e4%b8%8a%e8%a7%92)
  - [UILabel设置行间隙](#uilabel%e8%ae%be%e7%bd%ae%e8%a1%8c%e9%97%b4%e9%9a%99)
  - [去除String中的空格](#%e5%8e%bb%e9%99%a4string%e4%b8%ad%e7%9a%84%e7%a9%ba%e6%a0%bc)
  - [UILabel部分文字可点击](#uilabel%e9%83%a8%e5%88%86%e6%96%87%e5%ad%97%e5%8f%af%e7%82%b9%e5%87%bb)
  - [找到所有subviewClass类](#%e6%89%be%e5%88%b0%e6%89%80%e6%9c%89subviewclass%e7%b1%bb)
  - [找到subviewClass这个类的父视图](#%e6%89%be%e5%88%b0subviewclass%e8%bf%99%e4%b8%aa%e7%b1%bb%e7%9a%84%e7%88%b6%e8%a7%86%e5%9b%be)
  - [iOS13适配](#ios13%e9%80%82%e9%85%8d)
  - [RAC通知的移除](#rac%e9%80%9a%e7%9f%a5%e7%9a%84%e7%a7%bb%e9%99%a4)

## iOS开发随手记 
  
  [iOS开发随手记](https://www.jianshu.com/p/cb80ad438057)
   
## 多target
   
   >  BWCMT项目架构:
   >
   >  - 基础库pod集成（封装好的UI；网络库；三方库等）
   >  - 每个业务线是一个project，最后主工程依赖各个业务线framework，业务线间通信通过平台层platform里的路由完成（不能跨业务线直接调用）
   >
   >  ![bwcmt_struct](../../src/imgs/ios/bwcmt_struct.png)
   >
   >  产生的问题：主工程依赖所有的业务线的framework，但是各个业务线之间不一定有依赖，我开发某一个业务线的时候，如果需要编译整个工程的话，时间会很长。
   >
   >  解决方案是：为一个单独的业务线创建一个target，以节省工程build时间。

### 创建多target方法

  创建target的步骤参考这个链接：[iOS 一套代码多APP／多渠道／多target+自动打包脚本](https://www.jianshu.com/p/73343b4fc42b)

  [创建多target](./add_more_targets_to_your_project.md)
###  创建一个新target的注意点：

  + 依赖
    
    ![more_targets_noti0](../../src/imgs/ios/more_targets_noti0.png)
  + 宏：判断当前run的那个target
  
    ![more_targets_noti1](../../src/imgs/ios/more_targets_noti1.png)
    ![more_targets_noti2](../../src/imgs/ios/more_targets_noti2.png)

    设置`$(inherited)`

    ![more_target_error_pod_solve](../../src/imgs/ios/more_target_error_pod_solve.png)
  + Pods库：新的target也要记得依赖pod库

    ```ruby
      # Podfile 文件
      targetsArray = ['BWCMTApp','BWCMTAppYZFlutter']

      targetsArray.each  do |t|

         target t do
             pod 'YYModel', '~>1.0.4'
             pod 'DoraemonKit/Core', :git => 'http://gitlab.10101111.com:8888/p2p/udoraemonkit.git', :configurations => ['Debug','ZC','Distribution']
         end
      end
    ```

### 多target设置`GCC_PREPROCESSOR_DEFINITIONS`引起的问题
   
   前面说了，为了用代码判断当前run的是那个target，设置了两个宏`BWCMT_FULL`和`BWCMT_YZ_FLUTTER`。这时候使用`pod install`会有下面的提示（pod没有出错，只是会给个警告⚠️）。

  ```shell
    [!] The `BWCMTApp [Release]` target overrides the `GCC_PREPROCESSOR_DEFINITIONS` build setting defined in `Pods/Target Support Files/Pods-BWCMTApp/Pods-BWCMTApp.release.xcconfig'. This can lead to problems with the CocoaPods installation
     - Use the `$(inherited)` flag, or
     - Remove the build settings from the target.
  ```

   ![more_target_error_pod](../../src/imgs/ios/more_target_error_pod.png)

   解决办法是在`GCC_PREPROCESSOR_DEFINITIONS`里加上`$(inherited)`。再次`pod install`警告会消失。

   ![more_target_error_pod_solve](../../src/imgs/ios/more_target_error_pod_solve.png)

## 加快编译速度

从源码到二进制可执行文件整个流程去考虑

1. 修改`Optimization Level`的值

    ![Optimization Level](../../src/imgs/ios/optimization_level.png)

2. `.h`文件引入头文件，`#import`改成`@class`


## 安装多个版本的cocoapods


## 扩大button响应区域

```objc
/// .h

@interface UIButton (EnlargeHitArea)

@property (nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

@end

/// .m

#import "UIButton+EnlargeHitArea.h"
static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";

@implementation UIButton (EnlargeHitArea)

-(void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets]; return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

@end

```

## UILabel文本靠左上角

```objc

// .h
@interface BWLeftTopLabel : UILabel
@end

// .m
@implementation BWLeftTopLabel
- (id)initWithFrame:(CGRect)frame {
    return [super initWithFrame:frame];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    textRect.origin.y = bounds.origin.y;
    return textRect;    
}

-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];   
}
@end

```

## UILabel设置行间隙

```objc
/**
 设置固定行间距文本
 
 @param lineSpace 行间距
 @param text 文本内容
 @param label 要设置的label
 */
-(void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label{
    if (!text || !label) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
}

// 使用
  [self setLineSpace:5 withText:row.descStr inLabel:self.descLabel];

```

## 去除String中的空格

1. 仅去除前后的空格

```objc
    NSString *str  = [NSString stringWithFormat:@"    sda  sda    "];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"%@", str);  // sda  sda
```

2. 去除所有空格

```objc
    NSString *str = [NSString stringWithFormat:@"   你 好 嘛  ， 跟谁 俩 呢 ！  "];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@", str);  // 你好嘛，跟谁俩呢!
```

## UILabel部分文字可点击

```objc
// .h 


@protocol RichTextDelegate <NSObject>
@optional
/**
 *  RichTextDelegate
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 *  @param index   点击的字符在数组中的index
 */
- (void)didClickRichText:(NSString *)string
                   range:(NSRange)range
                   index:(NSInteger)index;
@end

@interface UILabel (RichLabel)


/**
 *  是否打开点击效果，默认是打开
 */
@property (nonatomic, assign) BOOL enabledClickEffect;

/**
 *  点击效果颜色 默认lightGrayColor
 */
@property (nonatomic, strong) UIColor *clickEffectColor;

/**
 *  给文本添加Block点击事件回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param clickAction 点击事件回调
 */
- (void)clickRichTextWithStrings:(NSArray <NSString *> *)strings
                     clickAction:(void (^) (NSString *string, NSRange range, NSInteger index))clickAction;

/**
 *  给文本添加点击事件delegate回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param delegate 富文本代理
 */
- (void)clickRichTextWithStrings:(NSArray <NSString *> *)strings
                        delegate:(id <RichTextDelegate> )delegate;

@end
```

```objc
// .m


//
//  UILabel+RichLabel.m
//  BWApp
//
//  Created by wenbo.sun on 2019/9/7.
//  Copyright © 2019 UCAR. All rights reserved.
//

#import "UILabel+RichLabel.h"

#import <objc/runtime.h>
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>


#define weakSelf(type)      __weak typeof(type) weak##type = type;

@interface RichTextModel : NSObject

@property (nonatomic, copy) NSString *str;

@property (nonatomic, assign) NSRange range;

@end

@implementation RichTextModel

@end


@implementation UILabel (RichLabel)


#pragma mark - AssociatedObjects

- (NSMutableArray *)attributeStrings {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAttributeStrings:(NSMutableArray *)attributeStrings {
    
    objc_setAssociatedObject(self, @selector(attributeStrings), attributeStrings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)effectDic {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEffectDic:(NSMutableDictionary *)effectDic {
    
    objc_setAssociatedObject(self, @selector(effectDic), effectDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isClickAction {
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsClickAction:(BOOL)isClickAction {
    
    objc_setAssociatedObject(self, @selector(isClickAction), @(isClickAction), OBJC_ASSOCIATION_ASSIGN);
}

- (void (^)(NSString *, NSRange, NSInteger))clickBlock {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setClickBlock:(void (^)(NSString *, NSRange, NSInteger))clickBlock {
    
    objc_setAssociatedObject(self, @selector(clickBlock), clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id<RichTextDelegate>)delegate {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (BOOL)enabledClickEffect {
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setEnabledClickEffect:(BOOL)enabledClickEffect {
    
    objc_setAssociatedObject(self, @selector(enabledClickEffect), @(enabledClickEffect), OBJC_ASSOCIATION_ASSIGN);
    //    self.isClickEffect = enabledClickEffect;
}

- (UIColor *)clickEffectColor {
    
    UIColor *obj = objc_getAssociatedObject(self, _cmd);
    if(obj == nil) {obj = [UIColor lightGrayColor];}
    return obj;
}

- (void)setClickEffectColor:(UIColor *)clickEffectColor {
    
    objc_setAssociatedObject(self, @selector(clickEffectColor), clickEffectColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isClickEffect {
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsClickEffect:(BOOL)isClickEffect {
    
    objc_setAssociatedObject(self, @selector(isClickEffect), @(isClickEffect), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setDelegate:(id<RichTextDelegate>)delegate {
    
    objc_setAssociatedObject(self, @selector(delegate), delegate, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - mainFunction
- (void)clickRichTextWithStrings:(NSArray<NSString *> *)strings clickAction:(void (^)(NSString *, NSRange, NSInteger))clickAction {
    
    [self richTextRangesWithStrings:strings];
    
    if (self.clickBlock != clickAction) {
        self.clickBlock = clickAction;
    }
}

- (void)clickRichTextWithStrings:(NSArray<NSString *> *)strings delegate:(id<RichTextDelegate>)delegate {
    
    [self richTextRangesWithStrings:strings];
    
    if ([self delegate] != delegate) {
        
        [self setDelegate:delegate];
    }
}

#pragma mark - touchAction
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isClickAction) {
        return;
    }
    
    if (objc_getAssociatedObject(self, @selector(enabledClickEffect))) {
        self.isClickEffect = self.enabledClickEffect;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    weakSelf(self);
    [self richTextFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        
        if (weakself.clickBlock) {
            weakself.clickBlock (string , range , index);
        }
        
        if ([weakself delegate] && [[weakself delegate] respondsToSelector:@selector(didClickRichText:range:index:)]) {
            [[weakself delegate] didClickRichText:string range:range index:index];
        }
        
        if (weakself.isClickEffect) {
            
            [weakself saveEffectDicWithRange:range];
            
            [weakself clickEffectWithStatus:YES];
        }
    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if((self.isClickAction) && ([self richTextFrameWithTouchPoint:point result:nil])) {
        
        return self;
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark - getClickFrame
- (BOOL)richTextFrameWithTouchPoint:(CGPoint)point result:(void (^) (NSString *string , NSRange range , NSInteger index))resultBlock
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    
    CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    CFRange range = CTFrameGetVisibleStringRange(frame);
    
    if (self.attributedText.length > range.length) {
        
        UIFont *font ;
        
        if ([self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil]) {
            
            font = [self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
            
        }else if (self.font){
            font = self.font;
            
        }else {
            font = [UIFont systemFontOfSize:17];
        }
        
        CGPathRelease(Path);
        
        Path = CGPathCreateMutable();
        
        CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + font.lineHeight));
        
        frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    if (!lines) {
        CFRelease(frame);
        CFRelease(framesetter);
        CGPathRelease(Path);
        return NO;
    }
    
    CFIndex count = CFArrayGetCount(lines);
    
    CGPoint origins[count];
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    CGAffineTransform transform = [self transformForCoreText];
    
    CGFloat verticalOffset = 0;
    
    for (CFIndex i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        rect = CGRectInset(rect, 0, 0);
        
        rect = CGRectOffset(rect, 0, verticalOffset);
        
        NSParagraphStyle *style = [self.attributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil];
        
        CGFloat lineSpace;
        
        if (style) {
            lineSpace = style.lineSpacing;
        }else {
            lineSpace = 0;
        }
        
        CGFloat lineOutSpace = (self.bounds.size.height - lineSpace * (count - 1) -rect.size.height * count) / 2;
        
        rect.origin.y = lineOutSpace + rect.size.height * i + lineSpace * i;
        
        if (CGRectContainsPoint(rect, point)) {
            
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            
            CGFloat offset;
            
            CTLineGetOffsetForStringIndex(line, index, &offset);
            
            if (offset > relativePoint.x) {
                index = index - 1;
            }
            
            NSInteger link_count = self.attributeStrings.count;
            
            for (int j = 0; j < link_count; j++) {
                
                RichTextModel *model = self.attributeStrings[j];
                
                NSRange link_range = model.range;
                if (NSLocationInRange(index, link_range)) {
                    if (resultBlock) {
                        resultBlock (model.str , model.range , (NSInteger)j);
                    }
                    CFRelease(frame);
                    CFRelease(framesetter);
                    CGPathRelease(Path);
                    return YES;
                }
            }
        }
    }
    CFRelease(frame);
    CFRelease(framesetter);
    CGPathRelease(Path);
    return NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isClickEffect) {
        
        [self performSelectorOnMainThread:@selector(clickEffectWithStatus:) withObject:nil waitUntilDone:NO];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isClickEffect) {
        
        [self performSelectorOnMainThread:@selector(clickEffectWithStatus:) withObject:nil waitUntilDone:NO];
    }
}

- (CGAffineTransform)transformForCoreText
{
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}

- (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point
{
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + fabs(descent) + leading;
    
    return CGRectMake(point.x, point.y , width, height);
}

#pragma mark - clickEffect
- (void)clickEffectWithStatus:(BOOL)status
{
    if (self.isClickEffect) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        NSMutableAttributedString *subAtt = [[NSMutableAttributedString alloc] initWithAttributedString:[[self.effectDic allValues] firstObject]];
        
        NSRange range = NSRangeFromString([[self.effectDic allKeys] firstObject]);
        
        if (status) {
            [subAtt addAttribute:NSBackgroundColorAttributeName value:self.clickEffectColor range:NSMakeRange(0, subAtt.string.length)];
            
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        }else {
            
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        }
        self.attributedText = attStr;
    }
}

- (void)saveEffectDicWithRange:(NSRange)range
{
    self.effectDic = [NSMutableDictionary dictionary];
    
    NSAttributedString *subAttribute = [self.attributedText attributedSubstringFromRange:range];
    
    [self.effectDic setObject:subAttribute forKey:NSStringFromRange(range)];
}

#pragma mark - getRange
- (void)richTextRangesWithStrings:(NSArray <NSString *>  *)strings
{
    if (self.attributedText == nil) {
        self.isClickAction = NO;
        return;
    }
    
    self.isClickAction = YES;
    
    self.isClickEffect = YES;
    
    __block  NSString *totalStr = self.attributedText.string;
    
    self.attributeStrings = [NSMutableArray array];
    
    weakSelf(self);
    [strings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSRange range = [totalStr rangeOfString:obj];
        
        if (range.length != 0) {
            
            totalStr = [totalStr stringByReplacingCharactersInRange:range withString:[weakself getStringWithRange:range]];
            
            RichTextModel *model = [[RichTextModel alloc]init];
            
            model.range = range;
            
            model.str = obj;
            
            [weakself.attributeStrings addObject:model];
        }
    }];
}

- (NSString *)getStringWithRange:(NSRange)range
{
    NSMutableString *string = [NSMutableString string];
    
    for (int i = 0; i < range.length ; i++) {
        
        [string appendString:@" "];
    }
    return string;
}


@end
```

```objc
// 使用


- (void)cellWillAppear {
    [super cellWillAppear];
    
    CKBindVehicleTipCellRow *row = (CKBindVehicleTipCellRow *)self.tableViewRow;
    
    self.tiplabel.text = row.tipStr;
    
    NSString *text = row.tipStr;
    
    NSRange phoneRange = [row.tipStr rangeOfString:row.phoneStr];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];

    [string addAttributes:@{NSStrikethroughStyleAttributeName:@"",NSForegroundColorAttributeName:UCAR_ColorFromHexString(@"2D72D9")}  range:phoneRange];
    self.tiplabel.userInteractionEnabled = true;
    self.tiplabel.attributedText = string;

    [self.tiplabel clickRichTextWithStrings:@[row.phoneStr] clickAction:^(NSString *string, NSRange range, NSInteger index) {
        
        NSString *str = [row.phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"电话 ：%@", str);
        
    }];
}
```

## 找到所有subviewClass类
```objc
- (NSMutableArray *)_findSubViews:(UIView *)currentView subViewClass:(NSString *)subviewClass array:(NSMutableArray *)array {
    if (currentView.subviews.count == 0) {
        return array;
    }
    if (!array) {
        array = [NSMutableArray arrayWithCapacity:0];
    } 
    for (NSInteger i = 0; i < currentView.subviews.count; i++) {
        UIView *subb = currentView.subviews[i];
       if ([subb isKindOfClass:NSClassFromString(subviewClass)]) {
           [array addObject:subb];
        }
        
        [self _findSubViews:subb subViewClass:subviewClass array:array];
    }
    return array;
}
```

## 找到subviewClass这个类的父视图
```objc

- (UIView *)_findParentView:(UIView *)currentView subViewClass:(NSString *)subviewClass{
    // 深度优先查找
    for (NSInteger i = 0; i < currentView.subviews.count; i++) {
        UIView *subb = currentView.subviews[i];
       if ([subb isKindOfClass:NSClassFromString(subviewClass)]) {
           return currentView;
           break;
        }
        UIView *n = [self _findParentView:subb subViewClass:subviewClass];
        if (n) {
            return n;
            break;
        }
    }
    return nil;
}
```

## iOS13适配

1. present出来的控制器默认不是全屏

```swift
    let v = WBTestViewController()
    v.modalPresentationStyle = .fullScreen // 加上这句话
    self.present(v, animated: true, completion: nil)
```

2. Dark Mode适配

## RAC通知的移除

```objc
    // https://juejin.im/post/5a30974ef265da433562bec2
    RACSignal *ss = [[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UserSyncVerifyInfoWithServerSuccessNoti" object:nil];
        self.disposableObj = [ss subscribeNext:^(id  _Nullable x) {
            NSLog(@"更新认证信息成功~!!!!!!");
            [vcObjc.view bw_hiddenLoading];

            NSNotification *noti = (NSNotification *)x;
            BOOL syncSuccess = ((NSNumber *)noti.object).boolValue;
            if (syncSuccess) {
                NSLog(@"同步后台成功 - 更新认证信息成功~!!!!!");
            } else {
                NSLog(@"同步后台失败");
            }
            
            [UserRealNameAuthTool _handleToRealNameAuth:params];
            [self.disposableObj dispose];//rac 移除通知监听  
        }];
```