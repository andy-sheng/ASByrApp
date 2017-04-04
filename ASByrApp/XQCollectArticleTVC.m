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
#import "ASTop10SeperatorCell.h"
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

@property (strong, nonatomic) NSMutableArray * collectionList;

@end

@implementation XQCollectArticleTVC

static NSString * const reuseIdentifier = @"collectCell";

- (instancetype)init{
    self = [super init];
    if (self) {
        self.viewModel = [[XQCollectArticleViewModel alloc]init];
        self.collectionList = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addCollectArticle:) name:@"addNewCollectedArticle" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCollectArticle:) name:@"updateCollectedArticle" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteCollectArticle:) name:@"deleteCollectedArticle" object:nil];
        [self.tableView registerClass:[XQCollectArticleTCell class] forCellReuseIdentifier:reuseIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:@"ASTop10SeperatorCell" bundle:nil] forCellReuseIdentifier:@"ASTop10SeperatorCell"];
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.navigationItem setTitle:@"收藏"];
    [RACObserve(self.viewModel, databaseArrayList) subscribeNext:^(id x) {
        [self updateView];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.collectionList removeAllObjects];
    [self.tableView reloadData];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)loadData{
    self.viewModel.page = 1;
    [self.collectionList removeAllObjects];
}

- (void)moreData{
    if (!self.viewModel.maxPage ||self.viewModel.maxPage == (id)[NSNull null] || self.viewModel.page < [self.viewModel.maxPage integerValue]) {
        self.viewModel.page = [[NSNumber numberWithInteger:self.viewModel.page] integerValue] + 1;
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.viewModel endDatabaseInitialSave];
    }
}

- (void)updateView{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    [self.collectionList addObjectsFromArray:self.viewModel.databaseArrayList];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row % 2 == 0) {
        return 127;
    }else{
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row %2 == 0) {
        XQCollectArticleTCell *cell = (XQCollectArticleTCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[XQCollectArticleTCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        
        [cell setUpParameters:self.collectionList[indexPath.row/2]];
        
        NSString * firstImageUrl = [self.collectionList[indexPath.row/2] valueForKey:@"firstImageUrl"];
        if(firstImageUrl &&![firstImageUrl isEqual:@""]){
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?oauth_token=%@",firstImageUrl,[ASByrToken shareInstance].accessToken]];
            [cell.firstImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:XQCOLLECTION_FIRST_IMAGE] options:SDWebImageRefreshCached];
            
        }else{
            [cell.firstImageView setImage:[UIImage imageNamed:XQCOLLECTION_FIRST_IMAGE]];
        }
        return cell;
    }else{
        ASTop10SeperatorCell *cell = (ASTop10SeperatorCell*)[tableView dequeueReusableCellWithIdentifier:@"ASTop10SeperatorCell"];
        return cell;
    }
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ASThreadsController * threadsVC = [[ASThreadsController alloc]initWithWithBoard:[self.collectionList[indexPath.row/2] valueForKey:@"bname"] aid:[[self.collectionList[indexPath.row/2] valueForKey:@"gid" ]integerValue]];
    [self.navigationController pushViewController:threadsVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.collectionList count]*2 - 1;
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
        
    } failureBlock:^(NSInteger statusCode, id response) {
        NSLog(@"删除收藏请求失败. statusCode:%ld",(long)statusCode);
        
    }];
    [self.viewModel.collectDataCenter deleteCollectData:[NSString stringWithFormat:@"%ld",(long)article.group_id] withBlock:nil];
    
}

#pragma mark getter and setter

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addNewCollectedArticle" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateNewCollectedArticle" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleteCollectedArticle" object:nil];
}

@end
