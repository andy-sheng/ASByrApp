//
//  XQCollectArticleVC.m
//  ASByrApp
//
//  Created by lxq on 16/5/8.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQCollectArticleVC.h"
#import "ASThreadsController.h"
#import "XQCollectiArticleCell.h"
#import "XQCFrameLayout.h"
#import "XQUserInfo.h"

#import <AVFoundation/AVFoundation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <ASByrToken.h>
#import <ASByrCollection.h>

#import "XQCollectDataCenter.h"
#import <XQByrUser.h>
#import <XQByrArticle.h>
#import <XQByrCollection.h>
#import <YYModel/YYModel.h>
#import <MJRefresh/MJRefresh.h>

@interface XQCollectArticleVC ()<UICollectionViewDelegate,UICollectionViewDataSource,XQCLayoutDelegate,ASByrCollectionResponseDelegate,ASByrCollectionResponseReformer>

@property (strong, nonatomic) NSMutableArray * arrayList;
@property (strong, nonatomic) XQCollectDataCenter * collectDataCenter;
@property (strong, nonatomic) ASByrCollection * collectionApi;

@end

@implementation XQCollectArticleVC

static NSString * const reuseIdentifier = @"Cell";
- (id)initWithCollectionViewLayout:(XQCFrameLayout *)layout{
    if (self=[super initWithCollectionViewLayout:layout]) {
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        
        self.arrayList = [NSMutableArray array];
        self.collectDataCenter = [[XQCollectDataCenter alloc]init];
//        self.collectionView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//        self.collectionView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
        layout.delegate=self;
        
        [self.view addSubview:collectionView];
        self.collectionView = collectionView;
        [self.collectionView registerClass:[XQCollectiArticleCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addCollectArticle:) name:@"addNewCollectedArticle" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCollectArticle:) name:@"updateCollectedArticle" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteCollectArticle:) name:@"deleteCollectedArticle" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionApi = [[ASByrCollection alloc]initWithAccessToken:[ASByrToken shareInstance].accessToken];
    self.collectionApi.responseDelegate = self;
    self.collectionApi.responseReformer = self;
    
    [self.arrayList setArray:[_collectDataCenter fetchCollectListFromLocal:nil]];
    [self.collectionView reloadData];
    
    //每次启动时更新收藏数据库
    [self fentchCollectionsFromInternet:1];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private method

- (void)fentchCollectionsFromInternet:(NSInteger)pagenum{
    //每次登录时取数据
    BOOL x = [XQUserInfo sharedXQUserInfo].firstLogin;
    NSLog(@"收藏文章取数据 %d",x);
    if ([XQUserInfo sharedXQUserInfo].firstLogin != TRUE) {
        [_collectDataCenter deleteAllCollectData];
        [_collectionApi fetchCollectionsWithCount:30 page:pagenum];
    }
}

- (void)addCollectArticle:(NSNotification *)notis{
    NSLog(@"添加通知激活！");
    XQByrArticle * article = notis.userInfo[@"article"];
    [self.collectionApi addCollectionWithBoard:article.board_name aid:[NSString stringWithFormat:@"%ld",(long)article.group_id] successBlock:^(NSInteger statusCode, id response) {
        NSLog(@"添加收藏请求成功");
    } failureBlock:^(NSInteger statusCode, id response) {
        NSLog(@"添加收藏请求失败");
    }];
    [self.collectDataCenter addCollectData:article];
}

- (void)updateCollectArticle:(NSNotification *)notis{
    NSLog(@"更新通知激活！");
    XQByrArticle * article = notis.userInfo[@"article"];
    [self.collectDataCenter updateCollectData:article options:XQCollectionUpdateContent];
}

- (void)deleteCollectArticle:(NSNotification *)notis{
    NSLog(@"删除通知激活！");
    XQByrArticle * article = notis.userInfo[@"article"];
    [self.collectionApi deleteCollectionWithAid:[NSString stringWithFormat:@"%ld",(long)article.group_id] successBlock:^(NSInteger statusCode, id response) {
        NSLog(@"删除收藏请求成功.");
    } failureBlock:^(NSInteger statusCode, id response) {
        NSLog(@"删除收藏请求失败.");
    }];
    [self.collectDataCenter deleteCollectData:[NSString stringWithFormat:@"%ld",(long)article.group_id]];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.arrayList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XQCollectiArticleCell *cell = (XQCollectiArticleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[XQCollectiArticleCell alloc]newCellWithFrame:CGRectZero andParameters:self.arrayList[indexPath.row]];
    }else{
        [cell setUpFaceWithDictionary:self.arrayList[indexPath.row]];
    }
    //return nil if the key doesn't exist
    NSString * firstImageUrl = [self.arrayList[indexPath.row] objectForKey:@"firstImageUrl"];
    if(firstImageUrl &&![firstImageUrl isEqual:@""]){
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?oauth_token=%@",firstImageUrl,[ASByrToken shareInstance].accessToken]];
        [cell.firstImageView sd_setImageWithURL:url];
    }
    NSString * profileImageUrl = [self.arrayList[indexPath.row] objectForKey:@"profileImageUrl"];
    if(profileImageUrl && ![profileImageUrl isEqual:@""]){
        [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:profileImageUrl]placeholderImage:[UIImage imageNamed:XQCOLLECTION_FIRST_IMAGE] options:SDWebImageRefreshCached];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ASThreadsController *threadsVC = [[ASThreadsController alloc] initWithWithBoard:[self.arrayList[indexPath.row] objectForKey:@"boardName"]                                                                                aid:[[self.arrayList[indexPath.row] objectForKey:@"articleID"] integerValue]];
    [self.navigationController pushViewController:threadsVC animated:YES];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	/Users/lxq/Documents/ASByrApp/ASByrApp.xcodeprojreturn YES;
}
*/


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark ASByrCollectionResponseDelegate
- (void)fentchCollectionsResponse:(ASByrResponse *)response{
    NSArray * array = [NSArray arrayWithArray:response.reformedData];
    [_collectDataCenter saveCollectDataFromCollections:array];
    [self.arrayList setArray:[_collectDataCenter fetchCollectListFromLocal:nil]];
    [self.collectionView reloadData];
}

