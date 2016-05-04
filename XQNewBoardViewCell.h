//
//  XQNewBoardViewCell.h
//  ASByrApp
//
//  Created by lxq on 16/5/3.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQNewBoardViewCell : UITableViewCell
@property (strong, nonatomic) UILabel * nameLabel;
@property (strong, nonatomic) UILabel * timeLabel;
@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UILabel * replyLabel;
+ (XQNewBoardViewCell *)newCellWithIdentifier:(NSString *) identifier andParameters:(NSDictionary *)paramDictionary;
@end
