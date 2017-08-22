//
//  BSProgressView.m
//  百思不得姐
//
//  Created by WCF on 2017/8/19.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import "BSProgressView.h"

@implementation BSProgressView

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.roundedCorners = 2;
    self.progressLabel.textColor = [UIColor whiteColor];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [super setProgress:progress animated:animated];
    
    NSString *text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    self.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end
