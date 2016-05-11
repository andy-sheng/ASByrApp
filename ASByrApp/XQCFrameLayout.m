//
//  XQCFrameLayout.m
//  ASByrApp
//
//  Created by lxq on 16/5/9.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQCFrameLayout.h"
@interface XQCFrameLayout()
@property (strong, nonatomic)NSMutableDictionary *  dicOfHeight;
@property (strong, nonatomic)NSMutableArray * array;
@property (copy, nonatomic) HeightBlock block;
@end
@implementation XQCFrameLayout

- (instancetype)init{
    self = [super init];
    if (self) {
        self.lineNumber =2;
        self.rowSpacing = 10.0f;
        self.lineSpacing = 10.0f;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _dicOfHeight = [NSMutableDictionary dictionary];
        _array = [NSMutableArray array];
        self.block = ^(NSIndexPath *indexPath , CGFloat width){
            CGFloat tempHeight;
            tempHeight= 120;
            return tempHeight;
        };
    }
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i=0; i<self.lineNumber; i++) {
        [_dicOfHeight setObject:@(self.sectionInset.top) forKey:[NSString stringWithFormat:@"%ld",i]];
    }
    
    for (NSInteger i=0; i<count; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [_array addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
    
}

- (CGSize)collectionViewContentSize{
    __block NSString * maxHeightline = @"0";

    [_dicOfHeight enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([_dicOfHeight[maxHeightline] floatValue] < [obj floatValue]) {
            maxHeightline = key;
        }
    }];
    
    CGSize tabBarHeight = [[UIApplication sharedApplication] statusBarFrame].size;
    return CGSizeMake(self.collectionView.bounds.size.width, [_dicOfHeight[maxHeightline] floatValue]+self.sectionInset.bottom+tabBarHeight.height
                      +self.block(0, 0));
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes * attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    self.cellWidth = (self.collectionView.bounds.size.width-self.sectionInset.left-self.sectionInset.right-(self.lineNumber-1)*self.lineSpacing)/self.lineNumber;
    CGFloat itemH ;
    if (self.block!=nil) {
        itemH = self.block(indexPath, self.cellWidth);
    }else
        NSAssert(itemH!=0, @"Please implement block method.");
    
    CGRect frame;
    frame.size = CGSizeMake(self.cellWidth, itemH);
    
    NSInteger line = indexPath.row%2;
    
    NSString *heightKey = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    _dicOfHeight[heightKey] = [NSString stringWithFormat:@"%f",(indexPath.row/2)*(itemH+self.lineSpacing)+self.lineSpacing];
    
    frame.origin = CGPointMake(self.sectionInset.left+line*(self.cellWidth+self.lineSpacing),[_dicOfHeight[heightKey] floatValue]);
    attr.frame=frame;
    
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _array;
}

- (void)computeIndexCellHeightWithWidthBlock:(CGFloat (^)(NSIndexPath *, CGFloat))block{
    if (self.block!=block) {
        self.block=block;
    }
}
@end
