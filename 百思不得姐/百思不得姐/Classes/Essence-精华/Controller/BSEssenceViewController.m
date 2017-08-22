//
//  BSEssenceViewController.m
//  百思不得姐
//
//  Created by WCF on 2017/7/14.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import "BSEssenceViewController.h"
#import "BSRecommendTagsViewController.h"
#import "BSTopicViewController.h"

@interface BSEssenceViewController ()<UIScrollViewDelegate>
/** 底部的红色指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 顶部的所有标签 */
@property (nonatomic, weak) UIView *titlesView;
/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;
@end

@implementation BSEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航栏
    [self setUpNav];

    //初始化子控制器
    [self addChildViewController];

    //设置顶部的标签栏
    [self setTitlesView];

    //底部的scrolleView
    [self setUpContentView];
}

/**
 * 初始化子控制器
 */
- (void)addChildViewController
{
    BSTopicViewController *pictureVC = [[BSTopicViewController alloc] init];
    pictureVC.navigationItem.title = @"图片";
    pictureVC.type = BSTopicTypePicture;
    [self addChildViewController:pictureVC];

    BSTopicViewController *allVC = [[BSTopicViewController alloc] init];
    allVC.navigationItem.title = @"全部";
    allVC.type = BSTopicTypeAll;
    [self addChildViewController:allVC];

    BSTopicViewController *videoVC = [[BSTopicViewController alloc] init];
    videoVC.navigationItem.title = @"视频";
    videoVC.type = BSTopicTypeVideo;
    [self addChildViewController:videoVC];

    BSTopicViewController *voiceVC = [[BSTopicViewController alloc] init];
    voiceVC.navigationItem.title = @"声音";
    voiceVC.type = BSTopicTypeVoice;
    [self addChildViewController:voiceVC];


    BSTopicViewController *wordVC = [[BSTopicViewController alloc] init];
    wordVC.navigationItem.title = @"帖子";
    wordVC.type = BSTopicTypeWord;
    [self addChildViewController:wordVC];

}

/**
 * 底部的scrollView
 */
- (void)setUpContentView
{
    //不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(self.childViewControllers.count*contentView.width, 0);
    self.contentView = contentView;

    // 添加第一个控制器的View
    [self scrollViewDidEndScrollingAnimation:contentView];
}

/**
 * 设置顶部的标签栏
 */
- (void)setTitlesView
{
    //标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    titlesView.width = self.view.width;
    titlesView.height = BSTitlesViewH;
    titlesView.y = BSTitlesViewY;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;

    //底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.y = titlesView.height - indicatorView.height;
    indicatorView.tag = -1;
    self.indicatorView = indicatorView;

    //内部的子控件
    CGFloat width = titlesView.width/self.childViewControllers.count;
    CGFloat height = titlesView.height;
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        button.width = width;
        button.height = height;
        button.x = i * width;
        UIViewController *viewVC = self.childViewControllers[i];
        [button setTitle:viewVC.navigationItem.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];

        //默认选中第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;

            //让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.titleLabel.width;
            self.indicatorView.centerX = button.centerX;
        }
    }

    [titlesView addSubview:indicatorView];

}

- (void)titleClick:(UIButton *)button
{
    //修改按钮的状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;

    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];

    //滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag*self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

/**
 *设置导航栏
 */
- (void)setUpNav
{
    //设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];

    //设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];

    self.view.backgroundColor = BSGlobalBg;
}

- (void)tagClick
{
    BSRecommendTagsViewController *tagsVC = [[BSRecommendTagsViewController alloc] init];
    [self.navigationController pushViewController:tagsVC animated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //当前的索引
    NSInteger index = scrollView.contentOffset.x/scrollView.width;

    //取出子控制器
    UIViewController *VC = self.childViewControllers[index];
    VC.view.x = scrollView.contentOffset.x;
    VC.view.y = 0;//设置控制器view的y值为0(默认是20)
    VC.view.height = scrollView.height;// 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    [scrollView addSubview:VC.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    //点击按钮
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
}

@end
