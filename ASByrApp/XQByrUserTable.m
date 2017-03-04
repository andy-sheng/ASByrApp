//
//  XQByrUserTable.m
//  ASByrApp
//
//  Created by lixiangqian on 17/2/25.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQByrUserTable.h"
#import <XQByrUser.h>

@interface XQByrUserTable()<XQTableBaseExecutorProtocol>

@end
@implementation XQByrUserTable

+ (NSArray *)getForeignColumnInfo{
    return [NSArray arrayWithObjects:@"uid",@"user_name",@"face_url",nil];
}

#pragma mark XQTableBaseExecutorProtocol
- (NSString *)databaseName{
    return XQByrDatabaseName;
}

- (NSString *)tableName{
    return @"User";
}

- (NSDictionary *)tableColumnInfo{
    return @{
             @"uid":@"text PRIMARY KEY",
             @"user_name":@"text",
             @"face_url":@"text"
             };
}

- (NSString *)primaryKey{
    return @"uid";
}

- (Class)tableClass{
    return [XQByrUser class];
}

@end
