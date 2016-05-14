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
#import "XQConstant.h"
#import <AVFoundation/AVFoundation.h>
@interface XQCollectArticleVC ()<UICollectionViewDelegate,UICollectionViewDataSource,XQCLayoutDelegate>

@property (strong, nonatomic) NSMutableArray * arrayList;
@property (strong, nonatomic) NSMutableArray * photos;

@end

@implementation XQCollectArticleVC

static NSString * const reuseIdentifier = @"Cell";
- (id)initWithCollectionViewLayout:(XQCFrameLayout *)layout{
    if (self=[super initWithCollectionViewLayout:layout]) {
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        
        self.arrayList = [NSMutableArray array];
        self.photos = [NSMutableArray array];
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
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma private method

- (void)addCollectArticle:(NSNotification *)notis{
    [self.arrayList addObject:notis.userInfo];
    [self.photos addObject:[UIImage imageNamed:notis.userInfo[@"userImage"]]];
    [self writeIntoFile:COLLECTION_FILE articleInfo:notis.userInfo];
}

- (void)writeIntoFile:(NSString *)name articleInfo:(NSDictionary *)articleInfo{
    //NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSLog(@"%@",documentsDirectory);
    
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

#pragma mark <XQCLayoutDelegate>
- (CGFloat)heightForPhoto:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width{
    UIImage * photo = self.photos[indexPath.item];
    //NSLog(@"photos' size: height:%f, width:%f",photo.size.height,photo.size.width);
    CGRect boudingRect = CGRectMake(0, 0, width-2*PADDING_TO_CONTENTVIEW, (width/photo.size.width)*photo.size.height);
    CGRect rect = AVMakeRectWithAspectRatioInsideRect(photo.size, boudingRect);
    return rect.size.height;
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
@end
