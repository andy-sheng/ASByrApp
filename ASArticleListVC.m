//
//  ASArticleListVC.m
//  ASByrApp
//
//  Created by andy on 16/4/18.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASArticleListVC.h"
#import "ASSectionListVC.h"
#import "XQBoardModel.h"
//#import "XQBoardView.h"
#import "XQNewBoardViewCell.h"
#import "ASThreadsController.h"
#import "UIColor+Hex.h"

#import <ASByrBoard.h>
#import <ASByrToken.h>

@interface ASArticleListVC()<ASByrBoardResponseDelegate,ASByrBoardResponseReformer>

@property(strong, nonatomic) UINavigationController * sectionListVC;
@property(strong, nonatomic) UIBarButtonItem *addPostBtn;
@property(strong, nonatomic) UIBarButtonItem *sectionListBtn;
@property(strong, nonatomic) NSMutableArray *boardList;

@property(strong, nonatomic) XQBoardModel * lastViewBoard;
@property(strong, nonatomic) ASByrBoard * boardApi;
@property(copy, nonatomic) NSString *boardName;

@end
@implementation ASArticleListVC

- (instancetype)init {
    self = [super initWithTitle:@"海天游踪"];
    if (self) {
        self.boardName=@"Travel";
    }
    return self;
}

- (instancetype)initWithNameAndTitle:(NSString *)boardName boardTitle:(NSString *)title{
    self = [super initWithTitle:title];
    if (self) {
        self.boardName=[boardName copy];
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView registerNib:[UINib nibWithNibName:@"XQBoardView" bundle:nil] forCellReuseIdentifier:@"testBoard"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshBoardData:) name:@"chooseBoardFromAllSection" object:nil];
    self.lastViewBoard=[[XQBoardModel alloc ]initWithOnlyName:self.boardName];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:[self.lastViewBoard getColor]]];
    self.boardApi = [[ASByrBoard alloc] initWithAccessToken:[ASByrToken shareInstance].accessToken];
    self.boardApi.responseDelegate = self;
    [self updateBarTheme];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [super loadIfNotLoaded];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshBoardData:(NSNotification *)notis{
    NSDictionary *dict = notis.userInfo;
    self.boardName = [[dict objectForKey:@"boardName"] copy];
    self.navigationItem.title = [[dict objectForKey:@"boardDescription"] copy];
    self.isLoaded=false;
    self.lastViewBoard=[[XQBoardModel alloc ]initWithOnlyName:self.boardName];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:[self.lastViewBoard getColor]]];
    [super loadIfNotLoaded];
}

- (void) addPost {
    NSLog(@"add");
}

- (void)listSection {
    if (self.sectionListVC == nil) {
        self.sectionListVC = [[UINavigationController alloc] initWithRootViewController:[[ASSectionListVC alloc] init]];;
    }
    [self presentViewController:self.sectionListVC animated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {return UIStatusBarStyleLightContent;}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.boardList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //XQBoardView *cell = (XQBoardView*)[tableView dequeueReusableCellWithIdentifier:@"testBoard"];
    //[cell setupWithface:self.boardList[indexPath.row][@"user"][@"face"]
                    //uid:self.boardList[indexPath.row][@"user"][@"uid"]
                  //title:self.boardList[indexPath.row][@"title"]];
    XQNewBoardViewCell *cell = [XQNewBoardViewCell newCellWithIdentifier:@"testBoard" andParameters:self.boardList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ASThreadsController *threadsVC = [[ASThreadsController alloc] initWithWithBoard:[self.lastViewBoard getName]
                                                                                aid:[self.boardList[indexPath.row][@"aid"] integerValue]];
    [self.navigationController pushViewController:threadsVC animated:YES];
}

- (void) updateBarTheme{
    //设置按钮和标题为白色
    [[UIBarButtonItem appearance]setTintColor:[UIColor whiteColor]];
    
    self.addPostBtn = [[UIBarButtonItem alloc] initWithTitle:@"发帖" style:UIBarButtonItemStyleDone target:self action:@selector(addPost)];
    self.addPostBtn.image = [UIImage imageNamed:@"edit"];
    self.navigationItem.leftBarButtonItem = self.addPostBtn;
    
    self.sectionListBtn = [[UIBarButtonItem alloc] initWithTitle:@"版面" style:UIBarButtonItemStylePlain target:self action:@selector(listSection)];
    self.sectionListBtn.image = [UIImage imageNamed:@"list2"];
    self.navigationItem.rightBarButtonItem = self.sectionListBtn;
    
    //设置状态栏为白色
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
}

#pragma 继承方法
- (void)loadData {
    [super loadData];
    //[self.tableView.mj_header beginRefreshing];
    NSLog(@"%@",self.boardName);
    [self.boardApi fetchBoardWithReformer:self boardName:self.boardName];
    //[self.tableView.mj_header endRefreshing];
}

- (void)moreData {
    [super moreData];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}


#pragma mark - ASByrBoardResponseDelegate
- (void)fetchBoardResponse:(ASByrResponse *)response{
    [self commenResponseRecv:response];
}

- (void)commenResponseRecv:(ASByrResponse *)response{
    self.boardList = response.reformedData;
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - ASByrBoardResponseReformer
- (ASByrResponse *)reformBoardResponse:(ASByrResponse *)response{
    return [self commenReformer:response];
}

- (ASByrResponse *)commenReformer:(ASByrResponse *)response{
    if (response.statusCode >= 200 && response.statusCode < 300) {
        NSMutableArray * reformedData = [[NSMutableArray alloc] init];
        [self.lastViewBoard setDescrip:response.response[@"description"]];
        for (NSDictionary* article in response.response[@"article"]) {
            NSMutableDictionary * reformedArticle = [[NSMutableDictionary alloc] init];
            reformedArticle[@"title"]   = article[@"title"];
            reformedArticle[@"aid"]     = article[@"id"];
            reformedArticle[@"isTop"] = article[@"is_top"];
            //reformedArticle[@"board"]   = article[@"board_name"];
            reformedArticle[@"postTime"] = article[@"post_time"];
            reformedArticle[@"replyCount"] = article[@"reply_count"];
            //reformedArticle[@"imageW"] = article[@"face_width"];
            //reformedArticle[@"imageH"] = article[@"face_height"];
            if (![[article objectForKey:@"user"] isEqual:[NSNull null]]&&[article objectForKey:@"user"]!=nil
                                                                        &&article[@"user"][@"face_url"]!=nil
                                                                        &&article[@"user"][@"id"]!=nil) {
                reformedArticle[@"user"]    = @{@"face": article[@"user"][@"face_url"],
                                                    @"uid": article[@"user"][@"id"]};
            } else {
                reformedArticle[@"user"]    = @{@"face": @"",
                                                    @"uid": @"unknown" };
            }
            [reformedData addObject:reformedArticle];
        }
        response.reformedData = [reformedData copy];
        response.isSucceeded = YES;
    } else {
        response.isSucceeded = NO;
    }
    [self.tableView.mj_header endRefreshing];
    return response;
}
@end
