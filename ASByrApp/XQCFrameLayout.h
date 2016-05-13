//
//  XQCFrameLayout.h
//  ASByrApp
//
//  Created by lxq on 16/5/9.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XQCLayoutDelegate

- (CGFloat)heightForPhoto:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width;

- (CGFloat)heightForTitle:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width;

- (CGFloat)heightForBoardName:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width;

@end

typedef CGFloat(^HeightBlock)(NSIndexPath *indexPath , CGFloat width);

@interface XQCFrameLayout : UICollectionViewLayout

@property (assign, nonatomic) CGFloat cellWidth;
@property (assign, nonatomic) CGFloat lineNumber;
@property (assign, nonatomic) CGFloat rowSpacing;
@property (assign, nonatomic) CGFloat lineSpacing;
@property (assign, nonatomic) UIEdgeInsets sectionInset;
@property (assign, nonatomic) CGFloat maxHeight;

@property (weak, nonatomic) id<XQCLayoutDelegate> delegate;

@end
