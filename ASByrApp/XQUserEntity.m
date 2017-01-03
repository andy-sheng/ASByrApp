//
//  XQUserEntity.m
//  ASByrApp
//
//  Created by lxq on 16/9/2.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQUserEntity.h"

@implementation XQUserEntity

- (id)initWithUserId:(NSString *)userId andFaceUrl:(NSString*)faceUrl{
    if(self = [super init]){
        self.userId = [userId copy];
        self.profileImageUrl = [faceUrl copy];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dic{
    if(self = [super init]){
        self.userId = [dic valueForKey:@"userID"];
        self.profileImageUrl = [dic valueForKey:@"userImage"];
    }
    return self;
}

+ (XQUserEntity *)userWithUserId:(NSString *)userId andFaceUrl:(NSString *)faceUrl{
    XQUserEntity * user = [[XQUserEntity alloc]initWithUserId:userId andFaceUrl:faceUrl];
    return user;
}

@end
