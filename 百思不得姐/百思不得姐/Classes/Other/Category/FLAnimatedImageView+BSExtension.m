//
//  FLAnimatedImageView+BSExtension.m
//  百思不得姐
//
//  Created by WCF on 2017/12/3.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import "FLAnimatedImageView+BSExtension.h"

@implementation FLAnimatedImageView (BSExtension)
- (void)setHeader:(NSString *)url
{
    UIImage *plahoder = [[UIImage imageNamed:@"defaultUserIcon"] cycleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:plahoder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image cycleImage] : plahoder;
    }];
}
@end
