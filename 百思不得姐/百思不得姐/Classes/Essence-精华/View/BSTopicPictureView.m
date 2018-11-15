//
//  BSTopicPictureView.m
//  百思不得姐
//
//  Created by WCF on 2017/8/16.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import "BSTopicPictureView.h"
#import "BSTopic.h"
#import "BSProgressView.h"
#import "BSShowPictureController.h"

@interface BSTopicPictureView ()
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
@property (nonatomic, weak) BSProgressView *progressView;
@end

@implementation BSTopicPictureView
+ (instancetype)pictureView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;

    self.pictureImageView.userInteractionEnabled = YES;
    [self.pictureImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

- (void)showPicture
{
    BSShowPictureController *showPictureVC = [[BSShowPictureController alloc] init];
    showPictureVC.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPictureVC animated:YES completion:nil];
}

- (void)setTopic:(BSTopic *)topic
{
    _topic = topic;

    //立马显示最新的进度值(防止因为网速慢, 导致显示的是其他图片的下载进度)
    [self.progressView setProgress:topic.pictureProgress animated:NO];
    
    //设置图片
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        self.progressView.hidden = NO;
        topic.pictureProgress = 1.0 * receivedSize / expectedSize;
        [self.progressView setProgress:topic.pictureProgress animated:NO];
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.progressView.hidden = YES;
        
        //如果是大图片，才需要绘图处理
        if (topic.isBigPicture == NO) return;
        
        //开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topic.pictureF.size, YES, 0.0);
        
        //将下载完成的图片绘制到图形上下文
        CGFloat width = topic.pictureF.size.width;
        CGFloat height = topic.pictureF.size.width * image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, width, height)];
        
        //获得图片
        self.pictureImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        //结束图形上下文
        UIGraphicsEndImageContext();
    }];
    
    //判断是否是gif
    NSString *extension = topic.large_image.pathExtension;
    self.gifImageView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];

    // 判断是否显示"点击查看全图"
    if (topic.bigPicture) {// 大图
        self.seeBigButton.hidden = NO;
    }
    else {//非大图
        self.seeBigButton.hidden = YES;
    }
    
}
@end
