//
//  HJGooUtil.m
//  QQ提醒
//
//  Created by apple on 15/4/25.
//  Copyright (c) 2015年 七. All rights reserved.
//

#import "HJGooUtil.h"
#import <math.h>

@implementation HJGooUtil

/**
 *  获取两点之间距离
 *
 *  @param startPoint 起点
 *  @param endPoint   终点
 *
 *  @return 两点之间的距离
 */
+ (CGFloat)getDistanceBetween2Point:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    /*
     sqrt:开平方运算
     pow(x, y) 计算以x为底数的y次幂
     勾股定理: 两条直角边平方 = 斜边长度平方
     */
    float distance = sqrt(pow(startPoint.y - endPoint.y , 2) + pow(startPoint.x - endPoint.x, 2));
    return distance;
}

/**
 *  获得两点连线的中点
 *
 *  @param startPoint 起点
 *  @param endPoint   终点
 *
 *  @return 中点坐标
 */
+ (CGPoint)getMiddlePoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    return CGPointMake((startPoint.x + endPoint.x)/ 2.0, (startPoint.y + endPoint.y)/ 2.0);
}

/**
 *  根据百分比获取两点之间的某个点坐标
 *
 *  @param startPoint 开始位置
 *  @param endPoint   结束位置
 *  @param percent    百分比
 *
 *  @return 具体位置坐标
 */
+ (CGPoint)getPointByPercent:(CGPoint)startPoint endPoint:(CGPoint)endPoint percent:(CGFloat)percent{
    CGFloat x = [self evaluateValue:percent startValue:startPoint.x endValue:endPoint.x];
    CGFloat y = [self evaluateValue:percent startValue:startPoint.y endValue:endPoint.y];
    return CGPointMake(x , y);
}

/**
 *  根据分度值，计算从start到end中，fraction位置的值
 *
 *  @param fraction   0~1
 *  @param startValue 开始位置
 *  @param endValue   结束位置
 *
 *  @return 计算好的位置
 */
+ (CGFloat)evaluateValue:(CGFloat)fraction startValue:(CGFloat)startValue endValue:(CGFloat)endValue{
    
    return startValue + fraction * (endValue - startValue);
}

/**
 *  获得与圆的焦点
 *
 *  @param pMiddle 圆的圆心
 *  @param radius  圆的半径
 *  @param lineK   圆的正切tan
 *
 *  @return 与原的两个焦点
 */
+ (NSArray *)getIntersectionPoints:(CGPoint)pMiddle radius:(CGFloat)radius lineK:(CGFloat)lineK{
    CGFloat radian = 0; //弧度
    CGFloat xOffset = 0; // X方向偏移位
    CGFloat yOffset = 0; // Y方向偏移位
    /*
     sin = 对边/斜边
     cos = 邻边/斜边
     tan = 对边/邻边
     */
    if (lineK != 0.0) {
        radian = atan(lineK);// 利用反正切算出弧度
        // sin = 对边/斜边 所以: 对边 = 斜边(半径) * sin
        xOffset = sin(radian) * radius;
        // cos = 邻边/斜边 所以: 邻边 = 斜边(半径) * cos
        yOffset = cos(radian) * radius;
    }else
    {
        xOffset = radius;
        yOffset = 0;
    }
    /*
     例如拖拽圆上面一个点:
     x = (拖拽圆圆心x + 斜边(半径) * sin1)
     y = (拖拽圆圆心y - 斜边(半径) * cos1)
     */
    // 第一个个附着点位置
    CGPoint point0 = CGPointMake(pMiddle.x + xOffset, pMiddle.y - yOffset);
    /*
     例如拖拽圆下面一个点
     x = (拖拽圆圆心x - 斜边(半径) * sin1)
     y = (拖拽圆圆心y + 斜边(半径) * sin1)
     */
    // 第二个附着点位置
    CGPoint point1 = CGPointMake(pMiddle.x - xOffset, pMiddle.y + yOffset);
    
    // 返回圆上的两个切点
    return @[[NSValue valueWithCGPoint:point0], [NSValue valueWithCGPoint:point1]];
}

@end
