//
//  XQUserService.m
//  ASByrApp
//
//  Created by lxq on 16/9/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQUserService.h"
#import "XQByrUser.h"
#import "XQDBManager.h"
@implementation XQUserService

- (void)addUser:(XQByrUser *)user{
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO User ( userID, userName, profileImageUrl) VALUES('%@','%@','%@')",user.uid, user.user_name,user.face_url];
    [[XQDBManager sharedXQDBManager]executeNonQuery:sql];
}

- (NSDictionary *)getUserById:(NSString *)userId{
    NSDictionary * dictionary = [NSDictionary dictionary];
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM User WHERE userID='%@'",userId];
    NSArray * rows = [[XQDBManager sharedXQDBManager]executeQuery:sql];
    if(rows && rows.count >0){
        dictionary = rows[0];
    }
    return dictionary;
}

-(void)deleteAllUser{
    NSString * sql = @"delete from User";
    [[XQDBManager sharedXQDBManager] executeNonQuery:sql];
}
@end
