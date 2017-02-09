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
#import "ASUbbParser.h"
#import <YYText.h>
#import <YYTextParser.h>
#import <YYLabel.h>

@interface ASThreadsBodyCell()<TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet YYLabel *contentLabel;

@end

@implementation ASThreadsBodyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    ASUbbParser *parser = [[ASUbbParser alloc] init];
    self.contentLabel.textParser = parser;
    //self.contentLabel.textParser = [[YYTextSimpleMarkdownParser alloc] init];
    
    YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
    modifier.fixedLineHeight = 24;
    //self.contentLabel.linePositionModifier = modifier;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width;
//    self.contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    //self.contentLabel.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithContent:(NSString *)content {
    //NSAttributedString * str = [[NSAttributedString alloc] initWithUBB:content];
    
    self.contentLabel.text = content;
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    [self.delegate linkClicked:url];
}

@end
