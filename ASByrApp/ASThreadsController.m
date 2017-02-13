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
#import "XQWebView.h"
#import "ASThreadsReplyCell.h"
#import "ASKeyboard.h"
#import "NSAttributedString+ASUBB.h"
#import "ASByrToken.h"
#import "ASByrArticle.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#import "ASArticleListVC.h"
#import "XQCollectArticleVC.h"
#import "XQThreadsDetailViewModel.h"
#import "UIAlertController+Extension.h"

#import "YYModel.h"
#import "XQByrArticle.h"
#import "XQByrUser.h"
#import "XQByrPagination.h"

const NSUInteger titleRow = 0;
const NSUInteger bodyRow  = 1;
const NSUInteger replyRow = 2;

@interface ASThreadsController ()<UITableViewDelegate, UITableViewDataSource, ASByrArticleResponseDelegate, ASByrArticleResponseReformer, ASKeyBoardDelegate, ASThreadsTitleCellDelegate,ASThreadsBodyCellDelegate, ASThreadsReplyCellDelegate, WKNavigationDelegate>

@property(strong, nonatomic) XQWebView * webBodyCell;
@property(strong, nonatomic) UITableView * tableView;
@property(strong, nonatomic) ASKeyboard * keyboard;
@property(strong, nonatomic) MBProgressHUD * hud;
@property(strong, nonatomic) UIBarButtonItem * moreOperBtn;

@property(strong, nonatomic) MBProgressHUD *endHud;

@property(strong, nonatomic) ASByrArticle * articleApi;
@property(strong, nonatomic) NSString * board;
@property(assign, nonatomic) NSUInteger aid;
@property(assign, nonatomic) NSUInteger page;
@property(assign, nonatomic) ASThreadsEnterType threadType;
@property(assign, nonatomic) BOOL isLoadThreads;

@property(strong, nonatomic) NSDictionary * articleData;
@property(strong, nonatomic) NSArray * replyArticles;
@property(strong, nonatomic) XQByrPagination *pagination;
@property(strong, nonatomic) XQThreadsDetailViewModel * viewModel;
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
        self.hidesBottomBarWhenPushed = YES;
        //more 按钮，added by lxq
        self.moreOperBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more.png"] style:UIBarButtonItemStylePlain target:self action:@selector(moreOperation)];
        self.navigationItem.rightBarButtonItem = self.moreOperBtn;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.keyboard];
    [self.view setNeedsUpdateConstraints];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:XQNotificationWebViewLoaded object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:XQNotificationWebViewLoaded object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.articleApi = [[ASByrArticle alloc] initWithAccessToken:[ASByrToken shareInstance].accessToken];
    self.articleApi.responseDelegate = self;
    self.articleApi.responseReformer = self;
    [self.tableView.mj_header beginRefreshing];
    NSUInteger length = [self.navigationController.viewControllers count];
    //对于从版面列表进来的文章，设置标题栏的属性 added by lxq
    if([[self.navigationController.viewControllers objectAtIndex:(length-2)] isKindOfClass:[ASArticleListVC class]]){
        self.threadType = ASThreadsEnterTypeNormal;
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }else if([[self.navigationController.viewControllers objectAtIndex:(length-2)] isKindOfClass:[XQCollectArticleVC class]]){
        self.threadType = ASThreadsEnterTypeCollection;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.trailing.equalTo(self.view.mas_trailing);
        make.bottom.equalTo(self.view.mas_bottom);
        make.leading.equalTo(self.view.mas_leading);
    }];
   
    [super updateViewConstraints];
}

#pragma mark - private function
- (void)refreshData{
    [self.tableView reloadData];
}

- (void)loadData {
    self.isLoadThreads = YES;
    //[self.articleApi fetchArticleWithBoard:self.board aid:self.aid];
    self.page = 1;
    [self.articleApi fetchThreadsWithBoard:self.board aid:self.aid page:self.page];
}

- (void)moreData {
    NSLog(@"%ld", self.page);
    self.isLoadThreads = NO;
    if (self.pagination.page_all_count == self.page) {
        [self.endHud show:YES];
        [self.endHud hide:YES afterDelay:1];
        NSLog(@"nomore");
        return;
    }
    [self.articleApi fetchThreadsWithBoard:self.board aid:self.aid page:++self.page];
}

- (void)moreOperation{
    NSString * cancelBtnTitle = NSLocalizedString(@"取消", nil);
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"已取消操作.");
    }];
    [alertController addAction:cancelAction];
    
    NSString * hudtext;
    NSString * notificationName;
    NSString * collectBtnTitle;
    UIAlertAction * collectAction;
    if (self.threadType == ASThreadsEnterTypeCollection) {
        hudtext = @"已取消收藏";
        collectBtnTitle = NSLocalizedString(@"取消收藏", nil);
        notificationName = @"deleteCollectedArticle";
    }else{
        hudtext = @"已收藏";
        collectBtnTitle = NSLocalizedString(@"收藏文章", nil);
        notificationName = @"addNewCollectedArticle";
    }
    
    collectAction = [UIAlertAction actionWithTitle:collectBtnTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        NSDictionary* userInfo = @{@"article": self.viewModel.articleEntity};
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"success"]];
        
        hud.labelText = hudtext;
        hud.minShowTime = 2;
        
        [hud showAnimated:YES whileExecutingBlock:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:notificationName object:nil userInfo:userInfo];
        }];
    }];
    
    [alertController addAction:collectAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"pop");
    [self.keyboard pop];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == titleRow ){
        return _viewModel == nil ? 0 : 1;
    }else if( section == bodyRow) {
        return 0;
    }else{
        return [self.replyArticles count] == 0 ? 0 : [self.replyArticles count];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == bodyRow) {
        if (_viewModel != nil) {
            NSString * htmlString = [_viewModel getContentHtmlString];
            [_webBodyCell loadHTMLString:htmlString baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"file:///%@/webresource",[[NSBundle mainBundle] bundlePath]]]];
        }else{
            [_webBodyCell loadHTMLString:@"" baseURL:nil];
        }
        return _webBodyCell;
    }
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == bodyRow) {
        return self.webBodyCell.height > 0?self.webBodyCell.height:10;
    }
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == titleRow) {
        ASThreadsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threadsTitle" forIndexPath:indexPath];
        cell.delegate = self;
        [cell setupWithTitle:_viewModel.title];
        return cell;
    }else if(indexPath.section == bodyRow){
        ASThreadsBodyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"threadsBody"];
        cell.delegate = self;
        [cell setupWithContent:@""];
        return cell;
    }else{
        ASThreadsReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threadsReply" forIndexPath:indexPath];
        cell.delegate = self;
        [cell setupWithFaceurl:((XQByrArticle*)self.replyArticles[indexPath.row]).user.face_url
                           uid:((XQByrArticle*)self.replyArticles[indexPath.row]).user.uid
                       content:((XQByrArticle*)self.replyArticles[indexPath.row]).content];
        return cell;
    }
}

