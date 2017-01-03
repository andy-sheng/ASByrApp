//
//  XQUserService.h
//  ASByrApp
//
//  Created by lxq on 16/9/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XQSingleton.h"

@class XQUserEntity;

@interface XQUserService : NSObject
singleton_interface(XQUserService)

- (void)addUser:(XQUserEntity *)user;

- (void)removeUser:(XQUserEntity *)user;
- (void)removeUserById:(NSString *)userId;

- (XQUserEntity *)getUserById:(NSString *)userId;
@end
