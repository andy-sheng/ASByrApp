//
//  XQCollectiArticleCell.m
//  ASByrApp
//
//  Created by lxq on 16/5/8.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQCollectiArticleCell.h"
#import "XQConstant.h"
#import "UIColor+Hex.h"
#import "XQCFrameLayout.h"
#import "XQCLayoutAttributes.h"
#import <Masonry.h>
@interface XQCollectiArticleCell()<NSCopying>
@property (strong, nonatomic) NSDictionary * paramDict;
@end
@implementation XQCollectiArticleCell
- (id)newCellWithFrame:(CGRect)frame andParameters:(NSDictionary *)parameters{
    self.paramDict = [NSDictionary dictionaryWithDictionary:parameters];
    XQCollectiArticleCell *cell = [[XQCollectiArticleCell alloc]initWithFrame:frame];
    [cell setUpFaceWithDictionary:parameters];
    return cell;
}

- (id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //self.contentView.layer.borderWidth = 0.5;
        //self.contentView.layer.borderColor= [UIColor colorWithHexString:IMAGE_BACKCOLOR].CGColor;
        UIView * wapView = [UIView new];
        self.wapView = wapView;
        [self.contentView addSubview:wapView];
        
        self.wapView.layer.borderWidth = 0.5;
        self.wapView.layer.borderColor= [UIColor colorWithHexString:IMAGE_BACKCOLOR].CGColor;
        UIView * wapUpView = [UIView new];
        self.wapUpView = wapUpView;
        [self.wapView addSubview:wapUpView];
        
        UIView * distractorView = [UIView new];
        self.distractorLine = distractorView;
        [self.wapView addSubview:distractorView];
        distractorView.backgroundColor = [UIColor grayColor];
        
        UIView * wapDownView = [UIView new];
        self.wapDownView = wapDownView;
        [self.wapView addSubview:wapDownView];
        
        self.firstImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"santi.jpg"]];
        [self.wapUpView addSubview:self.firstImageView];
        
        UILabel * titleLabel=[UILabel new];
        self.titleLabel = titleLabel;
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        [titleLabel sizeToFit];
        [self.wapUpView addSubview:titleLabel];
        
        UILabel * boardNameLabel = [UILabel new];
        self.boardNameLabel = boardNameLabel;
        boardNameLabel.numberOfLines =1;
        //boardNameLabel.backgroundColor = [UIColor grayColor];
        boardNameLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:10];
        [self.wapUpView addSubview:boardNameLabel];
        
        self.userImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"santi.jpg"]];
        self.userImageView.layer.masksToBounds=YES;
        self.userImageView.layer.cornerRadius=IMAGE_WIDTH/2;
        self.userImageView.layer.borderWidth =1;
        self.userImageView.layer.borderColor = [UIColor colorWithHexString:IMAGE_BACKCOLOR].CGColor;
        [self.wapDownView addSubview:self.userImageView];
        
        UILabel * userNameLabel = [UILabel new];
        self.userNameLabel = userNameLabel;
        userNameLabel.numberOfLines =1;
        userNameLabel.font = [UIFont systemFontOfSize:10];
        [self.wapDownView addSubview:userNameLabel];
        
        UILabel * replyCount = [UILabel new];
        self.replyCount = replyCount;
        replyCount.numberOfLines =1;
        replyCount.font = [UIFont systemFontOfSize:10];
        [self.wapDownView addSubview:replyCount];
        
        [wapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(PADDING_TO_CONTENTVIEW);
            make.top.equalTo(self.contentView.mas_top).offset(PADDING_TO_CONTENTVIEW);
            make.right.equalTo(self.contentView.mas_right).offset(-PADDING_TO_CONTENTVIEW);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-PADDING_TO_CONTENTVIEW);
        }];
        
        [wapUpView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wapView.mas_top);
            make.left.equalTo(wapView.mas_left);
            make.right.equalTo(wapView.mas_right);
        }];
        //算入高度
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wapUpView.mas_top);
            make.left.equalTo(wapUpView.mas_left);
            make.right.equalTo(wapUpView.mas_right);
        }];
        //算入高度 +2 PADDING_WITHIN
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wapUpView.mas_left).offset(PADDING_WITHIN);
            make.top.equalTo(self.firstImageView.mas_bottom).offset(PADDING_WITHIN);
            make.right.equalTo(wapUpView.mas_right).offset(-PADDING_WITHIN);
        }];
        //算入高度 +1 PADDING_WITHIN
        [boardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(titleLabel.mas_right);
            make.left.equalTo(titleLabel.mas_left);
            make.top.equalTo(titleLabel.mas_bottom).offset(PADDING_WITHIN);
            make.bottom.equalTo(wapUpView.mas_bottom).offset(-PADDING_WITHIN);
        }];
        //算入高度1
        [distractorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wapView.mas_left).offset(PADDING_WITHIN);
            make.right.equalTo(wapView.mas_right).offset(-PADDING_WITHIN);
            make.top.equalTo(wapUpView.mas_bottom);
            make.height.mas_equalTo(DISTRACTOR_HEIGHT);
        }];
        
        [wapDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(distractorView.mas_bottom);
            make.left.equalTo(wapView.mas_left);
            make.right.equalTo(wapView.mas_right);
            make.bottom.equalTo(wapView.mas_bottom);
        }];
        
        //算入高度IMAGE_WIDTH +2 PADDING_WITH
        [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wapDownView.mas_top).offset(PADDING_WITHIN);
            make.left.equalTo(wapDownView.mas_left).offset(PADDING_WITHIN);
            make.size.mas_equalTo(CGSizeMake(IMAGE_WIDTH, IMAGE_WIDTH));
            make.bottom.equalTo(wapDownView.mas_bottom).offset(-PADDING_WITHIN);
        }];
        
        [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userImageView.mas_centerY);
            make.left.equalTo(self.userImageView.mas_right).offset(PADDING_WITHIN);
            make.width.mas_lessThanOrEqualTo(@100);
        }];
        
        [replyCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wapDownView.mas_right).offset(-PADDING_WITHIN);
            make.centerY.equalTo(self.userImageView.mas_centerY);
            make.width.mas_lessThanOrEqualTo(@100);
        }];
        [super updateConstraints];
    }
    return self;
}

- (void)setUpFaceWithDictionary:(NSDictionary *)dict{
    //设置附件第一张图片的本地存储地址firstImage 标题title 所属版面boardName 头像userImage 用户名userName 回复数replyCount 第一张图片的宽度firstImageWidth 第一张图片的高度firstImageHeight 属性layoutAttri
    self.titleLabel.text = [dict[@"title"] copy];
    self.boardNameLabel.text = [dict[@"boardName"] copy];
    self.userNameLabel.text = [dict[@"userName"] copy];
    self.replyCount.text = [NSString stringWithFormat:@"%@.R",dict[@"replyCount"]];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [super applyLayoutAttributes:layoutAttributes];
    XQCLayoutAttributes * attributes = [(XQCollectiArticleCell *)layoutAttributes copy];
    if ([attributes isEqual:layoutAttributes]) {
        [self.firstImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(attributes.photoHeight);
        }];
    }    
}

#pragma mark NSCopying 协议
- (id)copyWithZone:(NSZone *)zone{
    XQCollectiArticleCell * copyCell = [[[self class]allocWithZone:zone]newCellWithFrame:self.frame andParameters:self.paramDict];
    return copyCell;
}
@end
