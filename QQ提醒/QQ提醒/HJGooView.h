//
//  HJGooView.h
//  QQ提醒
//
//  Created by apple on 15/4/25.
//  Copyright (c) 2015年 七. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HJGooView;

@protocol HJGooViewDelegate <NSObject>

// 告诉代理当前是否需要消失
- (void)gooView:(HJGooView *)gooView onDisapear:(BOOL)idsapear;

@end

@interface HJGooView : UIView

/// 未读数
@property (nonatomic, copy) NSString *number;

@property (nonatomic, weak) id<HJGooViewDelegate> delegate;

@end
