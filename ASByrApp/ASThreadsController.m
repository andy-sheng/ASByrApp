//
//  ASThreadsVC.m
//  ASByrApp
//
//  Created by andy on 16/4/14.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASThreadsController.h"
#import "ASThreadsTitleCell.h"
#import "ASThreadsBodyCell.h"
#import "ASThreadsReplyCell.h"
#import <ASByrToken.h>
#import <ASByrArticle.h>
#import <MJRefresh.h>

const NSUInteger titleRow = 0;
const NSUInteger bodyRow  = 1;
const NSUInteger replyRow = 2;

@interface ASThreadsController ()<ASByrArticleResponseDelegate, ASByrArticleResponseReformer>

@property(strong, nonatomic) ASByrArticle * articleApi;
@property(strong, nonatomic) NSString * board;
@property(assign, nonatomic) NSUInteger aid;
@property(assign, nonatomic) NSUInteger page;
@property(assign, nonatomic) BOOL isLoadThreads;

@property(strong, nonatomic) NSDictionary * articleData;
@property(strong, nonatomic) NSArray * replyArticles;


@end

@implementation ASThreadsController

#pragma mark - life cycle

- (instancetype)initWithWithBoard:(NSString *)board
                              aid:(NSUInteger)aid {
    self = [super init];
    if (self) {
        self.board = board;
        self.aid = aid;
        self.page = 1;
        self.isLoadThreads = YES;
        self.replyArticles = [NSMutableArray array];
        self.navigationItem.title = @"帖子详情";
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 50.0;
        [self.tableView registerNib:[UINib nibWithNibName:@"ASThreadsTitleCell" bundle:nil] forCellReuseIdentifier:@"threadsTitle"];
        [self.tableView registerNib:[UINib nibWithNibName:@"ASThreadsBodyCell" bundle:nil] forCellReuseIdentifier:@"threadsBody"];
        [self.tableView registerNib:[UINib nibWithNibName:@"ASThreadsReplyCell" bundle:nil] forCellReuseIdentifier:@"threadsReply"];
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.articleApi = [[ASByrArticle alloc] initWithAccessToken:[ASByrToken shareInstance].accessToken];
    self.articleApi.responseDelegate = self;
    self.articleApi.responseReformer = self;
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private function

- (void)loadData {
    self.isLoadThreads = YES;
    //[self.articleApi fetchArticleWithBoard:self.board aid:self.aid];
    self.page = 1;
    [self.articleApi fetchThreadsWithBoard:self.board aid:self.aid page:self.page];
}

- (void)moreData {
    self.isLoadThreads = NO;
    [self.articleApi fetchThreadsWithBoard:self.board aid:self.aid page:self.page];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.replyArticles count] == 0 ? 0 : [self.replyArticles count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == titleRow) {
        ASThreadsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threadsTitle" forIndexPath:indexPath];
        [cell setupWithTitle:self.replyArticles[0][@"title"]];
        return cell;
    } else if(indexPath.row == bodyRow) {
        ASThreadsBodyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threadsBody" forIndexPath:indexPath];
        [cell setupWithContent:self.replyArticles[0][@"content"]];
        return cell;
    } else {
        ASThreadsReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threadsReply" forIndexPath:indexPath];
        [cell setupWithFaceurl:self.replyArticles[indexPath.row - 1][@"user"][@"faceurl"]
                           uid:self.replyArticles[indexPath.row - 1][@"user"][@"uid"]
                       content:self.replyArticles[indexPath.row - 1][@"content"]];
        return cell;
    }
}

#pragma mark - ASByrArticleResponseDelegate

- (void)fetchAriticleResponse:(ASByrResponse *)response {
    self.articleData = response.reformedData;
    [self.tableView reloadData];
    if (self.isLoadThreads) {
        [self.tableView.mj_header endRefreshing];
    } else {
        
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)fetchThreadsResponse:(ASByrResponse *)response {
    
    self.replyArticles = [self.replyArticles arrayByAddingObjectsFromArray:response.reformedData];
    [self.tableView reloadData];
    if (self.isLoadThreads) {
        [self.tableView.mj_header endRefreshing];
    } else {
        
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - ASByrArticleResponseReformer

- (ASByrResponse*)reformArticleResponse:(ASByrResponse *)response {
    NSMutableDictionary *reformedArticle = [NSMutableDictionary dictionary];
    reformedArticle[@"title"] = response.response[@"title"];
    reformedArticle[@"content"] = response.response[@"content"];
    response.reformedData = reformedArticle;
    return response;
}

- (ASByrResponse*)reformThreadsResponse:(ASByrResponse *)response {
    NSMutableArray *reformedArticles = [NSMutableArray array];
    for (NSDictionary * article in response.response[@"article"]) {
        NSMutableDictionary * tmp = [NSMutableDictionary dictionary];
        tmp[@"title"] = article[@"title"];
        tmp[@"content"] = article[@"content"];
        tmp[@"user"] = @{@"faceurl":article[@"user"][@"face_url"], @"uid":article[@"user"][@"id"]};
        [reformedArticles addObject:tmp];
    }
    
    response.reformedData = reformedArticles;
    return response;
}

#pragma mark - getter and setter

- (NSUInteger)page {
    return _page++;
}

@end
