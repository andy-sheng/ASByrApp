//
//  XQArticle.m
//  ASByrApp
//
//  Created by lxq on 16/9/2.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQArticle.h"
#import "XQUserEntity.h"
@implementation XQArticle

- (id)initWithArticleID:(NSString *)articleID auther:(XQUserEntity *)auther title:(NSString *)title boardName:(NSString *)boardName boardDescription:(NSString *)boardDescription content:(NSString *)content firstImageUrl:(NSString *)firstImageUrl{
    self = [super init];
    if(self){
        self.articleID = [articleID copy];
        self.author = auther;
        self.title = [title copy];
        self.boardName = [boardName copy];
        self.boardDescription = [boardDescription copy];
        self.content = [content copy];
        self.firstImageUrl = [firstImageUrl copy];
    }
    return self;
}

- (id)initWithArticleID:(NSString *)articleID autherID:(NSString *)autherID title:(NSString *)title boardName:(NSString *)boardName boardDescription:(NSString *)boardDescription content:(NSString *)content firstImageUrl:(NSString *)firstImageUrl{
    self = [super init];
    if(self){
        self.articleID = [articleID copy];
        self.author = [[XQUserEntity alloc]init];
        self.author.userId = [autherID copy];
        self.title = [title copy];
        self.boardName = [boardName copy];
        self.boardDescription = [boardDescription copy];
        self.content = [content copy];
        self.firstImageUrl = [firstImageUrl copy];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dic{
    if(self = [super init]){
        self.articleID = [dic valueForKey:@"articleID"];
        self.author = [[XQUserEntity alloc]init];
        self.author.userId = [dic valueForKey:@"authorID"];
        self.title = [dic valueForKey:@"title"];
        self.boardDescription = [dic valueForKey:@"boardDescription"];
        self.boardName = [dic valueForKey:@"boardName"];
        self.content = [dic valueForKey:@"content"];
        self.firstImageUrl = [dic valueForKey:@"firstImageUrl"];
    }
    return self;
}

+ (XQArticle *)articleWithArticleID:(NSString *)articleID auther:(XQUserEntity *)auther title:(NSString *)title boardName:(NSString *)boardName boardDescription:(NSString *)boardDescription content:(NSString *)content firstImageUrl:(NSString *)firstImageUrl{
    XQArticle * article = [[XQArticle alloc]initWithArticleID:articleID auther:auther title:title boardName:boardName boardDescription:boardDescription content:content firstImageUrl:firstImageUrl];
    return article;
}

+ (XQArticle *)articleWithArticleID:(NSString *)articleID autherID:(NSString *)autherID title:(NSString *)title boardName:(NSString *)boardName boardDescription:(NSString *)boardDescription content:(NSString *)content firstImageUrl:(NSString *)firstImageUrl{
    XQArticle * article = [[XQArticle alloc]initWithArticleID:articleID autherID:autherID title:title boardName:boardName boardDescription:boardDescription content:content firstImageUrl:firstImageUrl];
    return article;
}
@end
