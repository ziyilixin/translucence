//
//  NSDate+BSExtension.m
//  百思不得姐
//
//  Created by WCF on 2017/8/9.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import "NSDate+BSExtension.h"

@implementation NSDate (BSExtension)
- (NSDateComponents *)deltaFrom:(NSDate *)from
{
    //日历
    NSCalendar *calendar = [NSCalendar currentCalendar];

    //比较时间
    NSCalendarUnit unit = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    return [calendar components:unit fromDate:from toDate:self options:0];
}


- (BOOL)isThisYear
{
    //日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    return nowYear == selfYear;
}

- (BOOL)isToday
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowString = [formatter stringFromDate:[NSDate date]];
    NSString *selfString = [formatter stringFromDate:self];

    return [nowString isEqualToString:selfString];
}

- (BOOL)isYesterday
{
    // 2016-12-31 23:59:59 -> 2016-12-31
    // 2017-01-01 00:00:01 -> 2017-01-01

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";

    NSDate *nowDate = [formatter dateFromString:[formatter stringFromDate:[NSDate date]]];
    NSDate *selfDate = [formatter dateFromString:[formatter stringFromDate:self]];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    return components.year == 0
    && components.month == 0
    && components.day == 1;
}

@end
