//
//  XQThreadsBodyCell.m
//  ASByrApp
//  xib 中不支持WKWebView
//  Created by lixiangqian on 17/2/4.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQThreadsBodyCell.h"
#import <Masonry.h>

@interface XQThreadsBodyCell()<WKNavigationDelegate>

@end
@implementation XQThreadsBodyCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.webView = [[WKWebView alloc]initWithFrame:frame];
        self.height = frame.size.height;
        [self.contentView addSubview:self.webView];

        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(PADDING_TO_CONTENTVIEW);
            make.top.equalTo(self.contentView.mas_top).offset(PADDING_TO_CONTENTVIEW);
            make.right.equalTo(self.contentView.mas_right).offset(-PADDING_TO_CONTENTVIEW);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-PADDING_TO_CONTENTVIEW);
        }];
        
        [super updateConstraints];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, XQSCREEN_W, XQSCREEN_H*0.75)];
    }
    return _webView;
}

@end
