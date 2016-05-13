//
//  XQCollectiArticleCell.h
//  ASByrApp
//
//  Created by lxq on 16/5/8.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQCollectiArticleCell : UICollectionViewCell

@property (strong, nonatomic) UIView * wapView;
@property (strong, nonatomic) UIView * wapUpView;
@property (strong, nonatomic) UIView * wapDownView;
@property (strong, nonatomic) UIView * distractorLine;

@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * boardNameLabel;
@property (strong, nonatomic) UIImageView * firstImageView;
@property (strong, nonatomic) UIImageView * userImageView;
@property (strong, nonatomic) UILabel * userNameLabel;
@property (strong, nonatomic) UILabel * replyCount;

- (id)newCellWithFrame:(CGRect)frame andParameters:(NSDictionary *)parameters;
- (void)setUpFaceWithDictionary:(NSDictionary *)dict;

@end
