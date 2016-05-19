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
#import "TTTAttributedLabel.h"

@interface ASThreadsReplyCell()<TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *faceImage;
@property (weak, nonatomic) IBOutlet UILabel *uidLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;

@end

@implementation ASThreadsReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.contentLabel.delegate = self;
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
    
    NSAttributedString * str = [[NSAttributedString alloc] initWithUBB:content];
    [self.contentLabel setText:str];
    [str enumerateAttribute:NSLinkAttributeName
                    inRange:NSMakeRange(0, str.length)
                    options:NSAttributedStringEnumerationReverse
                 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                     if (value != nil) {
                         [self.contentLabel addLinkToURL:value withRange:range];
                     }
                 }];
    self.contentLabel.attributedText = str;
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    [self.delegate linkClicked:url];
}

@end
