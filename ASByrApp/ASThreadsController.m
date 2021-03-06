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
#import "XQCollectArticleTVC.h"
#import "XQThreadsDetailViewModel.h"
#import "UIAlertController+Extension.h"
#import "ASInputVC.h"

#import "YYModel.h"
#import "XQByrArticle.h"
#import "XQByrUser.h"
#import "XQByrPagination.h"

const NSUInteger kTitleRow = 0;
const NSUInteger kBodyRow  = 1;
const NSUInteger kReplyRow = 2;


@interface ASThreadsController ()<UITableViewDelegate, UITableViewDataSource, ASByrArticleResponseDelegate, ASByrArticleResponseReformer, ASKeyBoardDelegate, ASThreadsTitleCellDelegate,ASThreadsBodyCellDelegate, ASThreadsReplyCellDelegate>

@property(strong, nonatomic) XQWebView * webBodyCell;
@property(strong, nonatomic) UITableView * tableView;
@property(strong, nonatomic) ASKeyboard * keyboard;
@property(strong, nonatomic) MBProgressHUD * hud;
@property(strong, nonatomic) UIBarButtonItem * moreOperBtn;

@property(strong, nonatomic) MBProgressHUD *endHud;
@property(nonatomic, strong) MBProgressHUD *replyStatusHud;

@property(strong, nonatomic) ASByrArticle * articleApi;
@property(copy, nonatomic) NSString * board;
@property(assign, nonatomic) NSUInteger aid;
@property(assign, nonatomic) NSUInteger page;
@property(assign, nonatomic) ASThreadsEnterType threadType;
@property(assign, nonatomic) BOOL isLoadThreads;

@property(strong, nonatomic) NSDictionary * articleData;
@property(strong, nonatomic) NSMutableArray<XQByrArticle*> * replyArticles;
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
        self.articleApi = [[ASByrArticle alloc] initWithAccessToken:[ASByrToken shareInstance].accessToken];
        self.articleApi.responseDelegate = self;
        self.articleApi.responseReformer = self;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.keyboard];
    [self.view setNeedsUpdateConstraints];
    self.navigationItem.title = @"详情";
    
    //more 按钮，added by lxq
    self.moreOperBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more.png"] style:UIBarButtonItemStylePlain target:self action:@selector(moreOperation)];
    self.navigationItem.rightBarButtonItem = self.moreOperBtn;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:XQNotificationWebViewLoaded object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
    [self.tableView.mj_header beginRefreshing];
    NSUInteger length = [self.navigationController.viewControllers count];
    //对于从版面列表进来的文章，设置标题栏的属性 added by lxq
    if([[self.navigationController.viewControllers objectAtIndex:(length-2)] isKindOfClass:[ASArticleListVC class]]){
        self.threadType = ASThreadsEnterTypeNormal;
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }else if([[self.navigationController.viewControllers objectAtIndex:(length-2)] isKindOfClass:[XQCollectArticleTVC class]]){
        self.threadType = ASThreadsEnterTypeCollection;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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

    [self.tableView.mj_footer resetNoMoreData];
    [self.replyArticles removeAllObjects];
    self.page = 1;
    
    [self.articleApi fetchThreadsWithBoard:self.board aid:self.aid page:self.page];
}

- (void)moreData {
    self.isLoadThreads = NO;
    if (self.pagination.page_all_count == self.page) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
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
    
    __weak ASThreadsController * weakself = self;
    UIAlertAction *replyAction = [UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (weakself) {
            //[weakself.navigationController pushViewController:[[ASInputVC alloc] init] animated:YES];
            [weakself.navigationController pushViewController:[[ASInputVC alloc] initWithReplyArticle:self.replyArticles[0]] animated:YES];
        }
    }];
    [alertController addAction:replyAction];
    
    NSString * hudtext;
    NSString * notificationName;
    NSString * collectBtnTitle;
    UIAlertAction * collectAction;
    if (self.threadType == ASThreadsEnterTypeCollection) {
        hudtext = @"已取消收藏";
        collectBtnTitle = NSLocalizedString(@"取消收藏", nil);
        notificationName = @"deleteCollectedArticle";
    } else {
        hudtext = @"已收藏";
        collectBtnTitle = NSLocalizedString(@"收藏文章", nil);
        notificationName = @"addNewCollectedArticle";
    }
    
    NSDictionary* userInfo = @{@"article": self.viewModel.articleEntity};

    
    collectAction = [UIAlertAction actionWithTitle:collectBtnTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:weakself.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"success"]];
        
        hud.labelText = hudtext;
        hud.minShowTime = 2;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud showAnimated:YES whileExecutingBlock:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:notificationName object:nil userInfo:userInfo];
            }];
        });
        
    }];
    
    [alertController addAction:collectAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.keyboard popWithContext:@{@"replyTo":self.replyArticles[indexPath.row + 1]}];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.keyboard hide];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( section == kTitleRow ){
        return _viewModel == nil ? 0 : 1;
    }else if( section == kBodyRow) {
        return 0;
    }else{
        return [self.replyArticles count] - 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == kBodyRow) {
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
    if (section == kBodyRow) {
        return self.webBodyCell.height > 0?self.webBodyCell.height:10;
    }
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kTitleRow) {
        ASThreadsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threadsTitle" forIndexPath:indexPath];
        cell.delegate = self;
        [cell setupWithTitle:_viewModel.title];
        return cell;
    }else if(indexPath.section == kBodyRow){
        ASThreadsBodyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"threadsBody"];
        cell.delegate = self;
        [cell setupWithContent:@""];
        return cell;
    }else{
        ASThreadsReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threadsReply" forIndexPath:indexPath];
        cell.delegate = self;
        [cell setupWithArticle:self.replyArticles[indexPath.row + 1]];
        return cell;
    }
}

