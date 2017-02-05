//
//  XQThreadsDetailViewModel.m
//  ASByrApp
//
//  Created by lixiangqian on 17/2/4.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQThreadsDetailViewModel.h"

#import <XQByrArticle.h>
#import <XQByrAttachment.h>
#import <XQByrFile.h>

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

    NSArray * files;
    if (self.articleEntity.has_attachment) {
        XQByrArticle * childArticle = [XQByrArticle yy_modelWithDictionary:(NSDictionary *)_articleEntity.article[0]];
            XQByrAttachment * attachment;
            if(_articleEntity.attachment != nil){
                attachment = _articleEntity.attachment;
                files = [NSArray arrayWithArray:attachment.file];
            }else{
                attachment = childArticle.attachment;
                files = [NSArray arrayWithArray:attachment.file];
            }
    }
    
    if ([files count]>0) {
        NSInteger fcount = 1;
        for (NSDictionary * filee in files) {
            XQByrFile * file = [XQByrFile yy_modelWithJSON:filee];
            NSMutableString * fileHtml = [NSMutableString string];
            NSString * subname = [file.name substringFromIndex:file.name.length-4];
            if ([subname isEqualToString:@".png"] || [subname isEqualToString:@".jpg"] || [subname isEqualToString:@"jpeg"]) {
                [fileHtml appendString:@"<div class=\"img-parent\">"];
                /*
                NSString *onload = @"this.onclick = function() {"
                "  window.location.href = 'xq://github.com/xiangqianli?src=' +this.src+'&top=' + this.getBoundingClientRect().top + '&whscale=' + this.clientWidth/this.clientHeight ;"
                "};";
                 */
                [fileHtml appendFormat:@"<img src=\"%@%@\">",file.url,@"?oauth_token=f1c5d87cc17d1ab2cda3d71b2183d72f"];
                [fileHtml appendString:@"</div>"];
                NSString * searchstr = [NSString stringWithFormat:@"[upload=%ld][/upload]",fcount];
                if ([str rangeOfString:searchstr options:NSCaseInsensitiveSearch].location!=NSNotFound) {
                    [str replaceOccurrencesOfString:searchstr withString:fileHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
                }else{
                    [str appendString:fileHtml];
                }
            }
        }
    }
    return str;
}

@end
