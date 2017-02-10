//
//  XQUserInfo.m
//  ASByrApp
//
//  Created by lxq on 16/5/16.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQUserInfo.h"

@implementation XQUserInfo
singleton_implementation(XQUserInfo);

-(void)getDataFromSandbox{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    self.userId = [defaults objectForKey:XQByrUserIdKey];
    self.userName = [defaults objectForKey:XQByrUserNameKey];
    self.userAvatar = [defaults objectForKey:XQByrUserAvatarKey];
    self.loginStatus = [defaults objectForKey:XQByrUserLoginStatusKey];
    self.firstLogin = [defaults objectForKey:XQByrFirstLoginStatusKey];
}

- (void)setDataIntoSandbox{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userId forKey:XQByrUserIdKey];
    [defaults setObject:self.userName forKey:XQByrUserNameKey];
    [defaults setObject:self.userAvatar forKey:XQByrUserAvatarKey];
    [defaults setBool:self.loginStatus forKey:XQByrUserLoginStatusKey];
    [defaults setBool:self.firstLogin forKey:XQByrFirstLoginStatusKey];
    [defaults synchronize];
}
@end
