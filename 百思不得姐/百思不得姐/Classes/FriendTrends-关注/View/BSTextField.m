//
//  BSTextField.m
//  百思不得姐
//
//  Created by WCF on 2017/7/27.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import "BSTextField.h"

static NSString * const BSPlaceHolderColorKeyPath = @"_placeholderLabel.textColor";

@implementation BSTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //设置光标颜色和文字颜色一样
    self.tintColor = self.textColor;

    //不成为第一响应者
    [self resignFirstResponder];
}

/**
 * 当前文本框聚焦时就会调用
 */
- (BOOL)becomeFirstResponder
{
    [self setValue:self.textColor forKeyPath:BSPlaceHolderColorKeyPath];
    return [super becomeFirstResponder];
}

/**
 * 挡墙文本框失去焦点时就会调用
 */
- (BOOL)resignFirstResponder
{
    [self setValue:[UIColor grayColor] forKeyPath:BSPlaceHolderColorKeyPath];
    return [super resignFirstResponder];
}

@end
