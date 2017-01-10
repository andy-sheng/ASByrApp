//
//  XQArticleService.m
//  ASByrApp
//
//  Created by lxq on 16/9/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQArticleService.h"
#import "DBManager.h"
#import <XQByrArticle.h>

@implementation XQArticleService
singleton_implementation(XQArticleService)

+ (NSArray * __nullable)getAllArticles{
    NSString *sql=@"SELECT * FROM Article ORDER BY articleID";
    NSArray *rows= [[DBManager sharedDBManager] executeQuery:sql];
    return rows;
}

- (void)addArticle:(XQByrArticle *)article andParameters:(NSDictionary *)parameters{
        
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO Article (articleID, title, boardName, boardDescription, content, firstImageUrl, collectTime, author, replyCount) VALUES ('%ld','%@','%@','%@','%@','%@','%@','%@','%ld')",(long)article.aid,article.title,article.board_name,article.board_description,article.content,parameters[@"firstImageUrl"],[NSString stringWithFormat:@"%f",NSTimeIntervalSince1970],parameters[@"userID"],(long)article.reply_count];
    [[DBManager sharedDBManager]executeNonQuery:sql];
}

+ (NSDictionary *)getArticleById:(NSString *)articleID{
    NSDictionary * dictionary = [NSDictionary dictionary];
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM Article WHERE articleID='%@'", articleID];
    NSArray * rows = [[DBManager sharedDBManager] executeQuery:sql];
    if(rows && rows.count>0){
        dictionary = (NSDictionary *)rows[0];
    }
    return dictionary;
}

+ (NSArray *)getArticlesByFilters:(NSDictionary * __nonnull)filters{
    NSArray * filterKeys = [filters allKeys];
    NSString __block *sql=@"SELECT * FROM Article ORDER BY articleID";
    if([filterKeys count]!=0){
        [filterKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            sql = [sql stringByAppendingFormat:@"%@ %@",sql, [NSString stringWithFormat:@"and WHERE  %@='%@'",obj,[filters objectForKey:obj]]];
        }];
        return [[DBManager sharedDBManager] executeQuery:sql];
    }else{
        return [XQArticleService getAllArticles];
    }
}

@end
