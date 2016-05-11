//
//  ASTop10SeperatorCell.m
//  ASByrApp
//
//  Created by andy on 16/5/11.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASTop10SeperatorCell.h"

@implementation ASTop10SeperatorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