#pragma mark ASByrCollectionResponseReformer
- (ASByrResponse *)reformCollectionResponse:(ASByrResponse *)response{
    NSMutableArray * reformedArticles = [NSMutableArray array];
    for(NSDictionary * article in response.response[@"article"]){
        XQByrCollection * collection = [XQByrCollection yy_modelWithJSON:article];
        [reformedArticles addObject:collection];
    }
    
    if((NSInteger)response.response[@"pagination"][@"page_current_count"] < (NSInteger)response.response[@"pagination"][@"page_all_count"]) {
        [self fentchCollectionsFromInternet:(NSInteger)response.response[@"pagination"][@"page_current_count"]+1];
    }else{
        [XQUserInfo sharedXQUserInfo].firstLogin = TRUE;
        [[XQUserInfo sharedXQUserInfo] setDataIntoSandbox];
        [[XQUserInfo sharedXQUserInfo] getDataFromSandbox];
    }
    response.reformedData = reformedArticles;
    return response;
}

#pragma mark <XQCLayoutDelegate>
- (CGFloat)heightForPhoto:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width{
    NSString * url =[self.arrayList[indexPath.row] objectForKey:@"firstImageUrl"];
    if( url && ![url isEqualToString:@""]){
        //NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?oauth_token=%@",self.arrayList[indexPath.row][@"firstImageUrl"],[ASByrToken shareInstance].accessToken]];
        //    UIImageView * photo = [[UIImageView alloc]init];
        //    [photo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:XQCOLLECTION_FIRST_IMAGE] options:SDWebImageRefreshCached];
        /*
         * 固定图片高度
         */
        UIImage * photo = [UIImage imageNamed:XQCOLLECTION_FIRST_IMAGE];
        CGRect boudingRect = CGRectMake(0, 0, width-2*PADDING_TO_CONTENTVIEW, (width/photo.size.width)*photo.size.height);
        CGRect rect = AVMakeRectWithAspectRatioInsideRect(photo.size, boudingRect);
        return rect.size.height;
        
    }else{
        return 0;
    }
}

- (CGFloat)heightForTitle:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width{
    NSString * title = self.arrayList[indexPath.row][@"title"];
    CGRect heightTitle;
    heightTitle = [title boundingRectWithSize:CGSizeMake(width-2*PADDING_TO_CONTENTVIEW-2*PADDING_WITHIN, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:14]} context:nil];
    return heightTitle.size.height;
}

-(CGFloat)heightForBoardName:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width{
    NSString * boardName = self.arrayList[indexPath.row][@"boardName"];
    CGRect heightBoardName;
    heightBoardName = [boardName boundingRectWithSize:CGSizeMake(width-2*PADDING_TO_CONTENTVIEW-2*PADDING_WITHIN, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:10]} context:nil];
    return heightBoardName.size.height;
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
