//
//  BSPushGuideView.m
//  百思不得姐
//
//  Created by WCF on 2017/8/1.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import "BSPushGuideView.h"

@interface BSPushGuideView ()


@end

@implementation BSPushGuideView

+ (instancetype)guideView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

+ (void)show
{
    NSString *key = @"CFBundleShortVersionString";
    //获取当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    //获取沙盒中存储的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];

    if (![currentVersion isEqualToString:sanboxVersion]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        BSPushGuideView *guideView = [BSPushGuideView guideView];
        guideView.frame = window.bounds;
        [window addSubview:guideView];

        //存储版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

- (IBAction)dismiss:(id)sender {
    [self removeFromSuperview];
}

@end
