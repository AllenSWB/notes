//
//  USLayerMaskViewController.m
//  UcarShare
//
//  Created by wenbo.sun on 2018/10/23.
//  Copyright © 2018年 wenbo.sun. All rights reserved.
//

#import "USLayerMaskViewController.h"
#import "USLayerMaskNextController.h"

/*
 一、layer.mask 蒙版
 
 寄宿图: 图层中包含的图
 
 二、CAShapeLayer + UIBezierPath 画一个折线图
 
    CAShapeLayer 优点：
        1. 渲染快速。CAShapeLayer使用了硬件加速，绘制同一图形比Core Graphics快很多
        2. 高效使用内存。一个CAShapeLayer不需要想普通CALayer一样创建一个寄宿图形。所以无论多大，都不会占用太多内存
        3. 不会被边界裁剪掉
        4. 矢量图形，不会像素化
 
 三、实现一个蒙版动画转场效果
 
 */

@interface USLayerMaskViewController () {
    CGFloat _backViewW;
    CGFloat _backViewH;
    
    CGFloat _lineGapH;// 折线图竖向间隙
    CGFloat _lineGapW;// 折线图横向间隙
    CGFloat _lineChartWidth;// 折线图宽度
    CGFloat _lineChartHeight;// 折线图高度
    CGFloat _leftRightMargin;// 折线图左右间距
    CGFloat _topBottomMargin;// 折线图上下间距
}

/**
 折线
 */
@property (nonatomic, strong) CAShapeLayer *brokenLineLayer;

@property (nonatomic, strong) UIView *lineChartBackView;

@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation USLayerMaskViewController

