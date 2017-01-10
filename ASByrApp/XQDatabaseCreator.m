
//
//  XQDatabaseCreator.m
//  ASByrApp
//
//  Created by lxq on 16/9/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQDatabaseCreator.h"
#import "DBManager.h"
@implementation XQDatabaseCreator

+ (void)createDatabase{
    NSString * key = @"IsCreatedDb";
    NSUserDefaults *defaults=[[NSUserDefaults alloc]init];
    if ([[defaults valueForKey:key] intValue]!=1) {
        [self createUserTable];
        [self createArticleTable];
        [defaults setValue:@1 forKey:key];
    }
}

+ (void)createUserTable{
    NSString *sql=@"CREATE TABLE User (userID text PRIMARY KEY ,userName text, profileImageUrl text)";
    [[DBManager sharedDBManager] executeNonQuery:sql];
}

+ (void)createArticleTable{
    NSString *sql=@"CREATE TABLE Article (articleID text PRIMARY KEY,title text,boardName text,boardDescription text,content text, firstImageUrl text,replyCount text, collectTime text, author text REFERENCES User (userID) )";
    [[DBManager sharedDBManager] executeNonQuery:sql];
}

+ (void)openDatabase{
    [[DBManager sharedDBManager]openDb:XQDATABASE_NAME];
}

+ (void)closeDatabase{
    [[DBManager sharedDBManager]closeDb];
}

@end
