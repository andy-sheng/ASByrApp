//
//  XQCollectArticleTVC.m
//  ASByrApp
//
//  Created by lixiangqian on 17/2/14.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQCollectArticleTVC.h"
#import "ASThreadsController.h"
#import "XQCollectDataCenter.h"
#import "XQCollectArticleTCell.h"
#import "XQUserInfo.h"

#import <ASByrCollection.h>
#import <ASByrToken.h>
#import <XQByrUser.h>
#import <XQByrArticle.h>
#import <XQByrCollection.h>

#import <YYModel/YYModel.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface XQCollectArticleTVC ()<UITableViewDelegate, UITableViewDataSource, ASByrCollectionResponseDelegate, ASByrCollectionResponseReformer>

@property (strong, nonatomic) NSMutableArray * arrayList;
@property (strong, nonatomic) XQCollectDataCenter * collectDataCenter;
@property (strong, nonatomic) ASByrCollection * collectionApi;

@end

@implementation XQCollectArticleTVC

static NSString * const reuseIdentifier = @"collectCell";

- (instancetype)init{
    self = [super init];
    if (self) {
        self.collectDataCenter = [[XQCollectDataCenter alloc]init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addCollectArticle:) name:@"addNewCollectedArticle" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCollectArticle:) name:@"updateCollectedArticle" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteCollectArticle:) name:@"deleteCollectedArticle" object:nil];
        [self.tableView registerClass:[XQCollectArticleTCell class] forCellReuseIdentifier:reuseIdentifier];

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
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.collectionApi = [[ASByrCollection alloc]initWithAccessToken:[ASByrToken shareInstance].accessToken];
    self.collectionApi.responseDelegate = self;
    self.collectionApi.responseReformer = self;
    
    [self fentchCollections];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSString * firstImageUrl = [self.arrayList[indexPath.row] objectForKey:@"firstImageUrl"];
    if(firstImageUrl &&![firstImageUrl isEqual:@""]){
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?oauth_token=%@",firstImageUrl,[ASByrToken shareInstance].accessToken]];
        [cell.firstImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:XQCOLLECTION_FIRST_IMAGE] options:SDWebImageRefreshCached];
    }else{
        [cell.firstImageView setImage:[UIImage imageNamed:XQCOLLECTION_FIRST_IMAGE]];
    }
    
    NSString * profileImageUrl = [self.arrayList[indexPath.row] objectForKey:@"face_url"];
    if(profileImageUrl && ![profileImageUrl isEqual:@""]){
        [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:profileImageUrl] placeholderImage:[UIImage imageNamed:XQCOLLECTION_PROFILE_IMAGE] options:SDWebImageRefreshCached];
    }

    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ASThreadsController * threadsVC = [[ASThreadsController alloc]initWithWithBoard:[self.arrayList[indexPath.row] objectForKey:@"bname"] aid:[[self.arrayList[indexPath.row] objectForKey:@"gid" ]integerValue]];
    [self.navigationController pushViewController:threadsVC animated:YES];
}

#pragma mark private method

- (void)fentchCollections{
    //每次登录时取数据
    //if ([XQUserInfo sharedXQUserInfo].firstLogin != TRUE) {
        [_collectDataCenter deleteAllCollectDataWithBlock:nil];
        [_collectionApi fetchCollectionsWithCount:30 page:1];
//    }else{
//        [self fentchCollectionsFromLocalWithFilters:nil];
//    }
}

- (void)fentchCollectionsFromLocalWithFilters:(NSDictionary *)filters{
    __weak typeof(self) _self = self;
    [_collectDataCenter fetchCollectListFromLocal:filters withBlock:^(NSArray * _Nullable objects) {
        __strong typeof(_self) self = _self;
        [self.arrayList setArray:objects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)addCollectArticle:(NSNotification *)notis{
    NSLog(@"添加通知激活！");
    XQByrArticle * article = notis.userInfo[@"article"];
    [self.collectionApi addCollectionWithBoard:article.board_name aid:[NSString stringWithFormat:@"%ld",(long)article.group_id] successBlock:^(NSInteger statusCode, id response) {
        NSLog(@"添加收藏请求成功");
    } failureBlock:^(NSInteger statusCode, id response) {
        NSLog(@"添加收藏请求失败");
    }];
    [self.collectDataCenter addCollectData:article withBlock:nil];
}

- (void)updateCollectArticle:(NSNotification *)notis{
    NSLog(@"更新通知激活！");
    XQByrArticle * article = notis.userInfo[@"article"];
    [self.collectDataCenter updateCollectFromArticle:article withBlock:nil];
}

- (void)deleteCollectArticle:(NSNotification *)notis{
    NSLog(@"删除通知激活！");
    XQByrArticle * article = notis.userInfo[@"article"];
    [self.collectionApi deleteCollectionWithAid:[NSString stringWithFormat:@"%ld",(long)article.group_id] successBlock:^(NSInteger statusCode, id response) {
        NSLog(@"删除收藏请求成功.");
        [self.collectDataCenter deleteCollectData:[NSString stringWithFormat:@"%ld",(long)article.group_id] withBlock:nil];
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
        [_collectionApi fetchCollectionsWithCount:30 page:(NSInteger)response.response[@"pagination"][@"page_current_count"]+1];
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
    if (!_arrayList) {
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
