//
//  HJGooView.m
//  QQ提醒
//
//  Created by apple on 15/4/25.
//  Copyright (c) 2015年 七. All rights reserved.
//

#import "HJGooView.h"
#import "HJGooUtil.h"

@interface HJGooView ()
/** 拖拽圆圆心*/
@property (nonatomic ,assign) CGPoint dragCenter;

/**  固定圆圆心*/
@property (nonatomic ,assign) CGPoint stickCenter;

/**  固定圆半径*/
@property (nonatomic ,assign) CGFloat stickRadius;

/**  固定圆第一个点*/
@property (nonatomic ,assign) CGPoint stickPoint1;

/**  固定圆第二个点*/
@property (nonatomic ,assign) CGPoint stickPoint2;

/**  拖拽圆半径*/
@property (nonatomic ,assign) CGFloat dragRadius;

/**  拖拽圆第一个点*/
@property (nonatomic ,assign) CGPoint dragPoint1;

/**  拖拽圆第二个点*/
@property (nonatomic ,assign) CGPoint dragPoint2;

/**  控制点*/
@property (nonatomic ,assign) CGPoint controlPoint;
/** 记录是否是第一次绘制*/
@property (nonatomic, assign) BOOL first;
/** 能够拉伸的最远距离*/
@property (nonatomic, assign) double maxDistance;

/** 记录是否超出拉伸范围*/
@property (nonatomic, assign, getter=isOutOfRange) BOOL outOfRange;
/** 记录是否需要销毁所有绘图*/
@property (nonatomic, assign, getter=isDisapear) BOOL disapear;
@end

@implementation HJGooView

// 记录当前是否是第一次绘制
- (void)drawRect:(CGRect)rect
{
    // 初始化操作
    if (!self.first) {
        // 初始化变量
        [self setupDefault];
        // 设置标记
        self.first = YES;
    }
    // 动态计算4个附着点以及控制点的坐标
    [self setupPoints];
    
    // 绘制图形
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 画范围对应的圆
    CGContextAddArc(ctx, self.stickCenter.x, self.stickCenter.y, self.maxDistance, 0, 2 * M_PI, 0);
    CGContextStrokePath(ctx);
    // 绘制两个圆(固定圆/拖拽圆)
    [self drawArc:ctx];
    
}
/// 绘制两个圆(固定圆/拖拽圆)
- (void)drawArc:(CGContextRef)ctx
{
    // 判断是否需要绘制
    if (!self.isDisapear) {
        
        // 画拖拽圆
        CGContextAddArc(ctx, self.dragCenter.x, self.dragCenter.y, self.dragRadius, 0, 2 * M_PI, 0);
        // 设置圆的颜色
        [[UIColor redColor] set];
        // 渲染
        CGContextFillPath(ctx);
        
        // 判断是否需要绘制连接部分
        if (!self.isOutOfRange) {
            
            // 画固定圆
            CGContextAddArc(ctx, self.stickCenter.x, self.stickCenter.y, [self getStickRadius], 0, 2 * M_PI, 0);
            // 设置圆的颜色
            [[UIColor redColor] set];
            // 渲染
            CGContextFillPath(ctx);
            // 画矩形
            [self drawMyRect:ctx];
        }
        
        // 绘制提醒数字
        [self drawText:ctx];
        
    }
}

- (void)drawText:(CGContextRef)ctx
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:18.0];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    CGPoint point = CGPointMake(self.dragCenter.x - 10, self.dragCenter.y - 10);
    [self.number drawAtPoint:point withAttributes:dict];
}

/// 绘制两个圆的连接不封
- (void)drawMyRect:(CGContextRef)ctx
{
    // 移动到第一个点
    CGContextMoveToPoint(ctx,self.stickPoint1.x, self.stickPoint1.y);
    // 绘制上面一条曲线
    CGContextAddQuadCurveToPoint(ctx, self.controlPoint.x, self.controlPoint.y, self.dragPoint1.x, self.dragPoint1.y);
    // 绘制连接到第二个点的直线
    CGContextAddLineToPoint(ctx, self.dragPoint2.x, self.dragPoint2.y);
    // 绘制下面一条曲线
    CGContextAddQuadCurveToPoint(ctx, self.controlPoint.x, self.controlPoint.y, self.stickPoint2.x, self.stickPoint2.y);
    
    [[UIColor redColor] set];
    CGContextFillPath(ctx);
}

