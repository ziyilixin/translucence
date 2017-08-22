//
//  BSRecommendUserCell.m
//  百思不得姐
//
//  Created by WCF on 2017/7/20.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import "BSRecommendUserCell.h"
#import "BSRecommendUser.h"

@interface BSRecommendUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLab;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLab;
@end

@implementation BSRecommendUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUser:(BSRecommendUser *)user
{
    _user = user;

    [self.headImg sd_setImageWithURL:[NSURL URLWithString:user.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.screenNameLab.text = user.screen_name;

    NSString *fansNumber = nil;
    if (user.fans_count < 10000) {
        fansNumber = [NSString stringWithFormat:@"%zd人关注",user.fans_count];
    }
    else {
        fansNumber = [NSString stringWithFormat:@"%.1f万人关注",user.fans_count/10000.0];
    }

    self.fansCountLab.text = fansNumber;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
