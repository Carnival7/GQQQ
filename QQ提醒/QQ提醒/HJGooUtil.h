//
//  HJGooUtil.h
//  QQ提醒
//
//  Created by apple on 15/4/25.
//  Copyright (c) 2015年 七. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HJGooUtil : NSObject

/**
 *  获取两点之间距离
 *
 *  @param startPoint 起点
 *  @param endPoint   终点
 *
 *  @return 两点之间的距离
 */
+ (CGFloat)getDistanceBetween2Point:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/**
 *  获得两点连线的中点
 *
 *  @param startPoint 起点
 *  @param endPoint   终点
 *
 *  @return 中点坐标
 */
+ (CGPoint)getMiddlePoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/**
 *  根据百分比获取两点之间的某个点坐标
 *
 *  @param startPoint 开始位置
 *  @param endPoint   结束位置
 *  @param percent    百分比
 *
 *  @return 具体位置坐标
 */
+ (CGPoint)getPointByPercent:(CGPoint)startPoint endPoint:(CGPoint)endPoint percent:(CGFloat)percent;

/**
 *  根据分度值，计算从start到end中，fraction位置的值
 *
 *  @param fraction   0~1
 *  @param startValue 开始位置
 *  @param endValue   结束位置
 *
 *  @return 计算好的位置
 */
+ (CGFloat)evaluateValue:(CGFloat)fraction startValue:(CGFloat)startValue endValue:(CGFloat)endValue;

/**
 *  获得与圆的焦点
 *
 *  @param pMiddle 圆的圆心
 *  @param radius  圆的半径
 *  @param lineK   圆的正切tan
 *
 *  @return 与原的两个焦点
 */
+ (NSArray *)getIntersectionPoints:(CGPoint)pMiddle radius:(CGFloat)radius lineK:(CGFloat)lineK;

@end
