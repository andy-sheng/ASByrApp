//
//  XQCFrameLayout.h
//  ASByrApp
//
//  Created by lxq on 16/5/9.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef CGFloat(^HeightBlock)(NSIndexPath *indexPath , CGFloat width);
@interface XQCFrameLayout : UICollectionViewLayout
@property (assign, nonatomic) NSInteger lineNumber;
@property (assign, nonatomic) CGFloat rowSpacing;
@property (assign, nonatomic) CGFloat lineSpacing;
@property (assign, nonatomic) UIEdgeInsets sectionInset;
- (void)computeIndexCellHeightWithWidthBlock:(CGFloat(^)(NSIndexPath *indexPath , CGFloat width))block;
@end
