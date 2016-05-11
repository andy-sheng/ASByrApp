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
@interface XQCollectArticleVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) NSMutableArray * arrayList;
@property (strong, nonatomic) XQCFrameLayout * layout;
@end

@implementation XQCollectArticleVC

static NSString * const reuseIdentifier = @"NewNewCell";
- (id)initWithCollectionViewLayout:(XQCFrameLayout *)layout{
    if (self=[super initWithCollectionViewLayout:layout]) {
        self.layout = layout;
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
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
    self.collectionView.backgroundColor=[UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addCollectArticle:) name:@"addNewCollectedArticle" object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.collectionView.backgroundColor = [UIColor whiteColor];

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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //self.layout.cellWidth = (self.collectionView.frame.size.width-self.layout.sectionInset.left-self.layout.sectionInset.right-(self.layout.lineNumber-1)*self.layout.lineSpacing)/self.layout.lineNumber;
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"top10.png",@"firstImage",@"北京北京",@"title",@"情感天空",@"boardName",@"top10.png",@"userImage",@"top10",@"userName",@"100",@"replyCount",@"44",@"firstImageWidth",@"44",@"firstImageHeight", @192,@"layoutAttri",nil];
    XQCollectiArticleCell *cell = (XQCollectiArticleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[XQCollectiArticleCell alloc]newCellWithFrame:CGRectZero andParameters:dict];
    }else{
        [cell setUpFaceWithDictionary:dict];
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
    //cell.titleLabel.text =[@"北京冬季奥运会北京冬季奥运会北京冬季奥运会北京冬季奥运会北京冬季奥运会" copy];
    //cell.contentLabel.text=[@"北京夏天奥运会北京夏天奥运会北京夏天奥运会北京夏天奥运会北京夏天奥运会" copy];
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
