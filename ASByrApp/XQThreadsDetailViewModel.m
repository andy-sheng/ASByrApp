//
//  XQThreadsDetailViewModel.m
//  ASByrApp
//
//  Created by lixiangqian on 17/2/4.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQThreadsDetailViewModel.h"
#import <ASByrToken.h>
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
    
    //避免多个换行
    BOOL tcount = false;
    for (NSString * ss in array) {
        NSString * ts = [NSString stringWithString:ss];
        if([[ts stringByReplacingOccurrencesOfString:@" " withString:@""] length]==0 && !tcount){
            tcount = true;
            [str appendString:@"<br></br>"];
        }else if ([[ts stringByReplacingOccurrencesOfString:@" " withString:@""] length]>0){
            [str appendFormat:@"<br>%@</br>",ss];
            tcount = false;
        }
    }
    
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
    
    //附件处理 支持mp3,jpg,png,jpeg格式
    if ([files count]>0) {
        NSInteger fcount = 0;
        for (NSDictionary * filee in files) {
            fcount = fcount+1;
            XQByrFile * file = [XQByrFile yy_modelWithJSON:filee];
            NSMutableString * fileHtml = [NSMutableString string];
            NSString * subname = [file.name substringFromIndex:file.name.length-4];
            if ([subname isEqualToString:@".png"] || [subname isEqualToString:@".jpg"] || [subname isEqualToString:@"jpeg"]) {
                [fileHtml appendString:@"<div class=\"img-parent\">"];
    
                [fileHtml appendFormat:@"<img src=\"%@?oauth_token=%@\">", file.url,[ASByrToken shareInstance].accessToken];
            }
            else if ([subname isEqualToString:@".mp3"]){
                [fileHtml appendString:@"<div class=\"audio-parent\">"];
                [fileHtml appendFormat:@"<audio controls=\"controls\" preload=\"auto\" src=\"%@?oauth_token=%@\"></audio>", file.url, [ASByrToken shareInstance].accessToken];
            }
            [fileHtml appendString:@"</div>"];
            NSString * searchstr = [NSString stringWithFormat:@"[upload=%ld][/upload]",fcount];
            if ([str rangeOfString:searchstr options:NSCaseInsensitiveSearch].location!=NSNotFound) {
                [str replaceOccurrencesOfString:searchstr withString:fileHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
            }else{
                [str appendString:fileHtml];
            }
        }
    }
    return str;
}

@end
