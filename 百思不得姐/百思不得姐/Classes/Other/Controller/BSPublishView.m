//
//  BSPublishView.m
//  百思不得姐
//
//  Created by WCF on 2017/8/20.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import "BSPublishView.h"
#import "BSVerticalButton.h"

@interface BSPublishView ()

@end
static CGFloat const XMGAnimationDelay = 0.1;
static CGFloat const XMGSpringFactor = 10;

@implementation BSPublishView

+ (instancetype)publishView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

static UIWindow *window_;

+ (void)show
{
    //    BSPublishView *publishView = [BSPublishView publishView];
    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //    publishView.frame = window.bounds;
    //    [window addSubview:publishView];

    //创建窗口
    window_ = [[UIWindow alloc] init];
    window_.frame = [UIScreen mainScreen].bounds;
    window_.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    window_.hidden = NO;

    //添加发布界面
    BSPublishView *publishView = [BSPublishView publishView];
    publishView.frame = window_.frame;
    [window_ addSubview:publishView];

}

- (void)awakeFromNib
{
    [super awakeFromNib];

    //不能点击
    self.userInteractionEnabled = NO;

    //数据
    NSArray *titlesArr = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    NSArray *imagesArr = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];

    //中间的6个按钮
    int maxCols = 3;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartX = 20;
    CGFloat buttonStartY = (kScreenH - 2 * buttonH) * 0.5;
    CGFloat xMargin = (kScreenW - 2 * buttonStartX - maxCols * buttonW) / (maxCols - 1);

    for (int i = 0; i < titlesArr.count; i++) {
        BSVerticalButton *button = [[BSVerticalButton alloc] init];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        //设置内容
        [button setTitle:titlesArr[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imagesArr[i]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];


        //设置x\y
        int row = i / maxCols;
        int col = i % maxCols;
        CGFloat buttonX = buttonStartX + col * (buttonW + xMargin);
        CGFloat buttonEndY = buttonStartY + row * buttonH;
        CGFloat buttonStartY = buttonEndY - kScreenH;

        //按钮动画
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonStartY, buttonW, buttonH)];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        animation.springBounciness = XMGSpringFactor;
        animation.springSpeed = XMGSpringFactor;
        animation.beginTime = CACurrentMediaTime() + XMGAnimationDelay*i;
        [button pop_addAnimation:animation forKey:nil];
    }

    //添加标语
    UIImageView *sloganImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self addSubview:sloganImageView];

    //标语动画
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    CGFloat centerX = kScreenW * 0.5;
    CGFloat centerEndY = kScreenH * 0.2;
    CGFloat centerBeginY = centerEndY - kScreenH;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerBeginY)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    animation.beginTime = CACurrentMediaTime() + imagesArr.count *XMGAnimationDelay;
    animation.springBounciness = XMGSpringFactor;
    animation.springSpeed = XMGSpringFactor;
    [animation setCompletionBlock:^(POPAnimation *anim, BOOL finished){
        //标语动画执行完毕, 恢复点击事件
        self.userInteractionEnabled = YES;
    }];
    [sloganImageView pop_addAnimation:animation forKey:nil];
}

- (void)buttonClick:(UIButton *)button
{
    [self cancelWithCompletionBlock:^{
        if (button.tag == 0) {
            BSLog(@"发视频");
        }
        else if (button.tag == 1){
            BSLog(@"发图片");
        }
    }];
}

- (IBAction)dismiss {
    [self cancelWithCompletionBlock:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self cancelWithCompletionBlock:nil];
}

/**
 * 先执行退出动画, 动画完毕后执行completionBlock
 */
- (void)cancelWithCompletionBlock:(void (^)())completionBlock
{
    //不能被点击
    self.userInteractionEnabled = NO;

    int beginIndex = 1;

    for (int i = beginIndex; i < self.subviews.count; i++) {
        UIView *subView = self.subviews[i];

        //基本动画
        POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY = subView.centerY + kScreenH;
        //动画的执行节奏(一开始很慢, 后面很快)
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(subView.centerX, centerY)];
        animation.beginTime = CACurrentMediaTime() + (i - beginIndex)*XMGAnimationDelay;
        [subView pop_addAnimation:animation forKey:nil];

        //监听最后一个动画
        if (i == self.subviews.count - 1) {
            [animation setCompletionBlock:^(POPAnimation *anim, BOOL finished){
                // 销毁窗口
                window_ = nil;
                
                !completionBlock ? : completionBlock();
            }];
        }
    }
}

@end
