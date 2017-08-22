//
//  BSTopicPictureView.h
//  百思不得姐
//
//  Created by WCF on 2017/8/16.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSTopic;

@interface BSTopicPictureView : UIView
+ (instancetype)pictureView;

/** 帖子数据 */
@property (nonatomic,strong) BSTopic *topic;
@end
