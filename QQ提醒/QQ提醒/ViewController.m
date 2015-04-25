//
//  ViewController.m
//  QQ提醒
//
//  Created by apple on 15/4/25.
//  Copyright (c) 2015年 七. All rights reserved.
//

#import "ViewController.h"
#import "HJGooView.h"

@interface ViewController ()<HJGooViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    HJGooView  *gooView = [[HJGooView alloc] init];
    gooView.frame = [UIScreen mainScreen].bounds;
    gooView.backgroundColor = [UIColor whiteColor];
    gooView.number = @"77";
    gooView.delegate = self;
    [self.view addSubview:gooView];
}

#pragma mark - HJGooViewDelegate
- (void)gooView:(HJGooView *)gooView onDisapear:(BOOL)idsapear
{
    if (idsapear) {
        // 需要清空消息
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"超出范围, 清空消息" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else
    {
        // 不需要清空(放回去)
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有超出范围, 不要清空消息" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

@end
