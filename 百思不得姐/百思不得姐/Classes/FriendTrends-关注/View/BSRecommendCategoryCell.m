//
//  BSRecommendCategoryCell.m
//  百思不得姐
//
//  Created by WCF on 2017/7/20.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import "BSRecommendCategoryCell.h"
#import "BSRecommendCategory.h"

@interface BSRecommendCategoryCell ()
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;

@end

@implementation BSRecommendCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.backgroundColor = BSRGBColor(244, 244, 244);
    self.selectedIndicator.backgroundColor = BSRGBColor(219, 21, 26);
}

- (void)setCategory:(BSRecommendCategory *)category
{
    _category = category;

    self.textLabel.text = category.name;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2*self.textLabel.y;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectedIndicator.hidden = !selected;
    self.textLabel.textColor = selected ? self.selectedIndicator.backgroundColor : BSRGBColor(78, 78, 78);
}

@end
