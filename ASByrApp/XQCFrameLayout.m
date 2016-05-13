//
//  XQCFrameLayout.m
//  ASByrApp
//
//  Created by lxq on 16/5/9.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQCFrameLayout.h"
#import "XQCLayoutAttributes.h"
#import "XQConstant.h"
@interface XQCFrameLayout()
@property (strong, nonatomic) NSMutableArray * cache;//暂存高度，避免重复计算
@end
@implementation XQCFrameLayout

- (instancetype)init{
    self = [super init];
    if (self) {
        self.lineNumber =2;
        self.rowSpacing = 10.0f;//行
        self.lineSpacing = 10.0f;//列
        self.maxHeight = 0.0f;
        self.sectionInset = UIEdgeInsetsMake(self.rowSpacing/2, self.lineSpacing/2, self.rowSpacing/2, self.lineSpacing/2);
        _cache = [NSMutableArray array];
    }
    return self;
}

- (void)prepareLayout{
    NSLog(@"cache count: %lu",(unsigned long)[_cache count]);
    if ([_cache count]>0)
        
        [_cache removeAllObjects];

        self.cellWidth = self.collectionView.bounds.size.width/self.lineNumber;
    
        NSMutableArray * yOffset=[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:self.rowSpacing/2],[NSNumber numberWithFloat:self.rowSpacing/2], nil];
    
        NSArray * xOffset=[NSArray arrayWithObjects:[NSNumber numberWithFloat:self.lineSpacing/2],[NSNumber numberWithFloat:self.cellWidth],nil];

        NSInteger column =0;
        for (NSInteger item=0; item<[self.collectionView numberOfItemsInSection:0]; item++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
            CGFloat photoHeight = [_delegate heightForPhoto:self.collectionView atIndexPath:indexPath withWidth:self.cellWidth-0.5*self.lineSpacing];
            CGFloat titleHeight = [_delegate heightForTitle:self.collectionView atIndexPath:indexPath withWidth:self.cellWidth-0.5*self.lineSpacing];
            CGFloat boardNameHeight = [_delegate heightForBoardName:self.collectionView atIndexPath:indexPath withWidth:self.cellWidth-0.5*self.lineSpacing];
            
            //非图片区的所有高度，上下与其他cell各间隔self.lineSpacing/2
            CGFloat height = photoHeight+titleHeight+boardNameHeight+DISTRACTOR_HEIGHT+5*PADDING_WITHIN+2*PADDING_TO_CONTENTVIEW+IMAGE_WIDTH;
            
            NSLog(@"cell width: %f",self.cellWidth);
            NSLog(@"other width: %f", self.cellWidth-self.sectionInset.left-self.sectionInset.right);
            NSLog(@"photo height: %f",photoHeight);
            NSLog(@"title height: %f",titleHeight);
            NSLog(@"boardNameHeight: %f",boardNameHeight);
            
            //CGRect frame = CGRectMake([xOffset[column] floatValue], [yOffset[column] floatValue], self.cellWidth-self.lineSpacing-(column/2)*self.lineSpacing, height);
            CGRect frame = CGRectMake([xOffset[column] floatValue], [yOffset[column] floatValue], self.cellWidth-0.5*self.lineSpacing, height);

            //CGRect insetFrame = CGRectInset(frame, self.rowSpacing/2, self.lineSpacing/2);
            
            XQCLayoutAttributes *attributes = [XQCLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.photoHeight = photoHeight;
            attributes.titleHeight = titleHeight;
            attributes.boardNameHeight = boardNameHeight;
            attributes.frame = frame;
            [_cache addObject:attributes];
            
            self.maxHeight = MAX(self.maxHeight, CGRectGetMaxY(frame));
            yOffset[column] =[NSNumber numberWithFloat:[yOffset[column] floatValue]+height];
            
            column = column>=(self.lineNumber-1)?0:++column;
        }
}

- (CGSize)collectionViewContentSize{
    
    CGSize tabBarHeight = [[UIApplication sharedApplication] statusBarFrame].size;
    return CGSizeMake(self.collectionView.bounds.size.width, self.maxHeight+self.sectionInset.bottom+tabBarHeight.height);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray * layoutAttributes = [NSMutableArray array];
    for(XQCLayoutAttributes *attributes in _cache){
        if (CGRectIntersectsRect((CGRect)attributes.frame, rect)){
            [layoutAttributes addObject:attributes];
        }
    }
    return layoutAttributes;
}
@end
