//
//  ASThreadsVC.m
//  ASByrApp
//
//  Created by andy on 16/4/14.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASThreadsController.h"
#import "ASThreadsTitleCell.h"
//#import "ASThreadsBodyCell.h"
#import "XQThreadsBodyCell.h"
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
const NSUInteger titleRow = 0;
const NSUInteger bodyRow  = 1;
const NSUInteger replyRow = 2;

@interface ASThreadsController ()<UITableViewDelegate, UITableViewDataSource, ASByrArticleResponseDelegate, ASByrArticleResponseReformer, ASKeyBoardDelegate, ASThreadsTitleCellDelegate, ASThreadsReplyCellDelegate, WKNavigationDelegate, WKUIDelegate>

@property(strong, nonatomic) UITableView * tableView;
@property(strong, nonatomic) ASKeyboard * keyboard;
@property(strong, nonatomic) MBProgressHUD * hud;
@property(strong, nonatomic) UIBarButtonItem * moreOperBtn;

@property(strong, nonatomic) ASByrArticle * articleApi;
@property(strong, nonatomic) NSString * board;
@property(assign, nonatomic) NSUInteger aid;
@property(assign, nonatomic) NSUInteger page;
@property(assign, nonatomic) ASThreadsEnterType threadType;
@property(assign, nonatomic) BOOL isLoadThreads;

@property(strong, nonatomic) NSDictionary * articleData;
@property(strong, nonatomic) NSArray * replyArticles;
@property(strong, nonatomic) XQThreadsDetailViewModel * viewModel;
@end

@implementation ASThreadsController{
    NSInteger bodyHeight;
}

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

- (void)moreOperation{
    NSString * addCollectBtnTitle = NSLocalizedString(@"收藏文章", nil);
    NSString * cancelBtnTitle = NSLocalizedString(@"取消", nil);
    NSString * deleteCollectBtnTitle = NSLocalizedString(@"取消收藏", nil);
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"已取消操作.");
    }];
    [alertController addAction:cancelAction];

    if (self.threadType == ASThreadsEnterTypeCollection) {
        UIAlertAction * deleteCollectAction = [UIAlertAction actionWithTitle:deleteCollectBtnTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary* userInfo = @{@"articleID": [NSString stringWithFormat:@"%ld",(long)_viewModel.articleEntity ]};
            
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"success"]];
            
            hud.labelText = @"已取消收藏";
            hud.minShowTime = 2;
            
            [hud showAnimated:YES whileExecutingBlock:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteCollectedArticle" object:nil userInfo:userInfo];
            }];
        }];
        [alertController addAction:deleteCollectAction];
    }else{
        UIAlertAction * addCollectAction = [UIAlertAction actionWithTitle:addCollectBtnTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSDictionary* userInfo = @{@"article": _viewModel.articleEntity};
            
            //[[NSNotificationCenter defaultCenter]postNotificationName:@"addNewCollectedArticle" object:nil userInfo:userInfo];
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"success"]];
            
            hud.labelText = @"已收藏";
            hud.minShowTime = 2;
            
            [hud showAnimated:YES whileExecutingBlock:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"addNewCollectedArticle" object:nil userInfo:userInfo];
            }];
        }];
        [alertController addAction:addCollectAction];
    }
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.replyArticles count] == 0 ? 0 : [self.replyArticles count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == titleRow) {
        ASThreadsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threadsTitle" forIndexPath:indexPath];
        cell.delegate = self;
        [cell setupWithTitle:self.replyArticles[0][@"title"]];
        return cell;
    } else if(indexPath.row == bodyRow) {
        XQThreadsBodyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threadsBody" forIndexPath:indexPath];
        cell.webView.navigationDelegate = self;
        cell.webView.UIDelegate = self;
        [cell.webView loadHTMLString:[_viewModel getContentHtmlString] baseURL:nil];
        return cell;
    } else {
        ASThreadsReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threadsReply" forIndexPath:indexPath];
        cell.delegate = self;
        [cell setupWithFaceurl:self.replyArticles[indexPath.row - 1][@"user"][@"faceurl"]
                           uid:self.replyArticles[indexPath.row - 1][@"user"][@"uid"]
                       content:self.replyArticles[indexPath.row - 1][@"content"]];
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
    //NSLog(@"%@",response.reformedData[0]);
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
    _viewModel = [[XQThreadsDetailViewModel alloc]initWithArticleDic:response.response[@"article"][0]];
    //更新本地收藏文章的数据库
    if(self.threadType == ASThreadsEnterTypeCollection){
        NSDictionary* userInfo = @{@"article": _viewModel.articleEntity};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateCollectedArticle" object:nil userInfo:userInfo];
    }
    //mainarticle setContent:[NSString stringWithFormat:@"%@",[NSArray arraywith]]
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

#pragma mark - ASThreadsTitleCellDelegate

- (void)linkClicked:(NSURL *)url {
    //self.navigationController pushViewController:[UIWebView] animated:<#(BOOL)#>
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - ASThreadsBodyCellDelegate


#pragma mark - ASThreadsReplyCellDelegate


#pragma mark - webview + html

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    XQThreadsBodyCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:bodyRow inSection:0]];
    [cell.contentView addSubview:webView];
    [cell.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(PADDING_TO_CONTENTVIEW);
        make.top.equalTo(cell.contentView.mas_top).offset(PADDING_TO_CONTENTVIEW);
        make.right.equalTo(cell.contentView.mas_right).offset(-PADDING_TO_CONTENTVIEW);
        make.bottom.equalTo(cell.contentView.mas_bottom).offset(-PADDING_TO_CONTENTVIEW);
    }];
    [cell updateConstraints];
    NSLog(@"ooooo");
    NSLog(@"%f",cell.webView.scrollView.contentSize.height);
    [cell.webView evaluateJavaScript:@"document.body.offsetHeight;"completionHandler:^(id _Nullable result,NSError *_Nullable error) {
        NSLog(@"bbbb");
        NSLog(@"%@",result);
//        [cell.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(result);
//        }];
//        [cell updateConstraints];
        //获取页面高度，并重置webview的frame
    }];
}

#pragma mark - getter and setter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50.0;
        [_tableView registerNib:[UINib nibWithNibName:@"ASThreadsTitleCell" bundle:nil] forCellReuseIdentifier:@"threadsTitle"];
        //[_tableView registerNib:[UINib nibWithNibName:@"ASThreadsBodyCell" bundle:nil] forCellReuseIdentifier:@"threadsBody"];
        [_tableView registerNib:[UINib nibWithNibName:@"ASThreadsReplyCell" bundle:nil] forCellReuseIdentifier:@"threadsReply"];
        [_tableView registerClass:[XQThreadsBodyCell class] forCellReuseIdentifier:@"threadsBody"];
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

- (NSUInteger)page {
    return _page++;
}

@end
