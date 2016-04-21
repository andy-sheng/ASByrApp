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
#import "XQBoardView.h"
#import "ASThreadsController.h"
#import "UIColor+Hex.h"

#import <ASByrBoard.h>
#import <ASByrToken.h>

@interface ASArticleListVC()<ASByrBoardResponseDelegate,ASByrBoardResponseReformer>

@property(strong, nonatomic) UINavigationController * sectionListVC;
@property(strong, nonatomic) UIBarButtonItem *addPostBtn;
@property(strong, nonatomic) UIBarButtonItem *sectionListBtn;
@property(strong, nonatomic) NSArray *boardContent;
@property(strong, nonatomic) NSMutableArray *boardList;

@property(retain, nonatomic) XQBoardModel * lastViewBoard;
@property(retain, nonatomic) ASByrBoard * boardApi;
@property(strong,nonatomic) NSString *boardName;

@end
@implementation ASArticleListVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if ([super initWithTitle:@""]) {
        [self updateBarTheme];
        
        self.boardName=@"Travel";
        self.lastViewBoard=[[XQBoardModel alloc ]initWithOnlyName:self.boardName];
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 100.0;
        
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        [self.tableView registerNib:[UINib nibWithNibName:@"XQBoardView" bundle:nil] forCellReuseIdentifier:@"testBoard"];
        
        [self loadIfNotLoaded];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:[self.lastViewBoard getColor]]];
    self.boardApi = [[ASByrBoard alloc] initWithAccessToken:[ASByrToken shareInstance].accessToken];
    self.boardApi.responseDelegate = self;
    self.navigationItem.title = @"海天游踪";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    XQBoardView *cell = (XQBoardView*)[tableView dequeueReusableCellWithIdentifier:@"testBoard"];
    [cell setupWithface:self.boardList[indexPath.row][@"user"][@"face"]
                    uid:self.boardList[indexPath.row][@"user"][@"uid"]
                  title:self.boardList[indexPath.row][@"title"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ASThreadsController *threadsVC = [[ASThreadsController alloc] initWithWithBoard:[self.lastViewBoard getName]aid:self.boardList[indexPath.row][@"aid"]];
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
    [self.tableView.mj_header beginRefreshing];
    NSLog(@"%@",self.boardName);
    [self.boardApi fetchBoardWithReformer:self boardName:self.boardName];
    [self.tableView.mj_header endRefreshing];
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
                NSLog(@"%@",reformedArticle[@"title"]);
                reformedArticle[@"aid"]     = article[@"id"];
                reformedArticle[@"isTop"] = article[@"is_top"];
                reformedArticle[@"board"]   = article[@"board_name"];
                reformedArticle[@"replyCount"] = article[@"reply_count"];
                if ([article objectForKey:@"user"] != nil) {
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
    return response;
}
@end
