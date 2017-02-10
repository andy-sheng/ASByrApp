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
        [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

//KVO键值观察
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    UIScrollView * scrollView = object;
    if (fabs(scrollView.contentSize.height-self.height)> XQWebviewRefreshThresholdValue) {
        self.height = scrollView.contentSize.height;
        NSLog(@"webview达到刷新阈值，新高度:%ld，将reload tableview",(long)self.height);
        [[NSNotificationCenter defaultCenter]postNotificationName:XQNotificationWebViewLoaded object:nil];
    }
}

-(void)dealloc{
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

@end
