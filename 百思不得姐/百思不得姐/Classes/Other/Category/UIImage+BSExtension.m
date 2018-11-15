//
//  UIImage+BSExtension.m
//  百思不得姐
//
//  Created by WCF on 2017/12/3.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import "UIImage+BSExtension.h"

@implementation UIImage (BSExtension)
/**
 * 圆形图片
 */
- (UIImage *)cycleImage
{
    //NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);

    //获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    //添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);

    //裁剪
    CGContextClip(ctx);

    //将图片画上去
    [self drawInRect:rect];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}
@end
