//
//  BSRecommendTagsViewController.m
//  百思不得姐
//
//  Created by WCF on 2017/7/24.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import "BSRecommendTagsViewController.h"
#import "BSRecommendTags.h"
#import "BSRecommendTagsCell.h"

@interface BSRecommendTagsViewController ()
@property (nonatomic,strong) NSArray *tagsArr;
@end

static NSString * const BSTagsId = @"tag";

@implementation BSRecommendTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];

    [self loadTags];
    
}

- (void)loadTags
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";

    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        self.tagsArr = [BSRecommendTags mj_objectArrayWithKeyValuesArray:responseObject];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载标签数据失败"];
    }];
}

- (void)setupTableView
{
    self.navigationItem.title = @"推荐标签";

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSRecommendTagsCell class]) bundle:nil] forCellReuseIdentifier:BSTagsId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 70;
    self.tableView.backgroundColor = BSGlobalBg;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tagsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BSRecommendTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:BSTagsId forIndexPath:indexPath];
    cell.recommendTag = self.tagsArr[indexPath.row];
    return cell;
}

@end
