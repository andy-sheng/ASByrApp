//
//  ASThreadsVC.m
//  ASByrApp
//
//  Created by andy on 16/4/14.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASThreadsController.h"
#import <ASByrToken.h>
#import <ASByrArticle.h>
#import <MJRefresh.h>

@interface ASThreadsController ()<ASByrArticleResponseDelegate, ASByrArticleResponseReformer>

@property(strong, nonatomic) ASByrArticle * articleApi;
@property(strong, nonatomic) NSString * board;
@property(assign, nonatomic) NSUInteger aid;
@property(assign, nonatomic) NSUInteger page;

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
    [self.articleApi fetchThreadsWithBoard:self.board aid:self.aid];
}

- (void)moreData {
    [self.articleApi fetchThreadsWithBoard:self.board aid:self.aid page:self.page];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"" forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

#pragma mark - ASByrArticleResponseDelegate

- (void)fetchThreadsResponse:(ASByrResponse *)response {
    NSLog(@"%@", response);
}

#pragma mark - ASByrArticleResponseReformer

- (ASByrResponse*)reformThreadsResponse:(ASByrResponse *)response {
    
    return response;
}

#pragma mark - getter and setter

- (NSUInteger)page {
    return _page++;
}

@end
