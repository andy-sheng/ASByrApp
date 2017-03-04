//
//  XQCollectArticleTCell.h
//  ASByrApp
//
//  Created by lixiangqian on 17/2/14.
//  Copyright © 2017年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQCollectArticleTCell : UITableViewCell

@property (strong, nonatomic) UIView *wapUpView;
@property (strong, nonatomic) UIView *wapDownView;
@property (strong, nonatomic) UIView *wapView;

@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * boardNameLabel;
@property (strong, nonatomic) UIImageView * firstImageView;
@property (strong, nonatomic) UIImageView * userImageView;
@property (strong, nonatomic) UILabel * userNameLabel;
@property (strong, nonatomic) UILabel * replyCount;

- (void)setUpParameters:(NSDictionary *)parameters;
@end
