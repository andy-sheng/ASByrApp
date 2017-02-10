//
//  XQUserService.h
//  ASByrApp
//
//  Created by lxq on 16/9/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XQSingleton.h"

@class XQByrUser;

@interface XQUserService : NSObject
singleton_interface(XQUserService)

- (void)addUser:(XQByrUser *)user;

+ (NSDictionary *)getUserById:(NSString *)userId;

- (void)deleteAllUser;
@end
