//
//  ASThreadsBodyCell.m
//  ASByrApp
//
//  Created by andy on 16/4/15.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASThreadsBodyCell.h"
#import "NSAttributedString+ASUBB.h"

@interface ASThreadsBodyCell()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ASThreadsBodyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithContent:(NSString *)content {
    self.contentLabel.attributedText = [[NSAttributedString alloc] initWithUBB:content];
}

@end
