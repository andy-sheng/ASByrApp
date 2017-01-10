//
//  XQUserService.m
//  ASByrApp
//
//  Created by lxq on 16/9/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQUserService.h"
#import "XQByrUser.h"
#import "DBManager.h"
@implementation XQUserService
singleton_implementation(XQUserService)

- (void)addUser:(XQByrUser *)user{
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO User ( userID, userName, profileImageUrl) VALUES('%@','%@','%@')",user.uid, user.user_name,user.face_url];
    [[DBManager sharedDBManager]executeNonQuery:sql];
}

+ (NSDictionary *)getUserById:(NSString *)userId{
    NSDictionary * dictionary = [NSDictionary dictionary];
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM User WHERE userID='%@'",userId];
    NSArray * rows = [[DBManager sharedDBManager]executeQuery:sql];
    if(rows && rows.count >0){
        dictionary = rows[0];
    }
    return dictionary;
}

@end
