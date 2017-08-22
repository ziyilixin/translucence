//
//  BSFriendTrendsViewController.m
//  百思不得姐
//
//  Created by WCF on 2017/7/14.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import "BSFriendTrendsViewController.h"
#import "BSRecommendViewController.h"
#import "BSLoginRegisterViewController.h"

@interface BSFriendTrendsViewController ()

@end

@implementation BSFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航栏标题
    self.navigationItem.title = @"我的关注";

    //设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(friendClick)];

    self.view.backgroundColor = BSGlobalBg;
}

- (void)friendClick
{
    BSRecommendViewController *recommandVC = [[BSRecommendViewController alloc] init];
    [self.navigationController pushViewController:recommandVC animated:YES];
}

- (IBAction)loginRegister:(id)sender {
    BSLoginRegisterViewController *loginRegisterVC = [[BSLoginRegisterViewController alloc] init];
    [self presentViewController:loginRegisterVC animated:YES completion:nil];
}

@end