#pragma mark - ASKeyBoardDelegate

- (void)sendAcion:(NSString *)text {
    NSLog(@"post:%@", text);
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
    if (response.isSucceeded) {
        if (_isLoadThreads) {
            for (NSInteger i = 1; i < [response.reformedData count]; i++) {
                self.replyArticles = [self.replyArticles arrayByAddingObject:response.reformedData[i]];
            }
        }else{
            self.replyArticles = [self.replyArticles arrayByAddingObjectsFromArray:response.reformedData];
        }
    }else{//访问出错：服务器返回错误信息或网络错误
        [self presentViewController:[UIAlertController alertControllerWithBriefInfo:response.response[@"msg"]] animated:YES completion:nil];
    }
    
    [self.tableView reloadData];
    if (self.isLoadThreads) {
        [self.tableView.mj_header endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - ASByrArticleResponseReformer

- (ASByrResponse*)reformArticleResponse:(ASByrResponse *)response {
    NSLog(@"%@", response);
    XQByrArticle *reformedArticle = [XQByrArticle yy_modelWithJSON:response.response];
    response.reformedData = reformedArticle;
    return response;
}

- (ASByrResponse*)reformThreadsResponse:(ASByrResponse *)response {
    if (response.isSucceeded) {
        NSMutableArray *reformedArticles = [NSMutableArray array];
        if (_isLoadThreads) {
            _viewModel = [[XQThreadsDetailViewModel alloc]initWithArticleDic:[[response.response objectForKey:@"article"] firstObject]];
            _viewModel.articleEntity.reply_count = (NSInteger)[response.response objectForKey:@"reply_count"];
        }
        //更新本地收藏文章的数据库
        if(self.threadType == ASThreadsEnterTypeCollection){
            NSDictionary* userInfo = @{@"article": _viewModel.articleEntity};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateCollectedArticle" object:nil userInfo:userInfo];
        }
        self.pagination = [XQByrPagination yy_modelWithJSON:[response.response objectForKey:@"pagination"]];
        for (id article in [response.response objectForKey:@"article"]) {
            XQByrArticle *tmp = [XQByrArticle yy_modelWithJSON:article];
            [reformedArticles addObject:tmp];
        }
        response.reformedData = reformedArticles;
    }
    return response;
}

#pragma mark - ASThreadsTitleCellDelegate

- (void)linkClicked:(NSURL *)url {
    //self.navigationController pushViewController:[UIWebView] animated:<#(BOOL)#>
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - ASThreadsBodyCellDelegate


#pragma mark - ASThreadsReplyCellDelegate


#pragma mark - WKWebViewNavigationDelegate

#pragma mark - getter and setter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //_tableView.separatorColor = [UIColor whiteColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50.0;
        [_tableView registerNib:[UINib nibWithNibName:@"ASThreadsTitleCell" bundle:nil] forCellReuseIdentifier:@"threadsTitle"];
        [_tableView registerNib:[UINib nibWithNibName:@"ASThreadsBodyCell" bundle:nil] forCellReuseIdentifier:@"threadsBody"];
        [_tableView registerNib:[UINib nibWithNibName:@"ASThreadsReplyCell" bundle:nil] forCellReuseIdentifier:@"threadsReply"];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    }
    return _tableView;
}

- (ASKeyboard *)keyboard {
    if (_keyboard == nil) {
        _keyboard = [[ASKeyboard alloc] init];
        _keyboard.delegate = self;
    }
    return _keyboard;
}

- (MBProgressHUD *)hud {
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode = MBProgressHUDModeAnnularDeterminate;
        _hud.labelText = @"Loading";
    }
    return _hud;
}

- (MBProgressHUD *)endHud {
    if (_endHud == nil) {
        _endHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _endHud.mode = MBProgressHUDModeText;
        _endHud.labelText = @"到底了";
    }
    return _endHud;
}

- (XQWebView *)webBodyCell{
    if (_webBodyCell == nil) {
        _webBodyCell = [[XQWebView alloc]initWithFrame:CGRectMake(0, 0, XQSCREEN_W, 100)];
        _webBodyCell.navigationDelegate = self;
    }
    return _webBodyCell;
}

- (XQThreadsDetailViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[XQThreadsDetailViewModel alloc]initWithArticleDic:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:self.aid],@"group_id",self.board,@"board_name",nil]];
    }
    return _viewModel;
}
@end
