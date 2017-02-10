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
    NSMutableString * str = [NSMutableString stringWithString:_articleEntity.content];
    [str replaceOccurrencesOfString:@" " withString:@"&nbsp;" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];

    str = [self parseWithString:str];
    /*
    NSArray * array = [_articleEntity.content componentsSeparatedByString:@"\n"];
    
    
    //避免多个换行
    BOOL tcount = false;
    for (NSString * ss in array) {
        NSString * ts = [NSString stringWithString:ss];
        if([[ts stringByReplacingOccurrencesOfString:@" " withString:@""] length]==0 && !tcount){
            tcount = true;
            [str appendString:@"<br></br>"];
        }else if ([[ts stringByReplacingOccurrencesOfString:@" " withString:@""] length]>0){
            [str appendFormat:@"%@</br>",ss];
            tcount = false;
        }
    }*/
    
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

    NSLog(@"html %@:",str);
    return str;
}

- (NSMutableString *)parseWithString:(NSMutableString *)html{
    NSRegularExpression *sizeReg = [NSRegularExpression regularExpressionWithPattern:@"\\[size=([0-9]+)\\](.*?)\\[/size\\]"
                                                                             options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                                                               error:nil];
    
    [sizeReg replaceMatchesInString:html options:0 range:NSMakeRange(0, html.length) withTemplate:@"<div class=\"xqfont\" id=\"xq$1font\">$2</div>"];
    
    
    NSRegularExpression *bReg = [NSRegularExpression regularExpressionWithPattern:@"\\[b\\](.*?)\\[/b\\]"
                                                                          options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                                                            error:nil];
    
    [bReg replaceMatchesInString:html options:0 range:NSMakeRange(0, html.length) withTemplate:@"<b>$1</b>"];
    
    
    NSRegularExpression *colorReg = [NSRegularExpression regularExpressionWithPattern:@"\\[color=(#[a-zA-Z0-9]*)\\](.*?)\\[/color\\]"
                                                                              options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                                                                error:nil];
    
    [colorReg replaceMatchesInString:html options:0 range:NSMakeRange(0, html.length) withTemplate:@"<font color='$1'>$2</font>"];
    
    
    NSRegularExpression *codeReg = [NSRegularExpression regularExpressionWithPattern:@"\\[code=[a-zA-Z0-9]+\\](.*?)\\[/code\\]"
                                                                             options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionDotMatchesLineSeparators
                                                                               error:nil];
    
    [codeReg replaceMatchesInString:html options:0 range:NSMakeRange(0, html.length) withTemplate:@"$1"];
    
    
    NSRegularExpression *emailReg = [NSRegularExpression regularExpressionWithPattern:@"\\[email=(.*)\\](.*?)\\[/email\\]"
                                                                              options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                                                                error:nil];
    
    [emailReg replaceMatchesInString:html options:0 range:NSMakeRange(0, html.length) withTemplate:@"<a href='mailto:$1'>$2</a>"];
    
    
    NSRegularExpression *faceReg = [NSRegularExpression regularExpressionWithPattern:@"\\[face=(.*)\\](.*?)\\[/face\\]"
                                                                             options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                                                               error:nil];
    
    [faceReg replaceMatchesInString:html options:0 range:NSMakeRange(0, html.length) withTemplate:@"<font face='$1'>$2</font>"];
    
    
    NSRegularExpression *iReg = [NSRegularExpression regularExpressionWithPattern:@"\\[i\\](.*?)\\[/i\\]"
                                                                          options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                                                            error:nil];
    
    [iReg replaceMatchesInString:html options:0 range:NSMakeRange(0, html.length) withTemplate:@"<i>$1</i>"];
    
    
    
    NSRegularExpression *imgReg = [NSRegularExpression regularExpressionWithPattern:@"\\[img=(.*?)\\](.*?)\\[/img]"
                                                                            options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                                                              error:nil];
    
    [imgReg replaceMatchesInString:html options:0 range:NSMakeRange(0, html.length) withTemplate:@"<img src='$1' style='width:96%;'/>"];
    
    NSRegularExpression *uReg = [NSRegularExpression regularExpressionWithPattern:@"\\[u\\](.*?)\\[/u]"
                                                                          options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                                                            error:nil];
    
    [uReg replaceMatchesInString:html options:0 range:NSMakeRange(0, html.length) withTemplate:@"<u>$1</u>"];
    
    
    
    NSRegularExpression *urlReg = [NSRegularExpression regularExpressionWithPattern:@"\\[url=(.*)\\](.*?)\\[/url]"
                                                                            options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                                                              error:nil];
    
    [urlReg replaceMatchesInString:html options:0 range:NSMakeRange(0, html.length) withTemplate:@"<a href='$1'>$2</a>"];
    
    
    
    NSRegularExpression *emReg = [NSRegularExpression regularExpressionWithPattern:@"\\[(em[abc]?)([0-9]+)\\]"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    [emReg replaceMatchesInString:html options:0 range:NSMakeRange(0, html.length) withTemplate:@"<img src='https://bbs.byr.cn/img/ubb/$1/$2.gif'/>"];
    
    
    NSRegularExpression *brReg = [NSRegularExpression regularExpressionWithPattern:@"\\n"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    [brReg replaceMatchesInString:html options:0 range:NSMakeRange(0, html.length) withTemplate:@"<br/>"];
    
    return html;
}
@end
