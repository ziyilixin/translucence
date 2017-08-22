//
//  BSRecommendCategory.h
//  百思不得姐
//
//  Created by WCF on 2017/7/20.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSRecommendCategory : NSObject
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSMutableArray *users;
/** 总数*/
@property (nonatomic,assign) NSInteger total;
/** 当前页数*/
@property (nonatomic,assign) NSInteger currentPage;
@end
