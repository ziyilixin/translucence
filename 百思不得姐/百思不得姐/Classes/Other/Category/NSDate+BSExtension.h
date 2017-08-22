//
//  NSDate+BSExtension.h
//  百思不得姐
//
//  Created by WCF on 2017/8/9.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (BSExtension)
/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/**
 * 是否是今年
 */
- (BOOL)isThisYear;

/**
 * 是否是今天
 */
- (BOOL)isToday;

/**
 * 是否是昨天
 */
- (BOOL)isYesterday;

@end
