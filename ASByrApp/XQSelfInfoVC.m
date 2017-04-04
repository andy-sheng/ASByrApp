//
//  XQSelfInfoVC.m
//  ASByrApp
//
//  Created by lxq on 16/5/16.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQSelfInfoVC.h"
#import "XQUserInfo.h"
#import "YYWebImage.h"
#import <YYModel.h>
#import <ASByrToken.h>
#import <ASByrUser.h>
#import <XQByrUser.h>

@interface XQSelfInfoVC()<UITableViewDataSource, UITableViewDelegate,ASByrUserResponseDelegate,ASByrUserResponseReformer>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UITableViewCell *clearCacheCell;
@property (strong, nonatomic) ASByrUser * userApi;
@end

@implementation XQSelfInfoVC

- (void)viewDidLoad{
    [super viewDidLoad];
    //[self loadData];
    self.tableView.delegate = self;
    [self.navigationItem setTitle:@"我"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadData];
}

#pragma mark <UITableViewDelegate>
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * staticCellQ = [self.tableView cellForRowAtIndexPath:indexPath];
    if (staticCellQ == _clearCacheCell) {
        [XQUserInfo sharedXQUserInfo].loginStatus = NO;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark <ASByrUserResponseDelegate>
-(void)fetchUserResponse:(ASByrResponse *)response{
    if (response.isSucceeded) {
        XQByrUser * user = [XQByrUser yy_modelWithJSON:response.response];
        //保存数据到单例
        XQUserInfo * userInfo = [XQUserInfo sharedXQUserInfo];
        userInfo.userName = user.user_name;
        userInfo.userId = user.uid;
        userInfo.userAvatar = user.face_url;
        userInfo.loginStatus = YES;
        
    }else{
        XQUserInfo * userInfo = [XQUserInfo sharedXQUserInfo];
        userInfo.userName = @"";
        userInfo.userId = @"";
        userInfo.userAvatar = @"";
    }
    
    [self loadDataToView];
}

#pragma mark <ASByrUserResponseReformer>
- (ASByrResponse *)reformUserResponse:(ASByrResponse *)response{
    return response;
}

- (void)loadData{
    //[XQUserInfo sharedXQUserInfo].loginStatus=false;
    if ([XQUserInfo sharedXQUserInfo].loginStatus !=YES) {
        self.userApi= [[ASByrUser alloc]initWithAccessToken:[ASByrToken shareInstance].accessToken];
        self.userApi.responseDelegate = self;
        //self.userApi.responseReformer = self;
        [self.userApi fetchUserInfoWithReformer:self];
    }else
        [self loadDataToView];
}

- (void)loadDataToView{
    self.userIdLabel.text=[NSString stringWithFormat:@"论坛ID:%@",[XQUserInfo sharedXQUserInfo].userId];
    self.userNameLabel.text = [NSString stringWithFormat:@"姓名:%@",[XQUserInfo sharedXQUserInfo].userName];
    self.userAvatar.yy_imageURL = [NSURL URLWithString:[XQUserInfo sharedXQUserInfo].userAvatar];
}

@end