- (void)initConfig {
    _backViewW = WB_ScreenWidth - 20.f * 2;
    _backViewH = 150.f;
    _leftRightMargin = 20;
    _topBottomMargin = 15;
    _lineChartWidth = _backViewW - _leftRightMargin * 2;
    _lineChartHeight = _backViewH - _topBottomMargin * 2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 寄宿图 曲率 CAShapeLayer可以画到界面外 UIView的maskView属性
    
    /**
     *  1. layer.mask
     */
    [self makeAvatarCircle];
    
    /**
     *  2. CAShapeLayer + UIBezierPath 画图
     */
    [self makeCurve]; // 曲线图
    [self makeLineChart]; // 折线图
    
    /**
     *  3. 实现一个蒙版动画
     *  https://www.raywenderlich.com/261-how-to-make-a-uiviewcontroller-transition-animation-like-in-the-ping-app
     *  https://www.jianshu.com/p/38cd35968864
     */
#pragma mark - 实现一个蒙版动画转场效果
    @weakify(self)
    [[self.nextButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        USLayerMaskNextController *vc = [[USLayerMaskNextController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}

- (void)setupViews {
    UIButton *nextButton = [[UIButton alloc] init];
    [nextButton setTitle:@"走你" forState:(UIControlStateNormal)];
    [nextButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    nextButton.backgroundColor = UIColor.cyanColor;
    self.nextButton = nextButton;
    [self.view addSubview:nextButton];
    nextButton.frame = CGRectMake(250, 50, 60, 60);
}

#pragma mark - CAShapeLayer + UIBezierPath

- (void)createPointWithPoint:(CGPoint)point width:(CGFloat)width layer:(CALayer *)layer {
    CALayer *subLayer = [CALayer layer];
    subLayer.frame = CGRectMake(point.x - width / 2, point.y - width / 2, width, width);
    subLayer.backgroundColor = [UIColor redColor].CGColor;
    [layer addSublayer:subLayer];
}

- (void)makeCurve {
    UIView *chartBackView = [[UIView alloc] initWithFrame:CGRectMake(20, 200, _backViewW, _backViewH)];
    chartBackView.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
    [self.view addSubview:chartBackView];
    
    // 起点
    CGPoint startPoint = CGPointMake(5, 5);
    // 终点
    CGPoint endPoint = CGPointMake(_backViewW - 5, 5);
    // 控制点: 决定了它的曲率，曲线的顶点不等于控制点的位置
    CGPoint controlPoint = CGPointMake(_backViewW / 2, _backViewH - 5.f);
    CGPoint controlPoint2 = CGPointMake(_backViewW / 4 * 3, -_backViewH);
    
    [self createPointWithPoint:startPoint width:5.f layer:chartBackView.layer];
    [self createPointWithPoint:endPoint width:5.f layer:chartBackView.layer];
    [self createPointWithPoint:controlPoint width:5.f layer:chartBackView.layer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    //    [path addCurveToPoint:endPoint controlPoint1:controlPoint controlPoint2:controlPoint2];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = UIColor.yellowColor.CGColor;
    shapeLayer.strokeColor = UIColor.blueColor.CGColor;
    shapeLayer.strokeStart = 0.f;
    shapeLayer.strokeEnd = 1.f;
    shapeLayer.lineWidth = 2.f;
    [chartBackView.layer addSublayer:shapeLayer];
    
//    // 椭圆
//    UIBezierPath *path0 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 200, 80, 50)]; // Rect赋值宽高相同则是正圆
//    CAShapeLayer *layer0 = [CAShapeLayer layer];
//    layer0.path = path0.CGPath;
//    [self.view.layer addSublayer:layer0];
//
//    // 切圆角
//    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(100, 200, 20, 89) cornerRadius:5];
//    CAShapeLayer *layer1 = [CAShapeLayer layer];
//    layer1.path = path1.CGPath;
//    [self.view.layer addSublayer:layer1];
//
//    // 矩形
//    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake(100, 200, 80, 50)];
//    CAShapeLayer *layer2 = [CAShapeLayer layer];
//    layer2.path = path2.CGPath;
//    [self.view.layer addSublayer:layer2];
}

- (void)makeLineChart {
    UIView *chartBackView = [[UIView alloc] initWithFrame:CGRectMake(20, 360.f, _backViewW, _backViewH)];
    chartBackView.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
    self.lineChartBackView = chartBackView;
    [self.view addSubview:chartBackView];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"你过来啊" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn setBackgroundColor: [UIColor cyanColor]];
    btn.frame = CGRectMake(100, chartBackView.frame.size.height + chartBackView.frame.origin.y + 30, 80, 60);
    [self.view addSubview:btn];
    @weakify(self)
    [[btn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self _reloadLineChartData];
    }];
    
    // x轴
    [self makeLineChartXline:chartBackView];
    // y轴
    [self makeLineChartYline:chartBackView];

    [self _reloadLineChartData];
}

- (void)_reloadLineChartData {
    NSMutableArray *pointsX = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *pointsY = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < 12; i++) {
        NSInteger xValue = i;
        NSInteger yValue = arc4random() % 6;
        [pointsX addObject:@(xValue)];
        [pointsY addObject:@(yValue)];
//        NSLog(@"第【%ld】个点: (%ld, %ld)", i + 1, (long)xValue, (long)yValue);
    }
    
    [self drawPointsInChartWithPointsX:pointsX pointsY:pointsY];
}

- (void)drawPointsInChartWithPointsX:(NSArray <NSNumber *> *)pointsX pointsY:(NSArray <NSNumber *> *)pointsY {
    if (pointsX.count == 0 || pointsY.count == 0 || (pointsY.count != pointsX.count)) {
        return;
    }
    
    if (self.brokenLineLayer) {
        [self.brokenLineLayer removeFromSuperlayer];
    }
    
    self.brokenLineLayer = [CAShapeLayer layer];
    self.brokenLineLayer.fillColor = UIColor.clearColor.CGColor;
    self.brokenLineLayer.strokeColor = UIColor.yellowColor.CGColor;
    self.brokenLineLayer.lineWidth = 3.f;
    self.brokenLineLayer.lineJoin = kCALineJoinMiter;//线条之前结合点的样子
    self.brokenLineLayer.lineCap = kCALineCapButt;//线条结尾的样子
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < pointsY.count; i++) {
        CGFloat pointX = pointsX[i].floatValue * _lineGapW + _leftRightMargin;
        CGFloat pointY = _topBottomMargin + (_lineChartHeight - pointsY[i].floatValue * _lineGapH);
        CGPoint p = CGPointMake(pointX, pointY);
        if (i == 0) {
            [path moveToPoint:p];
        }
        [path addLineToPoint:p];
    }
    
    self.brokenLineLayer.path = path.CGPath;
    [self.lineChartBackView.layer addSublayer:self.brokenLineLayer];
}

- (void)makeLineChartXline:(UIView *)parentView {
    NSInteger lineCount = 6; // 6条横线
    NSInteger gapCount = 5; // 5个gap
    _lineGapH  = (_backViewH - _topBottomMargin * 2) / gapCount;
    
    for (NSInteger i  = 0; i < lineCount; i++) {
        CAShapeLayer *xLine = [CAShapeLayer layer];
        if (i == (lineCount - 1)) {
            xLine.backgroundColor = UIColor.grayColor.CGColor;
        } else {
            xLine.backgroundColor = [UIColor colorWithHexString:@"cecece"].CGColor;
        }
        xLine.frame = CGRectMake(_leftRightMargin, _topBottomMargin + i * _lineGapH, _lineChartWidth, 0.5);
        [parentView.layer addSublayer:xLine];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%ld",(long)(gapCount - i)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        [parentView addSubview:label];
        if (i == (lineCount - 1)) {
            label.frame = CGRectMake(0, xLine.frame.origin.y - 10.f, _leftRightMargin, 10.f);
        } else {
            label.frame = CGRectMake(0, xLine.frame.origin.y - 10.f / 2, _leftRightMargin, 10.f);
        }
    }
}

- (void)makeLineChartYline:(UIView *)parentView {
    NSInteger lineCount = 12;
    NSInteger gapCount = 11;
    _lineGapW  = (_backViewW - _leftRightMargin * 2) / gapCount;
    for (NSInteger i  = 0; i < lineCount; i++) {
        CAShapeLayer *yLine = [CAShapeLayer layer];
        if (i == 0) {
            yLine.backgroundColor = UIColor.grayColor.CGColor;
        } else {
            yLine.backgroundColor = [UIColor colorWithHexString:@"cecece"].CGColor;
        }
        yLine.frame = CGRectMake(_leftRightMargin + i * _lineGapW, _topBottomMargin , 0.5, _lineChartHeight);
        [parentView.layer addSublayer:yLine];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%ld月",(long)(i + 1)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        [parentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(yLine.frame.origin.x - 7.f);
            make.top.mas_equalTo(yLine.frame.origin.y + yLine.frame.size.height);
            make.height.mas_equalTo(self->_topBottomMargin);
        }];
    }
}

#pragma mark - layer.mask

- (void)makeAvatarCircle {
    UIImageView *imgView = [[UIImageView alloc] init];
    [self.view addSubview:imgView];
    imgView.frame = CGRectMake(100, 30, 100, 100);
    imgView.image = [UIImage imageNamed:@"layermask_a"];
    
    [imgView wb_makeCircleCorner];
}

@end