#pragma mark - ASKeyBoardDelegate

- (void)sendAcionWithInput:(NSString *)input context:(id)context {
    NSInteger reid = ((XQByrArticle*)context[@"replyTo"]).aid;
    NSLog(@"%ld", reid);
    __weak typeof(self) weakSelf = self;
    [self.articleApi postArticleWithBoard:self.board title:@"" content:input reid:reid successBlock:^(NSInteger statusCode, id response) {
        weakSelf.replyStatusHud.labelText = @"回复成功";
        [weakSelf.replyStatusHud show:YES];
        [weakSelf.replyStatusHud hide:YES afterDelay:1];
    } failureBlock:^(NSInteger statusCode, id response) {
        weakSelf.replyStatusHud.labelText = @"回复失败";
        [weakSelf.replyStatusHud show:YES];
        [weakSelf.replyStatusHud hide:YES afterDelay:1];
    }];
}

- (void)moreAction:(id)context {
    [self.navigationController pushViewController:[[ASInputVC alloc] initWithReplyArticle:context[@"replyTo"] input:context[@"currentInput"]] animated:YES];
}

#pragma mark - ASByrArticleResponseDelegate

- (void)fetchThreadsResponse:(ASByrResponse *)response {
    if (response.isSucceeded) {
        [self.replyArticles addObjectsFromArray:response.reformedData];
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

- (ASByrResponse*)reformThreadsResponse:(ASByrResponse *)response {
    if (response.isSucceeded) {
        NSMutableArray *reformedArticles = [NSMutableArray array];
        
        // 挪出去
        if (_isLoadThreads) {
            [self.viewModel setArticleEntity:[[response.response objectForKey:@"article"] firstObject] replyCount:[XQByrArticle yy_modelWithJSON:response.response].reply_count];
        }
        //更新本地收藏文章的数据库
        if(self.threadType == ASThreadsEnterTypeCollection){
            NSDictionary* userInfo = @{@"article": _viewModel.articleEntity};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateCollectedArticle" object:nil userInfo:userInfo];
        }
        // 挪出去
        
        @autoreleasepool {
            self.pagination = [XQByrPagination yy_modelWithJSON:[response.response objectForKey:@"pagination"]];
            for (id article in [response.response objectForKey:@"article"]) {
                XQByrArticle *tmp = [XQByrArticle yy_modelWithJSON:article];
                [reformedArticles addObject:tmp];
            }
            response.reformedData = [reformedArticles copy];
        }
    }
    return response;
}

#pragma mark - ASThreadsTitleCellDelegate

- (void)linkClicked:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
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
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _tableView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
        footer.automaticallyHidden = YES;
        _tableView.mj_footer = footer;
        
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

- (MBProgressHUD *)replyStatusHud {
    if (_replyStatusHud == nil) {
        _replyStatusHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _replyStatusHud.mode = MBProgressHUDModeText;
    }
    return _replyStatusHud;
}

- (XQWebView *)webBodyCell {
    if (_webBodyCell == nil) {
        _webBodyCell = [[XQWebView alloc]initWithFrame:CGRectMake(0, 0, XQSCREEN_W, 100)];
        _webBodyCell.navigationDelegate = nil;
        _webBodyCell.UIDelegate = nil;
    }
    return _webBodyCell;
}

- (XQThreadsDetailViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[XQThreadsDetailViewModel alloc]init];
    }
    return _viewModel;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