/// 计算4个附着点以及控制点的坐标
- (void)setupPoints
{
    // 计算角3的tan -->利用tan转换出弧度 -->调用OC的方法计算出sin cos
    // 获取对边和邻边的值
    double xOffset = self.stickCenter.x - self.dragCenter.x; //邻边
    double yOffset = self.stickCenter.y - self.dragCenter.y; // 对边
    double tan = 0.0;
    if (xOffset != 0.0) {
        tan = yOffset / xOffset;
    }
    // 获取拖拽圆的两个焦点
    NSArray *dragPoints = [HJGooUtil getIntersectionPoints:self.dragCenter radius:self.dragRadius lineK:tan];
    self.dragPoint1 = [dragPoints[0] CGPointValue];
    self.dragPoint2 = [dragPoints[1] CGPointValue];
    
    // 获取固定圆的两个焦点
    //    NSArray *stickPoints = [HJGooUtil getIntersectionPoints:self.stickCenter radius:self.stickRadius lineK:tan];
    NSArray *stickPoints = [HJGooUtil getIntersectionPoints:self.stickCenter radius:[self getStickRadius] lineK:tan];
    self.stickPoint1 = [stickPoints[0] CGPointValue];
    self.stickPoint2 = [stickPoints[1] CGPointValue];
    
    // 获取控制点
    self.controlPoint = [HJGooUtil getMiddlePoint:self.dragCenter endPoint:self.stickCenter];
}

/// 初始化两个圆以及矩形的默认值
- (void)setupDefault
{
    // 初始化能够拉伸的最远距离
    self.maxDistance = 120.0;
    
    // 初始化两个圆的变量
    self.stickCenter = CGPointMake(120.0, 120.0);
    self.stickRadius = 12.0;
    self.dragCenter = CGPointMake(120.0, 120.0);
    self.dragRadius = 18.0;
    // 初始化矩形的变量
    self.stickPoint1 = CGPointMake(250.0, 250.0);
    self.stickPoint2 = CGPointMake(250.0, 350.0);
    self.dragPoint1 = CGPointMake(50.0, 250.0);
    self.dragPoint2 = CGPointMake(50.0, 350.0);
    self.controlPoint = CGPointMake(150.0, 300.0);
}

