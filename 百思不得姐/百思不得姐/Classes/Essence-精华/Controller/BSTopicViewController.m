//
//  BSTopicViewController.m
//  百思不得姐
//
//  Created by WCF on 2017/8/3.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import "BSTopicViewController.h"
#import "BSTopic.h"
#import "BSTopicCell.h"

@interface BSTopicViewController ()
/** 帖子数据 */
@property (nonatomic,strong) NSMutableArray *topics;

@property (nonatomic,strong) NSString *maxtime;

@property (nonatomic,strong) NSMutableDictionary *params;
/** 页码 */
@property (nonatomic,assign) NSInteger page;
@end

static NSString * const topicCellId = @"topic";

@implementation BSTopicViewController

/**
 * 懒加载
 */
- (NSMutableArray *)topics
{
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化表格
    [self setUpTableView];

    //设置刷新
    [self setUpRefresh];
}

- (void)setUpTableView
{
    //设置内边距
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = BSTitlesViewH + kNavigationBarHeight;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    //设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSTopicCell class]) bundle:nil] forCellReuseIdentifier:topicCellId];
}

/**
 * 设置刷新
 */
- (void)setUpRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    //根据拖拽比例自动切换透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
}

- (void)loadNewTopics
{
    //结束上拉刷新
    [self.tableView.mj_footer endRefreshing];

    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    self.params = params;

    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.params != params) return;

        //存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];

        //字典数组转模型数组
        self.topics = [BSTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [self.topics enumerateObjectsUsingBlock:^(BSTopic *topic, NSUInteger idx, BOOL * _Nonnull stop) {
            BSLog(@"%f",topic.cellHeight);
        }];

        //刷新数据
        [self.tableView reloadData];

        //结束刷新
        [self.tableView.mj_header endRefreshing];

        //清空页码
        self.page = 0;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;

        //结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreTopic
{
    //结束下拉刷新
    [self.tableView.mj_header endRefreshing];

    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    params[@"maxtime"] = self.maxtime;
    NSInteger page = self.page + 1;
    params[@"page"] = @(page);
    params[@"maxtime"] = self.maxtime;
    self.params = params;

    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.params != params) return;

        //字典数组转模型数组
        NSArray *topicsArr = [BSTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:topicsArr];
        
        [self.topics enumerateObjectsUsingBlock:^(BSTopic *topic, NSUInteger idx, BOOL * _Nonnull stop) {
            BSLog(@"%f",topic.cellHeight);
        }];

        self.maxtime = responseObject[@"info"][@"maxtime"];

        //刷新数据
        [self.tableView reloadData];

        //结束刷新
        [self.tableView.mj_footer endRefreshing];

        self.page = page;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;

        //结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BSTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:topicCellId];
    cell.topic = self.topics[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出帖子模型
    BSTopic *topic = self.topics[indexPath.row];
    return topic.cellHeight;
}

@end
