//
//  ASThreadsTitleCell.m
//  ASByrApp
//
//  Created by andy on 16/4/15.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASThreadsTitleCell.h"

@interface ASThreadsTitleCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ASThreadsTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
