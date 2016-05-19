//
//  ASThreadsBodyCell.m
//  ASByrApp
//
//  Created by andy on 16/4/15.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASThreadsBodyCell.h"
#import "NSAttributedString+ASUBB.h"
#import "TTTAttributedLabel.h"

@interface ASThreadsBodyCell()<TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;

@end

@implementation ASThreadsBodyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.contentLabel.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithContent:(NSString *)content {
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
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    [self.delegate linkClicked:url];
}

@end
