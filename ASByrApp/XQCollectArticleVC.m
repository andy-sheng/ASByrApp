//
//  XQCollectArticleVC.m
//  ASByrApp
//
//  Created by lxq on 16/5/8.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQCollectArticleVC.h"
#import "XQCollectiArticleCell.h"
#import "XQCFrameLayout.h"
@interface XQCollectArticleVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSMutableArray * arrayList;
@end

@implementation XQCollectArticleVC

static NSString * const reuseIdentifier = @"Cell";
- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout{
    if (self=[super initWithCollectionViewLayout:layout]) {
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        [self.view addSubview:collectionView];
        self.collectionView = collectionView;
        [self.collectionView registerClass:[XQCollectiArticleCell class] forCellWithReuseIdentifier:reuseIdentifier];
        //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //XQCFrameLayout *  layout = [[XQCFrameLayout alloc]init];
    
    //UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    //[self.view addSubview:collectionView];
    //self.collectionView = collectionView;
    //[collectionView registerClass:[XQCollectiArticleCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addCollectArticle:) name:@"addNewCollectedArticle" object:nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma private method

- (void)addCollectArticle:(NSNotification *)notis{
    [self.arrayList addObject:notis.userInfo];
    [self.collectionView reloadData];
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    XQCollectiArticleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[XQCollectiArticleCell alloc]initWithFrame:CGRectZero];
    }
    /*
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell ==nil) {
        cell = [[XQCollectiArticleCell alloc]initWithFrame:CGRectZero];
    }
    cell.backgroundColor =[UIColor redColor];
    // Configure the cell
    */
    //if ([self.arrayList count]==0) {
    NSLog(@"%@",self.arrayList);
    cell.titleLabel.text =[@"北京冬季奥运会北京冬季奥运会北京冬季奥运会北京冬季奥运会北京冬季奥运会" copy];
    cell.contentLabel.text=[@"北京夏天奥运会北京夏天奥运会北京夏天奥运会北京夏天奥运会北京夏天奥运会" copy];
    //}else{
    //  cell.titleLabel.text = self.arrayList[indexPath.row][@"title"];
    // cell.contentLabel.text = self.arrayList[indexPath.row][@"content"];
    //}
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
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
- (NSMutableArray *)arrayList{
    if (!_arrayList) {
        _arrayList = [NSMutableArray array];
    }
    return _arrayList;
}
@end
