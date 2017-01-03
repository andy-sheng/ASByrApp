//
//  XQUserInfo.m
//  ASByrApp
//
//  Created by lxq on 16/5/16.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQUserInfo.h"

#define UserId @"userId"
#define UserName @"userName"
#define UserAvatar @"userFace"
#define UserLoginStatus @"userLoginStatus"

@implementation XQUserInfo
singleton_implementation(XQUserInfo);

-(void)getDataFromSandbox{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    self.userId = [defaults objectForKey:UserId];
    self.userName = [defaults objectForKey:UserName];
    self.userAvatar = [defaults objectForKey:UserAvatar];
    self.loginStatus = [defaults objectForKey:UserLoginStatus];
}

- (void)setDataIntoSandbox{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userId forKey:UserId];
    [defaults setObject:self.userName forKey:UserName];
    [defaults setObject:self.userAvatar forKey:UserAvatar];
    [defaults setBool:self.loginStatus forKey:UserLoginStatus];
    [defaults synchronize];
}
@end
