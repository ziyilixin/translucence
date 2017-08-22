//
//  BSTabBar.m
//  百思不得姐
//
//  Created by WCF on 2017/7/14.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import "BSTabBar.h"
#import "BSPublishView.h"

@interface BSTabBar ()
@property (nonatomic,weak) UIButton *publishButton;
@end

@implementation BSTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        //设置tabBar的背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];

        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        publishButton.size = publishButton.currentBackgroundImage.size;
        [self addSubview:publishButton];
        self.publishButton = publishButton;
    }
    return self;
}

//UIWindow *window;
//UIWindow *window2;

- (void)publishClick
{
    //窗口级别 UIWindowLevelNormal < UIWindowLevelAlert < UIWindowLevelStatusBar
//    window = [[UIWindow alloc] init];
//    window.frame = CGRectMake(0, 0, 414, 20);
//    window.backgroundColor = [UIColor purpleColor];
//    window.windowLevel = UIWindowLevelStatusBar;
//    window.hidden = NO;
//
//    window2 = [[UIWindow alloc] init];
//    window2.frame = CGRectMake(100, 100, 100, 100);
//    window2.backgroundColor = [UIColor redColor];
//    window2.hidden = NO;

    [BSPublishView show];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    //设置发布按钮的frame
    CGFloat width = self.width;
    CGFloat height = self.height;
    self.publishButton.center = CGPointMake(width*0.5, height*0.5);

    //设置其它UITabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = width / 5;
    CGFloat buttonH = height;

    NSInteger index = 0;
    
    for (UIView *button in self.subviews) {

        if (![button isKindOfClass:[UIControl class]] || button == self.publishButton)  continue;

        //计算按钮的X值
        CGFloat buttonX = buttonW * ((index > 1) ? (index + 1) : index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);

        //增加索引
        index++;
        
    }
}

@end
