//
//  UIBarButtonItem+BSExtension.h
//  百思不得姐
//
//  Created by WCF on 2017/7/14.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (BSExtension)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)image target:(id)target action:(SEL)action;
@end
