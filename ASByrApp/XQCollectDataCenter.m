//
//  XQCollectDataCenter.m
//  ASByrApp
//
//  Created by lixiangqian on 17/1/6.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQCollectDataCenter.h"
#import "XQArticleService.h"
#import "XQUserService.h"

#import <XQByrArticle.h>
#import <XQByrAttachment.h>
#import <XQByrFile.h>
#import <XQByrUser.h>
#import <YYModel/YYModel.h>
@interface XQCollectDataCenter()
@property (strong, nonatomic) XQUserService * userService;
@property (strong, nonatomic) XQArticleService * articleService;

@end

@implementation XQCollectDataCenter
- (instancetype)init{
    if(self = [super init]){
        self.userService = [[XQUserService alloc]init];
        self.articleService = [[XQArticleService alloc]init];
    }
    return self;
}

- (NSArray *)fetchCollectListFromLocal:(NSDictionary * __nullable)filters{
    //暂时不考虑处理横向切片的情况
    NSMutableArray * articleArray =[NSMutableArray arrayWithArray:[XQArticleService getArticlesByFilters:filters]];
    for (NSInteger i = 0; i < [articleArray count]; i++) {
        NSMutableDictionary * articleDic = [NSMutableDictionary dictionaryWithDictionary:articleArray[i]];
        NSString * userID = articleDic[@"author"];
        NSDictionary * userDic = [XQUserService getUserById:userID];
        [articleDic addEntriesFromDictionary:userDic];
        articleArray[i] = articleDic;
    }
    return articleArray;
}

- (BOOL)addCollectData:(XQByrArticle *)article{
    NSString * firstImageUrl = @"";
    NSString * userId = @"";
    
    XQByrArticle * childArticle = [XQByrArticle yy_modelWithDictionary:(NSDictionary *)article.article[0]];
    
    if (article.has_attachment) {
        XQByrAttachment * attachment;
        XQByrFile * file;
        if(attachment != nil){
             attachment = article.attachment;
             file = [NSArray arrayWithArray:attachment.file][0];
        }else{
            attachment = childArticle.attachment;
            file = [XQByrFile yy_modelWithDictionary:[NSArray arrayWithArray:attachment.file][0]];
        }
        firstImageUrl = file.url;
    }
    
    //文章正文在子数组中时需要对content单独赋值
    if(article.content == nil){
        article.content = childArticle.content;
    }
    
    XQByrUser * user = [[XQByrUser alloc]init];
    if ([article.user isKindOfClass:[XQByrUser class]]){
        user = article.user;
        userId = user.uid;
    }else{
        userId = (NSString *)article.user;
        user.face_url = @"fire";
        user.uid = (NSString *)article.user;
    }
    [_userService addUser:user];
    
    NSDictionary * parameters = [NSDictionary dictionaryWithObjectsAndKeys:user.uid,@"userID",firstImageUrl,@"firstImageUrl", nil];
    [_articleService addArticle:article andParameters:parameters];
    return true;
}
@end
