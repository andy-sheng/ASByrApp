//
//  XQNewBoardViewCell.h
//  ASByrApp
//
//  Created by lxq on 16/5/3.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQNewBoardViewCell : UITableViewCell

@property (strong,nonatomic)UIView *wapView;
@property (strong, nonatomic) UILabel * nameLabel;
@property (strong, nonatomic) UILabel * timeLabel;
@property (strong, nonatomic) UILabel * replyLabel;
@property (strong,nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UIImageView*imView;

+ (XQNewBoardViewCell *)newCellWithIdentifier:(NSString *)identifier andStyle:(UITableViewCellStyle)style andParameters:(NSDictionary *)paramDictionary;

- (void)setUpCellWithParameters:(NSDictionary *)paramDictionary;

@end