#pragma mark - 内部控制方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获取手指触摸的坐标
    UITouch *touch = [touches anyObject];
    CGPoint newPoint = [touch locationInView:touch.view];
    
    // 更新UI
    self.dragCenter = newPoint;
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获取手指触摸的坐标
    UITouch *touch = [touches anyObject];
    CGPoint newPoint = [touch locationInView:touch.view];
    
    // 判断是否超出拖拽范围
    // 获取两个圆圆心的距离
    double distance = [HJGooUtil getDistanceBetween2Point:self.dragCenter endPoint:self.stickCenter];
    // 判断圆心的距离是否大于最大能够拉伸的距离
    if (distance > self.maxDistance) {
        // 超出
        self.outOfRange = YES;
    }else
    {
        self.outOfRange = NO;
    }
    
    // 更新UI
    self.dragCenter = newPoint;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isOutOfRange) {
        // 手指松开时候, 超出范围 -->销毁所有的图形
        self.disapear = YES;
        [self setNeedsDisplay];
    }else
    {
        // 手指松开时候, 没有超出范围 -->回到固定圆的位置
        self.disapear = NO;
        self.dragCenter = self.stickCenter;
        [self setNeedsDisplay];
    }
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(gooView:onDisapear:)]) {
        [self.delegate gooView:self onDisapear:self.disapear];
    }
}
- (double)getStickRadius
{
    // 获取当前两个圆圆心的距离
    double distance = [HJGooUtil getDistanceBetween2Point:self.dragCenter endPoint:self.stickCenter];
    
    // 为了避免拉伸的距离超过最大的距离
    // 0~1
    distance = MIN(distance, self.maxDistance);
    
    // 计算拉伸的比例(拉伸的距离和最大能够拉伸的距离的比例)
    // 如果直接计算比例, 拉的越远比例越大, 拉的越近比例越小
    // 我们想要的时,拉的越远比例越小,拉的越近比例越大
    double scale = distance / self.maxDistance;
    NSLog(@"scale = %f", scale);
    double evaluate =  [HJGooUtil evaluateValue:scale startValue:1.0 endValue:0.4];
    NSLog(@"evaluate = %f", evaluate);
    return self.stickRadius * evaluate;
}
- (void)test2
{
    // 初始化变量
    // 初始化两个圆的变量
    self.stickCenter = CGPointMake(120.0, 120.0);
    self.stickRadius = 12.0;
    self.dragCenter = CGPointMake(80.0, 80.0);
    self.dragRadius = 18.0;
    // 初始化矩形的变量
    self.stickPoint1 = CGPointMake(250.0, 250.0);
    self.stickPoint2 = CGPointMake(250.0, 350.0);
    self.dragPoint1 = CGPointMake(50.0, 250.0);
    self.dragPoint2 = CGPointMake(50.0, 350.0);
    self.controlPoint = CGPointMake(150.0, 300.0);
    /******************动态计算4个附着点得位置****************************/
    // 计算角3的tan -->利用tan转换出弧度 -->调用OC的方法计算出sin cos
    // 获取对边和邻边的值
    double xOffset = self.stickCenter.x - self.dragCenter.x; //邻边
    double yOffset = self.stickCenter.y - self.dragCenter.y; // 对边
    double tan = 0.0;
    if (xOffset != 0.0) {
        tan = yOffset / xOffset;
    }
    // 获取拖拽圆的两个焦点
    NSArray *dragPoints = [HJGooUtil getIntersectionPoints:self.dragCenter radius:self.dragRadius lineK:tan];
    self.dragPoint1 = [dragPoints[0] CGPointValue];
    self.dragPoint2 = [dragPoints[1] CGPointValue];
    
    // 获取固定圆的两个焦点
    NSArray *stickPoints = [HJGooUtil getIntersectionPoints:self.stickCenter radius:self.stickRadius lineK:tan];
    self.stickPoint1 = [stickPoints[0] CGPointValue];
    self.stickPoint2 = [stickPoints[1] CGPointValue];
    
    // 获取控制点
    self.controlPoint = [HJGooUtil getMiddlePoint:self.dragCenter endPoint:self.stickCenter];
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    /******************画两个圆****************************/
    // 画拖拽圆
    CGContextAddArc(ctx, self.dragCenter.x, self.dragCenter.y, self.dragRadius, 0, 2 * M_PI, 0);
    // 设置圆的颜色
    [[UIColor redColor] set];
    // 渲染
    CGContextFillPath(ctx);
    
    // 画固定圆
    CGContextAddArc(ctx, self.stickCenter.x, self.stickCenter.y, self.stickRadius, 0, 2 * M_PI, 0);
    // 设置圆的颜色
    [[UIColor redColor] set];
    // 渲染
    CGContextFillPath(ctx);
    
    
    /******************画矩形****************************/
    // 移动到第一个点
    CGContextMoveToPoint(ctx,self.stickPoint1.x, self.stickPoint1.y);
    // 绘制上面一条曲线
    CGContextAddQuadCurveToPoint(ctx, self.controlPoint.x, self.controlPoint.y, self.dragPoint1.x, self.dragPoint1.y);
    // 绘制连接到第二个点的直线
    CGContextAddLineToPoint(ctx, self.dragPoint2.x, self.dragPoint2.y);
    // 绘制下面一条曲线
    CGContextAddQuadCurveToPoint(ctx, self.controlPoint.x, self.controlPoint.y, self.stickPoint2.x, self.stickPoint2.y);
    
    [[UIColor redColor] set];
    CGContextFillPath(ctx);
}

- (void)test1
{
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    /******************画两个圆****************************/
    // 画拖拽圆
    /*
     1.上下文
     2.圆心x/y
     3.半径
     4.起始位置
     5.顺逆时针
     */
    CGContextAddArc(ctx, 80.0, 80.0, 18.0, 0, 2 * M_PI, 0);
    // 设置圆的颜色
    [[UIColor redColor] set];
    // 渲染
    CGContextFillPath(ctx);
    
    // 画固定圆
    CGContextAddArc(ctx, 120.0, 120.0, 12.0, 0, 2 * M_PI, 0);
    // 设置圆的颜色
    [[UIColor redColor] set];
    // 渲染
    CGContextFillPath(ctx);
    
    /******************画矩形****************************/
    // 移动到第一个点
    CGContextMoveToPoint(ctx, 250.0, 250.0);
    /*
     c : 上下文
     cpx/cpy: 控制点
     x/y : 终点
     */
    // 绘制上面一条曲线
    CGContextAddQuadCurveToPoint(ctx, 150.0, 300.0, 50.0, 250.0);
    // 绘制连接到第二个点的直线
    CGContextAddLineToPoint(ctx, 50, 350);
    // 绘制下面一条曲线
    CGContextAddQuadCurveToPoint(ctx, 150.0, 300.0, 250.0, 350.0);
    
    [[UIColor redColor] set];
    CGContextFillPath(ctx);
}

@end
