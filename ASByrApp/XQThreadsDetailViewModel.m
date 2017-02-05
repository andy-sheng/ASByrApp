//
//  XQThreadsDetailViewModel.m
//  ASByrApp
//
//  Created by lixiangqian on 17/2/4.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQThreadsDetailViewModel.h"
#import <YYModel/YYModel.h>
#import <XQByrArticle.h>
@implementation XQThreadsDetailViewModel
- (instancetype)initWithArticleDic:(NSDictionary *)articelDic{
    self = [super init];
    if (self) {
        _articleEntity = [XQByrArticle yy_modelWithJSON:articelDic];
        _title = _articleEntity.title;
    }
    return self;
}

- (NSString *)getContentHtmlString{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    //[html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"XQArticleBody.css" withExtension:nil]];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",@"XQArticleBody.css"];
    [html appendString:@"</head>"];
    
    [html appendString:@"<body><div id=\"content\">"];
    [html appendString:[self getBodyString]];
    [html appendString:@"</div></body>"];
    
    [html appendString:@"</html>"];
    
    return html;
}

#pragma mark - private method
- (NSString *)getBodyString{
    NSMutableString * str = [NSMutableString string];
    NSArray * array = [_articleEntity.content componentsSeparatedByString:@"\n"];
    for (NSString * ss in array) {
        [str appendFormat:@"<br>%@</br>",ss];
    }
    NSLog(@"array length:%lu",(unsigned long)[array count]);
    NSLog(@"after string:%@",str);
    return str;
}

@end
