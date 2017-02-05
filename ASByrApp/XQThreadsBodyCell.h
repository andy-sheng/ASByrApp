//
//  XQThreadsBodyCell.h
//  ASByrApp
//
//  Created by lixiangqian on 17/2/4.
//  Copyright © 2017年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface XQThreadsBodyCell : UITableViewCell

@property (strong, nonatomic) WKWebView *webView;
@property (assign, nonatomic) NSInteger height;

@end
