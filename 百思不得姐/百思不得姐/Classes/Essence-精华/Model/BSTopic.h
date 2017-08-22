//
//  BSTopic.h
//  百思不得姐
//
//  Created by WCF on 2017/8/5.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSTopic : NSObject
/** 名称 */
@property (nonatomic,copy) NSString *name;
/** 头像 */
@property (nonatomic,copy) NSString *profile_image;
/** 发帖时间 */
@property (nonatomic,copy) NSString *created_at;
/** 文字内容 */
@property (nonatomic,copy) NSString *text;
/** 订的数量 */
@property (nonatomic,assign) NSInteger ding;
/** 踩的数量 */
@property (nonatomic,assign) NSInteger cai;
/** 转发的数量 */
@property (nonatomic,assign) NSInteger repost;
/** 评论的数量 */
@property (nonatomic,assign) NSInteger comment;
/** 是否为新浪加V用户 */
@property (nonatomic,assign,getter = isSina_v) BOOL sina_v;
/** 图片的宽度 */
@property (nonatomic, assign) CGFloat width;
/** 图片的高度 */
@property (nonatomic, assign) CGFloat height;
/** 小图的url */
@property (nonatomic, copy) NSString *small_image;
/** 中图的url */
@property (nonatomic, copy) NSString *middle_image;
/** 大图的url */
@property (nonatomic, copy) NSString *large_image;
/** 帖子的类型 */
@property (nonatomic, assign) BSTopicType type;

/*************额外的辅助属性*************/
/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;
/** picture的frame */
@property (nonatomic, assign, readonly) CGRect pictureF;
/** 图片是否太大 */
@property (nonatomic, assign, getter = isBigPicture) BOOL bigPicture;
/** 图片的下载进度 */
@property (nonatomic, assign) CGFloat pictureProgress;
@end
