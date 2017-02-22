//
//  XQArticleService.m
//  ASByrApp
//
//  Created by lxq on 16/9/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQArticleService.h"
#import "XQDBManager.h"
#import <XQByrArticle.h>
#import <XQByrCollection.h>

@implementation XQArticleService

- (NSArray * __nullable)getAllArticles{
    NSString *sql=@"SELECT * FROM Article ORDER BY articleID";
    NSArray *rows= [[XQDBManager sharedXQDBManager] executeQuery:sql];
    return rows;
}

- (void)addArticleWithCollection:(XQByrCollection *)article andParameters:(NSDictionary * _Nonnull)parameters{
    NSString * sql;
    if(parameters[@"userID"]){
        sql = [NSString stringWithFormat:@"INSERT INTO Article (articleID, title, boardName, collectTime, author, replyCount, state) VALUES ('%@','%@','%@','%@','%@','%@','%ld')",article.gid,article.title,article.bname,article.createdTime,parameters[@"userID"],article.num, (long)XQByrCollectionSyncNew];
    }else{
        sql = [NSString stringWithFormat:@"INSERT INTO Article (articleID, title, boardName, collectTime, replyCount) VALUES ('%@','%@','%@','%@','%@')",article.gid,article.title,article.bname,article.createdTime,article.num];
    }
    [[XQDBManager sharedXQDBManager]executeNonQuery:sql];
}

- (void)addArticle:(XQByrArticle *)article andParameters:(NSDictionary *)parameters{
    NSDate * now = [NSDate date];
    NSTimeInterval nowunix = [now timeIntervalSince1970];
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO Article (articleID, title, boardName, boardDescription,  firstImageUrl, collectTime, author, replyCount, state) VALUES ('%ld','%@','%@','%@','%@','%@','%@','%ld','%ld')",(long)article.aid,article.title,article.board_name,article.board_description,parameters[@"firstImageUrl"],[NSString stringWithFormat:@"%f",nowunix],parameters[@"userID"],(long)article.reply_count,(long)XQByrCollectionSyncNormal];
    [[XQDBManager sharedXQDBManager]executeNonQuery:sql];
}

- (NSDictionary *)getArticleById:(NSString *)articleID{
    NSDictionary * dictionary = [NSDictionary dictionary];
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM Article WHERE articleID='%@'", articleID];
    NSArray * rows = [[XQDBManager sharedXQDBManager] executeQuery:sql];
    if(rows && rows.count>0){
        dictionary = (NSDictionary *)rows[0];
    }
    return dictionary;
}

- (NSArray *)getArticlesByFilters:(NSDictionary * __nonnull)filters{
    NSArray * filterKeys = [filters allKeys];
    NSString __block *sql=@"SELECT * FROM Article ORDER BY articleID";
    if([filterKeys count]!=0){
        [filterKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            sql = [sql stringByAppendingFormat:@" and WHERE  %@='%@'", obj,[filters objectForKey:obj]];
        }];
        return [[XQDBManager sharedXQDBManager] executeQuery:sql];
    }else{
        return [self getAllArticles];
    }
}

- (void)updateArticle:(NSString *)articleID andParameters:(NSDictionary *)dic{
    NSArray * filterKeys = [dic allKeys];
    NSString __block *sql=@"UPDATE Article set";
    if([filterKeys count]!=0){
        [filterKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(idx > 0){
                sql = [sql stringByAppendingFormat:@" , %@ = '%@' ",obj,[dic objectForKey:obj]];
            }else{
                sql = [sql stringByAppendingFormat:@" %@ = '%@' ",obj,[dic objectForKey:obj]];
            }
        }];
    }
    sql = [sql stringByAppendingFormat:@" WHERE articleID = '%@'",articleID];

    [[XQDBManager sharedXQDBManager] executeNonQuery:sql];
}

- (void)deleteArticle:(NSString *)articleID{
    NSString * sql;
    if (articleID) {
        sql = [NSString stringWithFormat:@"delete from Article where articleID = '%@'",articleID];
    }else{
        sql = @"delete from Article";
    }
    [[XQDBManager sharedXQDBManager] executeNonQuery:sql];
}

@end
