//
//  XQArticleService.m
//  ASByrApp
//
//  Created by lxq on 16/9/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQArticleService.h"
#import "DBManager.h"
#import "XQArticle.h"
#import "XQUserEntity.h"
#import "XQUserService.h"
@implementation XQArticleService
singleton_implementation(XQArticleService)

+ (NSArray *)getAllArticles{
    NSMutableArray *array=[NSMutableArray array];
    NSString *sql=@"SELECT * FROM Article ORDER BY Id";
    NSArray *rows= [[DBManager sharedDBManager] executeQuery:sql];
    for (NSDictionary *dic in rows) {
        XQArticle * article =[self getArticleById:(NSString *)dic[@"articleID"]];
        [array addObject:article];
    }
    return array;
}

- (void)addArticle:(XQArticle *)article{
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO Article (articleID, title, boardName, boardDescription, content, firstImageUrl, collectTime,author) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@')",article.articleID,article.title,article.boardName,article.boardDescription,article.content,article.firstImageUrl,article.collectTime,article.author.userId];
    [[DBManager sharedDBManager]executeNonQuery:sql];
}

- (void)removeArticle:(XQArticle *)article{
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM Article WHERE articleID='%@'",article.articleID];
    [[DBManager sharedDBManager]executeNonQuery:sql];
}

- (void)modifyArticle:(XQArticle *)article{
    NSString * sql = [NSString stringWithFormat:@"UPDATE Article SET title='%@', boardName='%@', boardDescription='%@', content = '%@', firstImageUrl = '%@', collectTime = '%@', author='%@' WHERE articleID='%@'",article.title ,article.boardName ,article.boardDescription ,article.content ,article.firstImageUrl ,article.collectTime ,article.author ,article.articleID];
    [[DBManager sharedDBManager] executeNonQuery:sql];
}

+ (XQArticle *)getArticleById:(NSString *)articleID{
    XQArticle * article = [[XQArticle alloc]init];
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM Article WHERE articleID='%@'", articleID];
    NSArray * rows = [[DBManager sharedDBManager] executeQuery:sql];
    if(rows && rows.count>0){
        [article setValuesForKeysWithDictionary:rows[0]];
        article.author = [[XQUserService sharedXQUserService] getUserById:rows[0][@"author"]];
    }
    return article;
}

@end
