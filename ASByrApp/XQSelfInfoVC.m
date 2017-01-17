//
//  XQSelfInfoVC.m
//  ASByrApp
//
//  Created by lxq on 16/5/16.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQSelfInfoVC.h"
#import "XQUserInfo.h"
#import <ASByrToken.h>
#import <ASByrUser.h>
#import <UIImage+AFNetworking.h>
@interface XQSelfInfoVC()<UITableViewDataSource, UITableViewDelegate,ASByrUserResponseDelegate,ASByrUserResponseReformer>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UITableViewCell *clearCacheCell;
@property(strong, nonatomic) ASByrUser * userApi;
@end

@implementation XQSelfInfoVC

- (void)viewDidLoad{
    [super viewDidLoad];
    //[self loadData];
    self.tableView.delegate = self;
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
        
        [[XQUserInfo sharedXQUserInfo] setDataIntoSandbox];
        [[XQUserInfo sharedXQUserInfo] getDataFromSandbox];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark <ASByrUserResponseDelegate>
-(void)fetchUserResponse:(ASByrResponse *)response{
    
    //保存数据到单例
    XQUserInfo * userInfo = [XQUserInfo sharedXQUserInfo];
    userInfo.userName = response.reformedData[@"uname"];
    userInfo.userId = response.reformedData[@"uid"];
    userInfo.userAvatar=[NSData dataWithContentsOfURL:[NSURL URLWithString:response.reformedData[@"uavatar"]]];
    userInfo.loginStatus = YES;
    //保存用户数据到沙盒
    [userInfo setDataIntoSandbox];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadDataToView];
    });
}

#pragma mark <ASByrUserResponseReformer>
- (ASByrResponse *)reformUserResponse:(ASByrResponse *)response{
    NSDictionary * userInfo = [NSDictionary dictionaryWithDictionary:response.response];
    NSMutableDictionary * reformedData = [[NSMutableDictionary alloc]init];
    reformedData[@"uname"]=[userInfo objectForKey:@"user_name"];
    reformedData[@"uid"]=[userInfo objectForKey:@"id"];
    NSLog(@"%@",userInfo[@"face_url"]);
    reformedData[@"uavatar"]=userInfo[@"face_url"]?:@"";
    response.reformedData=[reformedData copy];
    response.isSucceeded=YES;
    return response;
}

- (void)loadData{
    //[XQUserInfo sharedXQUserInfo].loginStatus=false;
    if (![XQUserInfo sharedXQUserInfo].loginStatus) {
        self.userApi= [[ASByrUser alloc]initWithAccessToken:[ASByrToken shareInstance].accessToken];
        self.userApi.responseDelegate = self;
        [self.userApi fetchUserInfoWithReformer:self];
    }else
        [self loadDataToView];
}

- (void)loadDataToView{
    NSLog(@"222222222");
    self.userIdLabel.text=[NSString stringWithFormat:@"论坛ID:%@",[XQUserInfo sharedXQUserInfo].userId];
    self.userNameLabel.text = [NSString stringWithFormat:@"姓名:%@",[XQUserInfo sharedXQUserInfo].userName];
    self.userAvatar.image =[UIImage imageWithData:[XQUserInfo sharedXQUserInfo].userAvatar];
}

@end
