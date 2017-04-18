//
//  ASThreadsTitleCell.m
//  ASByrApp
//
//  Created by andy on 16/4/15.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASThreadsTitleCell.h"
#import "NSAttributedString+ASUBB.h"

@interface ASThreadsTitleCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ASThreadsTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithTitle:(NSString *)title {
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithUBB:title];
}

@end
