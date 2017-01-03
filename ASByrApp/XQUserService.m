//
//  XQUserService.m
//  ASByrApp
//
//  Created by lxq on 16/9/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQUserService.h"
#import "XQUserEntity.h"
#import "DBManager.h"
@implementation XQUserService
singleton_implementation(XQUserService)

- (void)addUser:(XQUserEntity *)user{
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO User ( userID, profileImageUrl) VALUES('%@','%@')",user.userId, user.profileImageUrl];
    [[DBManager sharedDBManager]executeNonQuery:sql];
}

- (void)removeUser:(XQUserEntity *)user{
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM User WHERE userID = '%@'",user.userId];
    [[DBManager sharedDBManager]executeNonQuery:sql];
}

- (void)removeUserById:(NSString *)userId{
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM User WHERE userID = '%@'",userId];
    [[DBManager sharedDBManager]executeNonQuery:sql];
}

- (XQUserEntity *)getUserById:(NSString *)userId{
    XQUserEntity * user = [[XQUserEntity alloc]init];
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM User WHERE userID='%@'",userId];
    NSArray * rows = [[DBManager sharedDBManager]executeQuery:sql];
    if(rows && rows.count >0){
        [user setValuesForKeysWithDictionary:rows[0]];
    }
    return user;
}
@end
