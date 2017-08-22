//
//  BSRecommendTags.h
//  百思不得姐
//
//  Created by WCF on 2017/7/24.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSRecommendTags : NSObject
/** 图片 */
@property (nonatomic, copy) NSString *image_list;
/** 名字 */
@property (nonatomic, copy) NSString *theme_name;
/** 订阅数 */
@property (nonatomic, assign) NSInteger sub_number;
@end
