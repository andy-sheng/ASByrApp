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
            CGFloat tempWidth;
            /*
            switch (indexPath.row%6) {
                case 0:
                    tempWidth=100;
                    break;
                case 1:
                    tempWidth=50;
                    break;
                case 2:
                    tempWidth=70;
                    break;
                case 3:
                    tempWidth=40;
                    break;
                case 4:
                    tempWidth=80;
                    break;
                case 5:
                    tempWidth=130;
                    break;
                default:
                    break;
            }
             */
            tempWidth = 120;
            return tempWidth;
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
    return CGSizeMake(self.collectionView.bounds.size.width, [_dicOfHeight[maxHeightline] floatValue]+self.sectionInset.bottom);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes * attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat itemW = (self.collectionView.bounds.size.width-self.sectionInset.left-self.sectionInset.right-(self.lineNumber-1)*self.lineSpacing)/self.lineNumber;
    CGFloat itemH ;
    NSLog(@"%ld",(long)indexPath.row);
    if (self.block!=nil) {
        itemH = self.block(indexPath, itemW);
    }else{
        NSAssert(itemH!=0, @"Please implement block method.");
    }
    
    CGRect frame;
    frame.size = CGSizeMake(itemW, itemH);
    
    __block NSString * lineMinHeight = @"0";
    [_dicOfHeight enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([_dicOfHeight[lineMinHeight] floatValue]>[obj floatValue]) {
            lineMinHeight = key;
        }
    }];
    
    int line = [lineMinHeight intValue];
    
    frame.origin = CGPointMake(self.sectionInset.left+line*(itemW+self.lineSpacing),[_dicOfHeight[lineMinHeight] floatValue]);
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
