//
//  XQCollectiArticleCell.m
//  ASByrApp
//
//  Created by lxq on 16/5/8.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQCollectiArticleCell.h"
#import "XQConstant.h"
#import <Masonry.h>
@implementation XQCollectiArticleCell
- (id)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        self.contentView.layer.borderWidth = 0.3;
        self.contentView.layer.borderColor= [UIColor redColor].CGColor;
        UIView * wapView = [UIView new];
        self.wapView = wapView;
        [self.contentView addSubview:wapView];
        
        UILabel * titleLabel=[UILabel new];
        self.titleLabel = titleLabel;
        titleLabel.numberOfLines = 2;
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:titleLabel];
        
        UILabel * contentLabel = [UILabel new];
        self.contentLabel = contentLabel;
        contentLabel.numberOfLines = 2;
        contentLabel.backgroundColor = [UIColor whiteColor];
        contentLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:contentLabel];
        
        [wapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(PADDING_TO_CONTENTVIEW);
            make.top.equalTo(self.contentView.mas_top).offset(PADDING_TO_CONTENTVIEW);
            make.right.equalTo(self.contentView.mas_right).offset(-PADDING_TO_CONTENTVIEW);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wapView.mas_left).offset(PADDING_TO_CONTENTVIEW);
            make.top.equalTo(wapView.mas_top).offset(PADDING_WITHIN);
            make.right.equalTo(wapView.mas_right).offset(-PADDING_TO_CONTENTVIEW);
        }];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wapView.mas_right).offset(-PADDING_TO_CONTENTVIEW);
            make.left.equalTo(titleLabel.mas_left);
            make.top.equalTo(titleLabel.mas_bottom).offset(PADDING_WITHIN);
        }];
    }
    return self;
}
@end
