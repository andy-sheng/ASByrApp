//
//  XQUserInfo.h
//  ASByrApp
//  当前用户信息
//  Created by lxq on 16/5/16.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XQSingleton.h"

@interface XQUserInfo : NSObject
singleton_interface(XQUserInfo);

@property (copy, nonatomic) NSString * userId;
@property (copy, nonatomic) NSString * userName;
@property (copy, nonatomic) NSData * userAvatar;
@property (assign, nonatomic) BOOL loginStatus;
@property (assign, nonatomic) BOOL firstLogin;

- (void)getDataFromSandbox;

- (void)setDataIntoSandbox;

@end
