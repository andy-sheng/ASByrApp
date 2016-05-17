//
//  ASThreadsReplyCell.m
//  ASByrApp
//
//  Created by andy on 16/4/15.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASThreadsReplyCell.h"
#import "NSAttributedString+ASUBB.h"
#import <UIImageView+AFNetworking.h>

@interface ASThreadsReplyCell()
@property (weak, nonatomic) IBOutlet UIImageView *faceImage;
@property (weak, nonatomic) IBOutlet UILabel *uidLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ASThreadsReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithFaceurl:(NSString *)faceUrl
                     uid:(NSString *)uid
                 content:(NSString *)content {
    [self.faceImage setImageWithURL:[NSURL URLWithString:faceUrl]];
    self.uidLabel.text = uid;
    self.contentLabel.attributedText = [[NSAttributedString alloc] initWithUBB:content];
}

@end
