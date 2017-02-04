//
//  XQThreadsBodyCell.m
//  ASByrApp
//  xib 中不支持WKWebView
//  Created by lixiangqian on 17/2/4.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQThreadsBodyCell.h"

@implementation XQThreadsBodyCell
+ (id)newCellWithHtml:(NSString *)html{
    XQThreadsBodyCell * cell = [[XQThreadsBodyCell alloc]initWithFrame:CGRectMake(0, 0, XQSCREEN_W, 700)];
    return cell;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.webView = [[WKWebView alloc]initWithFrame:frame];
        
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
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, XQSCREEN_W, 700)];
    }
    return _webView;
}

@end
