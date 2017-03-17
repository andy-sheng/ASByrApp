//
//  XQCollectArticleTVC.m
//  ASByrApp
//
//  Created by lixiangqian on 17/2/14.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQCollectArticleTVC.h"
#import "ASThreadsController.h"
#import "XQCollectArticleViewModel.h"
#import "XQCollectDataCenter.h"
#import "XQCollectArticleTCell.h"
#import "XQUserInfo.h"

#import <ASByrCollection.h>
#import <ASByrToken.h>
#import <XQByrUser.h>
#import <XQByrArticle.h>
#import <XQByrCollection.h>

#import <YYModel/YYModel.h>
#import <MJRefresh/MJRefresh.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface XQCollectArticleTVC ()<UITableViewDelegate, UITableViewDataSource, ASByrCollectionResponseDelegate, ASByrCollectionResponseReformer>

@property (strong, nonatomic) XQCollectArticleViewModel * viewModel;

@property (strong, nonatomic) NSMutableArray * arrayList;

@end

@implementation XQCollectArticleTVC

static NSString * const reuseIdentifier = @"collectCell";

- (instancetype)init{
    self = [super init];
    if (self) {
        self.viewModel = [[XQCollectArticleViewModel alloc]init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addCollectArticle:) name:@"addNewCollectedArticle" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCollectArticle:) name:@"updateCollectedArticle" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteCollectArticle:) name:@"deleteCollectedArticle" object:nil];
        [self.tableView registerClass:[XQCollectArticleTCell class] forCellReuseIdentifier:reuseIdentifier];
        self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.arrayList removeAllObjects];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)loadData{
    @weakify(self);
    [[self.viewModel.fetchCollectionCommand execute:nil]subscribeNext:^(NSArray *x) {
        @strongify(self);
        [self.arrayList addObjectsFromArray:x];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } completed:^{
        NSLog(@"completed");
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

- (void)moreData{
    @weakify(self);
    [[self.viewModel.fetchCollectionCommand execute:nil]subscribeNext:^(NSArray *x) {
        @strongify(self);
        [self.arrayList addObjectsFromArray:x];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        
    } completed:^{
        NSLog(@"completed");
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 127;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XQCollectArticleTCell *cell = (XQCollectArticleTCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[XQCollectArticleTCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    [cell setUpParameters:self.arrayList[indexPath.row]];
    
    NSString * firstImageUrl = [self.arrayList[indexPath.row] valueForKey:@"firstImageUrl"];
    if(firstImageUrl &&![firstImageUrl isEqual:@""]){
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?oauth_token=%@",firstImageUrl,[ASByrToken shareInstance].accessToken]];
        [cell.firstImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:XQCOLLECTION_FIRST_IMAGE] options:SDWebImageRefreshCached];
    }else{
        [cell.firstImageView setImage:[UIImage imageNamed:XQCOLLECTION_FIRST_IMAGE]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ASThreadsController * threadsVC = [[ASThreadsController alloc]initWithWithBoard:[self.arrayList[indexPath.row] valueForKey:@"bname"] aid:[[self.arrayList[indexPath.row] valueForKey:@"gid" ]integerValue]];
    [self.navigationController pushViewController:threadsVC animated:YES];
}

#pragma mark private method


- (void)addCollectArticle:(NSNotification *)notis{
    NSLog(@"添加通知激活！");
    XQByrArticle * article = notis.userInfo[@"article"];
    [self.viewModel.collectionApi addCollectionWithBoard:article.board_name aid:[NSString stringWithFormat:@"%ld",(long)article.group_id] successBlock:^(NSInteger statusCode, id response) {
        NSLog(@"添加收藏请求成功");
    } failureBlock:^(NSInteger statusCode, id response) {
        NSLog(@"添加收藏请求失败");
    }];
    [self.viewModel.collectDataCenter addCollectData:article withBlock:nil];
}

- (void)updateCollectArticle:(NSNotification *)notis{
    NSLog(@"更新通知激活！");
    XQByrArticle * article = notis.userInfo[@"article"];
    [self.viewModel.collectDataCenter updateCollectFromArticle:article withBlock:nil];
}

- (void)deleteCollectArticle:(NSNotification *)notis{
    NSLog(@"删除通知激活！");
    XQByrArticle * article = notis.userInfo[@"article"];
    [self.viewModel.collectionApi deleteCollectionWithAid:[NSString stringWithFormat:@"%ld",(long)article.group_id] successBlock:^(NSInteger statusCode, id response) {
        NSLog(@"删除收藏请求成功.");
        [self.viewModel.collectDataCenter deleteCollectData:[NSString stringWithFormat:@"%ld",(long)article.group_id] withBlock:nil];
    } failureBlock:^(NSInteger statusCode, id response) {
        NSLog(@"删除收藏请求失败. statusCode:%ld",(long)statusCode);
        
    }];
    
}

#pragma mark ASByrCollectionResponseDelegate
- (void)fentchCollectionsResponse:(ASByrResponse *)response{
    NSArray * array = [NSArray arrayWithArray:response.reformedData];
    [self.arrayList addObjectsFromArray:array];
}

#pragma mark ASByrCollectionResponseReformer
- (ASByrResponse *)reformCollectionResponse:(ASByrResponse *)response{
    NSMutableArray * reformedArticles = [NSMutableArray array];
    for(NSDictionary * article in response.response[@"article"]){
        XQByrCollection * collection = [XQByrCollection yy_modelWithJSON:article];
        [reformedArticles addObject:collection];
    }
    
    if((NSInteger)response.response[@"pagination"][@"page_current_count"] < (NSInteger)response.response[@"pagination"][@"page_all_count"]) {
        [self.viewModel.collectionApi fetchCollectionsWithCount:30 page:(NSInteger)response.response[@"pagination"][@"page_current_count"]+1];
    }else{
        [XQUserInfo sharedXQUserInfo].firstLogin = TRUE;
        [[XQUserInfo sharedXQUserInfo] setDataIntoSandbox];
        [[XQUserInfo sharedXQUserInfo] getDataFromSandbox];
    }
    response.reformedData = reformedArticles;
    return response;
}

#pragma mark getter and setter
- (NSMutableArray *)arrayList{
    if (_arrayList == nil) {
        _arrayList = [NSMutableArray array];
    }
    return _arrayList;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addNewCollectedArticle" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateNewCollectedArticle" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleteCollectedArticle" object:nil];
}

@end
