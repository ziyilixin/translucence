//
//  BSRecommendViewController.m
//  百思不得姐
//
//  Created by WCF on 2017/7/18.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import "BSRecommendViewController.h"
#import "BSRecommendCategory.h"
#import "BSRecommendCategoryCell.h"
#import "BSRecommendUser.h"
#import "BSRecommendUserCell.h"

#define BSSelectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]

@interface BSRecommendViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;//类目
@property (weak, nonatomic) IBOutlet UITableView *userTableView;//用户
@property (nonatomic,strong) NSArray *categories;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSMutableDictionary *params;
@end

@implementation BSRecommendViewController

static NSString * const categoryId = @"category";
static NSString * const userId = @"user";

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //设置tableView
    [self setupTableView];
    
    //设置刷新
    [self setupRefresh];

    //加载左侧的数据
    [self loadLeftData];
}

/**
 * 设置tableView
 */
- (void)setupTableView
{
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSRecommendCategoryCell class]) bundle:nil] forCellReuseIdentifier:categoryId];
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSRecommendUserCell class]) bundle:nil] forCellReuseIdentifier:userId];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.categoryTableView.contentInset;
    self.userTableView.rowHeight = 70;

    self.navigationItem.title = @"推荐关注";
    self.view.backgroundColor = BSGlobalBg;
}

/**
 * 设置刷新
 */
- (void)setupRefresh
{
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];

    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];

}

- (void)loadNewUsers
{
    BSRecommendCategory *c = BSSelectedCategory;
    c.currentPage = 1;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(c.ID);
    params[@"page"] = @(c.currentPage);
    self.params = params;

    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSArray *users = [BSRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];

        //清空所有旧数据
        [c.users removeAllObjects];

        //添加新数据
        [c.users addObjectsFromArray:users];

        c.total = [responseObject[@"total"] integerValue];

        //不是最后一次请求
        if (self.params != params) return;

        //刷新右边的表格
        [self.userTableView reloadData];

        //结束刷新
        [self.userTableView.mj_header endRefreshing];

        [self checkFooterStatuse];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
        {

        if (self.params != params) return;

        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];

        [self.userTableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreUsers
{
    BSRecommendCategory *category = BSSelectedCategory;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.ID);
    params[@"page"] = @(++category.currentPage);
    self.params = params;

    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSArray *users = [BSRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];

        //添加新数据
        [category.users addObjectsFromArray:users];

        if (self.params != params) return;

        [self.userTableView reloadData];

        [self checkFooterStatuse];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;

        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        [self.userTableView.mj_footer endRefreshing];
    }];
}

/**
 * 时刻检测footer的状态
 */
- (void)checkFooterStatuse
{
    BSRecommendCategory *category = BSSelectedCategory;

    // 每次刷新右边数据时, 都控制footer显示或者隐藏
    self.userTableView.mj_footer.hidden = (category.users.count == 0);

    //让底部结束刷新
    if (category.users.count == category.total) {//数据全部加载完毕
        [self.userTableView.mj_footer endRefreshingWithNoMoreData];
    }
    else {//还有没加载完毕的数据
        [self.userTableView.mj_footer endRefreshing];
    }
}

/**
 * 加载左侧的数据
 */
- (void)loadLeftData
{
    //显示指示器
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];

    //发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";

    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //隐藏指示器
        [SVProgressHUD dismiss];

        self.categories = [BSRecommendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.categoryTableView reloadData];

        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];

        [self.userTableView.mj_header beginRefreshing];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.categoryTableView) {
        return self.categories.count;
    }
    else {

        //检测footer的状态
        [self checkFooterStatuse];

        return [BSSelectedCategory users].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView) {
        BSRecommendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryId];
        cell.category = self.categories[indexPath.row];
        return cell;
    }
    else {
        BSRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:userId];
        cell.user = [BSSelectedCategory users][indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //结束刷新
    [self.userTableView.mj_header endRefreshing];
    [self.userTableView.mj_footer endRefreshing];

    BSRecommendCategory *category = self.categories[indexPath.row];
    if (category.users.count) {
        //显示曾经的数据
        [self.userTableView reloadData];
    }
    else {
        //赶紧刷新表格。目的：马上显示当前category的数据，不让用户看到上一个category的残留数据
        [self.userTableView reloadData];

        //进入下拉刷新状态
        [self.userTableView.mj_header beginRefreshing];
    }
}

#pragma mark - 控制器的销毁
- (void)dealloc
{
    [self.manager.operationQueue cancelAllOperations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
