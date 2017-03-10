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
#import <XQByrUser.h>
#import <XQByrArticle.h>
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

- (void)setupWithArticle:(XQByrArticle*) article {
    [self.faceImage setImageWithURL:[NSURL URLWithString:article.user.face_url]];
    self.uidLabel.text = article.user.uid;
    self.contentLabel.text = article.content;
    NSLog(@"%ld", article.aid);
    NSLog(@"%@", article.board_name);
    ASUbbParser *parser = [[ASUbbParser alloc] init];
    parser.attachment = article.attachment;
    self.contentLabel.textParser = parser;
}


@end
