//
//  XQUserEntity.h
//  ASByrApp
//
//  Created by lxq on 16/9/2.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQUserEntity : NSObject

@property (copy, nonatomic) NSString * userId;
@property (copy, nonatomic) NSString * profileImageUrl;

- (id)initWithUserId:(NSString *)userId andFaceUrl:(NSString *)faceUrl;

- (id)initWithDictionary:(NSDictionary *)dic;

+ (XQUserEntity *)userWithUserId:(NSString *)userId andFaceUrl:(NSString *)faceUrl;

@end
