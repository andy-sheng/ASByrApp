//
//  XQUserInfo.m
//  ASByrApp
//
//  Created by lxq on 16/5/16.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQUserInfo.h"

static NSString * const XQByrUserIdKey = @"userId";
static NSString * const XQByrUserNameKey = @"userName";
static NSString * const XQByrUserAvatarKey = @"userFace";
static NSString * const XQByrUserLoginStatusKey =  @"userLoginStatus";
static NSString * const XQByrFirstLoginStatusKey = @"userFirstLogin";
static NSString * const XQByrLastViewBoardKey = @"userLastViewBoard";
static NSString * const XQByrLatestCollectTimeKey = @"userLatestCollectTime";

@implementation XQUserInfo
singleton_implementation(XQUserInfo);

-(void)getDataFromSandbox{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    self.userId = [defaults objectForKey:XQByrUserIdKey];
    NSLog(@"====== XQUserInfo userId :%@",self.userId);
    self.userName = [defaults objectForKey:XQByrUserNameKey];
    NSLog(@"====== XQUserInfo userName :%@",self.userName);
    self.userAvatar = [defaults objectForKey:XQByrUserAvatarKey];
    NSLog(@"====== XQUserInfo userAvatar :%@",self.userAvatar);
    self.loginStatus = [defaults objectForKey:XQByrUserLoginStatusKey];
    NSLog(@"====== XQUserInfo loginStatus :%@",self.loginStatus?@"YES":@"NO");

    self.firstLogin = [defaults objectForKey:XQByrFirstLoginStatusKey];
    NSLog(@"====== XQUserInfo firstLogin :%@",self.firstLogin?@"YES":@"NO");

    self.lastViewBoard = [defaults objectForKey:XQByrLastViewBoardKey];
    NSLog(@"====== XQUserInfo lastViewBoard :%@",self.lastViewBoard);

    self.latestCollectTime = [defaults objectForKey:XQByrLatestCollectTimeKey];
    NSLog(@"====== XQUserInfo latestCollectTime :%@",self.latestCollectTime);
}

- (void)setDataIntoSandbox{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userId forKey:XQByrUserIdKey];
    [defaults setObject:self.userName forKey:XQByrUserNameKey];
    [defaults setObject:self.userAvatar forKey:XQByrUserAvatarKey];
    [defaults setBool:self.loginStatus forKey:XQByrUserLoginStatusKey];
    [defaults setBool:self.firstLogin forKey:XQByrFirstLoginStatusKey];
    [defaults setObject:self.latestCollectTime forKey:XQByrLatestCollectTimeKey];
    [defaults synchronize];
}

@end
