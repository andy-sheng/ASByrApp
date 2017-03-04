//
//  XQByrArticleTable.m
//  ASByrApp
//
//  Created by lixiangqian on 17/2/26.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQByrArticleTable.h"
#import "XQByrUserTable.h"
#import <XQByrCollection.h>

@interface XQByrArticleTable()<XQTableBaseExecutorProtocol>

@end

@implementation XQByrArticleTable

#pragma mark XQTableBaseExecutorProtocol
- (NSString *)databaseName{
    return XQByrDatabaseName;
}

- (NSString *)tableName{
    return @"Collection";
}

- (NSDictionary *)tableColumnInfo{
    return @{
             @"gid":@"text PRIMARY KEY",
             @"title":@"text",
             @"bname":@"text",
             @"postTime":@"text",
             @"createdTime":@"text",
             @"firstImageUrl":@"text",
             @"replyCount":@"text",
             @"state":@"text",
             @"user":@"text FOREIGN KEY PREFERENCES User (uid)"
             };
}

- (NSString *)primaryKey{
    return @"gid";
}

- (Class)tableClass{
    return [XQByrCollection class];
}

- (NSString *)foreignClassName{
    return @"XQByrUserTable";
}

@end
