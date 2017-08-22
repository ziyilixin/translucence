//
//  BSRecommendTagsCell.m
//  百思不得姐
//
//  Created by WCF on 2017/7/24.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import "BSRecommendTagsCell.h"
#import "BSRecommendTags.h"

@interface BSRecommendTagsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imagelistImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;

@end

@implementation BSRecommendTagsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRecommendTag:(BSRecommendTags *)recommendTag
{
    _recommendTag = recommendTag;

    [self.imagelistImg sd_setImageWithURL:[NSURL URLWithString:recommendTag.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.nameLabel.text = recommendTag.theme_name;
    NSString *subNumber = nil;
    if (recommendTag.sub_number < 10000) {
        subNumber = [NSString stringWithFormat:@"%zd人订阅",recommendTag.sub_number];
    }
    else {
        subNumber = [NSString stringWithFormat:@"%.1f万人订阅",recommendTag.sub_number/10000.0];
    }

    self.subNumberLabel.text = subNumber;
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 10;
    frame.size.width -= 2*frame.origin.x;
    frame.size.height -= 1;

    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
