//
//  ASThreadsReplyCell.m
//  ASByrApp
//
//  Created by andy on 16/4/15.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASThreadsReplyCell.h"
#import "NSAttributedString+ASUBB.h"
#import "UIImageView+AFNetworking.h"
#import "ASUbbParser.h"
#import <YYLabel.h>

@interface ASThreadsReplyCell()
@property (weak, nonatomic) IBOutlet UIImageView *faceImage;
@property (weak, nonatomic) IBOutlet UILabel *uidLabel;
@property (weak, nonatomic) IBOutlet YYLabel *contentLabel;

@end

@implementation ASThreadsReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.faceImage.layer.masksToBounds = YES;
    self.faceImage.layer.cornerRadius = 15;
    self.faceImage.layer.borderWidth = 1;
    self.faceImage.layer.borderColor = FACE_BORDER_COLOR.CGColor;
    
    ASUbbParser *parser = [[ASUbbParser alloc] init];
    self.contentLabel.textParser = parser;
    
    YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
    modifier.fixedLineHeight = 24;
    //self.contentLabel.linePositionModifier = modifier;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width;
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
    self.contentLabel.text = content;
}


@end
