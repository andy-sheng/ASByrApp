//
//  XQByrArticleTable.m
//  ASByrApp
//
//  Created by lixiangqian on 17/2/26.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQByrArticleTable.h"
#import "XQByrUserTable.h"
#import <XQByrUser.h>
#import <XQByrCollection.h>

@interface XQByrArticleTable()<XQTableBaseExecutorProtocol>

@end

@implementation XQByrArticleTable

- (instancetype)init{
    static XQByrArticleTable * articleTable;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        articleTable = [[XQByrArticleTable alloc]initDatabase];
    });
    return articleTable;
}

#pragma mark XQTableBaseExecutorProtocol
- (NSString *)databaseName{
    return XQByrDatabaseName;
}

- (NSString *)tableName{
    return @"Collection";
}

- (NSDictionary *)tableColumnInfo{
    return @{
             //@"gid":@"text FOREIGN KEY PREFERENCES User (uid)",
             @"gid":@"text PRIMARY KEY",
             @"title":@"text",
             @"bname":@"text",
             @"postTime":@"text",
             @"createdTime":@"text",
             @"firstImageUrl":@"text",
             @"replyCount":@"text",
             @"state":@"text",
             @"user":@"text REFERENCES User (uid)"
             };
}

- (NSString *)primaryKey{
    return @"gid";
}

- (Class)tableClass{
    return [XQByrCollection class];
}

- (Class)foreignTableClass{
    return [XQByrUserTable class];
}

- (Class)foreignModelClass{
    return [XQByrUser class];
}

@end