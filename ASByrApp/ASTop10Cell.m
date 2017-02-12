//
//  ASTop10Cell.m
//  ASByrApp
//
//  Created by andy on 16/4/6.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASTop10Cell.h"
#import "UIImageView+AFNetworking.h"

@interface UILabel(Border)

- (void)setBorderWithWidth:(CGFloat)width
                     color:(UIColor*)color;

- (void)setRightBorderWithWidth:(CGFloat)width color:(UIColor*)color;

@end

@implementation UILabel(Border)

- (void)setBorderWithWidth:(CGFloat)width color:(UIColor *)color {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

- (void)setRightBorderWithWidth:(CGFloat)width color:(UIColor *)color {
    self.clipsToBounds = YES;
    CALayer *rightBorder = [CALayer layer];
    rightBorder.borderWidth = width;
    rightBorder.borderColor = color.CGColor;
    rightBorder.frame = CGRectMake(-1, -1, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) + 2);
    [self.layer addSublayer:rightBorder];
}
@end

@interface ASTop10Cell() {
    BOOL _drawBorder;
}

@property (weak, nonatomic) IBOutlet UIImageView *faceView;
@property (weak, nonatomic) IBOutlet UILabel *uidLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *idCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;

@property (strong, nonatomic) NSString * faceUrl;
@property (strong, nonatomic) NSString * uid;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * content;

@property (strong, nonatomic) NSAttributedString *userImgStr;
@property (strong, nonatomic) NSAttributedString *commentImgStr;

@end

@implementation ASTop10Cell

#pragma mark - life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _drawBorder = YES;
    NSLog(@"awake");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setup

- (void)setupWithface:(NSString *)faceUrl
                  uid:(NSString *)uid
                title:(NSString *)title
              content:(NSString *)content
                  num:(NSUInteger)num {
    [self.faceView setImageWithURL:[NSURL URLWithString:faceUrl]];
    self.uidLabel.text = uid;
    self.titleLabel.text = title;
    self.contentLabel.text = content;
    self.numLabel.text = [NSString stringWithFormat:@"%ld", num];
}

- (void)setupWithArticle:(XQByrArticle*)article
                     num:(NSUInteger)num{
    [self.faceView setImageWithURL:[NSURL URLWithString:article.user.face_url]];
    self.uidLabel.text = article.user.uid;
    self.titleLabel.text = article.title;
    self.contentLabel.text = article.content;

    NSMutableAttributedString *userCountStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"% ld", article.id_count]];
    [userCountStr insertAttributedString:self.userImgStr atIndex:0];
    self.idCountLabel.attributedText = userCountStr;
    
    NSMutableAttributedString *replyCountStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %ld", article.reply_count]];
    [replyCountStr insertAttributedString:self.commentImgStr atIndex:0];
    self.replyCountLabel.attributedText = replyCountStr;

    self.numLabel.text = [NSString stringWithFormat:@"%ld", num];
    [self.idCountLabel setRightBorderWithWidth:1 color:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1.00]];
    
    [self.replyCountLabel setRightBorderWithWidth:1 color:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1.00]];
//    if (_drawBorder) {
//        NSLog(@"draw");
//        [self.idCountLabel setRightBorderWithWidth:1 color:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1.00]];
//        
//        [self.replyCountLabel setRightBorderWithWidth:1 color:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1.00]];
//        _drawBorder = NO;
//    }
}
#pragma mark - setter and getter


- (NSAttributedString*)userImgStr {
    if (_userImgStr == nil) {
        NSTextAttachment *userImg = [[NSTextAttachment alloc] init];
        userImg.image = [UIImage imageNamed:@"user"];
        userImg.bounds = CGRectMake(0, 0, 10, 10);
        
        _userImgStr = [NSAttributedString attributedStringWithAttachment:userImg];
    }
    return _userImgStr;
}

- (NSAttributedString*)commentImgStr {
    if (_commentImgStr == nil) {
        NSTextAttachment *commentImg = [[NSTextAttachment alloc] init];
        commentImg.image = [UIImage imageNamed:@"comment"];
        commentImg.bounds = CGRectMake(0, 0, 10, 10);
        
        _commentImgStr = [NSAttributedString attributedStringWithAttachment:commentImg];
    }
    return _commentImgStr;
}
@end
