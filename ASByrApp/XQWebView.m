//
//  XQWebView.m
//  ASByrApp
//
//  Created by lixiangqian on 17/2/5.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQWebView.h"

@implementation XQWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView.scrollEnabled = NO;
        self.height = frame.size.height;
    }
    return self;
}
@end
