
//
//  XQDatabaseCreator.m
//  ASByrApp
//
//  Created by lxq on 16/9/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQDatabaseCreator.h"
#import "XQDBManager.h"
@implementation XQDatabaseCreator

+ (void)createDatabase{
    NSString * key = @"hasCreatedDb";
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults valueForKey:key] intValue]!=1) {
        [self createUserTable];
        [self createArticleTable];
        [defaults setValue:@1 forKey:key];
    }
}

+ (void)createUserTable{
    NSString *sql=@"CREATE TABLE User (userID text PRIMARY KEY ,userName text, profileImageUrl text)";
    [[XQDBManager sharedXQDBManager] executeNonQuery:sql];
}

+ (void)createArticleTable{
    NSString *sql=@"CREATE TABLE Article (articleID text PRIMARY KEY,title text,boardName text,boardDescription text, firstImageUrl text,replyCount text, state text, collectTime text, author text REFERENCES User (userID) )";
    [[XQDBManager sharedXQDBManager] executeNonQuery:sql];
}

+ (void)openDatabase{
    [[XQDBManager sharedXQDBManager] openDb:XQDATABASE_NAME];
}

+ (void)closeDatabase{
    [[XQDBManager sharedXQDBManager] closeDb];
}

@end
