//
//  XQDetailInfoTableViewController.m
//  ASByrApp
//
//  Created by lixiangqian on 17/4/10.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQDetailInfoTableViewController.h"
#import "UIAlertController+Extension.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import <ASByrUser.h>
#import <XQByrUser.h>
#import <YYModel/YYModel.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface XQDetailInfoTableViewController ()<UITableViewDelegate,UITableViewDataSource,ASByrUserResponseDelegate,ASByrUserResponseReformer>

@property (strong, nonatomic) ASByrUser * userApi;
@property (strong, nonatomic) XQByrUser * userModel;

@end

@implementation XQDetailInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.userApi.responseDelegate = self;
    
    self.tableView.allowsSelection = false;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0? 10:9;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        // Configure the cell...
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"XQUserDetailInfoCell"];
    if (self.userModel != nil) {
        switch (10*indexPath.section + indexPath.row) {
            case 0:
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.face_url] placeholderImage:[UIImage imageNamed:XQCOLLECTION_PROFILE_IMAGE] options:SDWebImageRefreshCached];
                [cell.detailTextLabel setText:self.userModel.uid];
                break;
            case 1:
                [cell.textLabel setText:@"名字"];
                [cell.detailTextLabel setText:self.userModel.user_name];
                break;
            case 2:{
                [cell.textLabel setText:@"性别"];
                NSString * gender = [NSString stringWithString:self.userModel.gender];
                if ([gender isEqualToString:@"m"]) {
                    [cell.detailTextLabel setText:@"男"];
                }else if ([gender isEqualToString:@"f"]){
                    [cell.detailTextLabel setText:@"女"];
                }else{
                    [cell.detailTextLabel setText:@"隐藏"];
                }
                break;
            }
            case 3:{
                [cell.textLabel setText:@"星座"];
                if (self.userModel.astro) {
                    [cell.detailTextLabel setText:@"隐藏"];
                }else{
                    [cell.detailTextLabel setText:self.userModel.astro];
                }
                break;
            }
            case 4:
                [cell.textLabel setText:@"生命值"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld",(long)self.userModel.life]];
                break;
                
            case 5:
                [cell.textLabel setText:@"QQ"];
                [cell.detailTextLabel setText:self.userModel.qq];
                break;
                
            case 6:
                [cell.textLabel setText:@"MSN"];
                [cell.detailTextLabel setText:self.userModel.msn];
                break;
                
            case 7:
                [cell.textLabel setText:@"个人主页"];
                [cell.detailTextLabel setText:self.userModel.home_page];
                break;
            case 8:
                [cell.textLabel setText:@"身份"];
                [cell.detailTextLabel setText:self.userModel.level];
                break;
            case 9:
                [cell.textLabel setText:@"状态"];
                [cell.detailTextLabel setText:self.userModel.is_online?@"在线":@"离线"];
                break;
            case 10:
                [cell.textLabel setText:@"发文数量"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld",self.userModel.post_count]];
                break;
            case 11:
                [cell.textLabel setText:@"上次登录时间"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:self.userModel.last_login_time]]];
                break;
            case 12:
                [cell.textLabel setText:@"上次登录IP"];
                [cell.detailTextLabel setText:self.userModel.last_login_ip];
                break;
            case 13:
                [cell.textLabel setText:@"是否隐藏性别和星座"];
                [cell.detailTextLabel setText:self.userModel.is_hide?@"是":@"否"];
                break;
            case 14:
                [cell.textLabel setText:@"是否通过注册审批"];
                [cell.detailTextLabel setText:self.userModel.is_register?@"是":@"否"];
                break;
            case 15:
                [cell.textLabel setText:@"注册时间"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:self.userModel.first_login_time]]];
                break;
            case 16:
                [cell.textLabel setText:@"登录次数"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld",self.userModel.login_count]];
                break;
            case 17:
                [cell.textLabel setText:@"是否为管理员"];
                [cell.detailTextLabel setText:self.userModel.is_admin?@"是":@"否"];
                break;
            case 18:
                [cell.textLabel setText:@"挂站时间"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld",self.userModel.stay_count]];
                break;
            default:
                break;
        };

    }
    return cell;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

#pragma mark <ASByrUserResponseDelegate>
-(void)fetchUserResponse:(ASByrResponse *)response{
    if (response.isSucceeded) {
        self.userModel = [XQByrUser yy_modelWithJSON:response.response];
        [self.tableView reloadData];
    }else{//访问出错：服务器返回错误信息或网络错误
        [self presentViewController:[UIAlertController alertControllerWithBriefInfo:response.response[@"msg"]] animated:YES completion:nil];
    }
}

#pragma mark <ASByrUserResponseReformer>
- (ASByrResponse *)reformUserResponse:(ASByrResponse *)response{
    return response;
}

#pragma mark -private method
- (void)loadData{
    [self.userApi fetchUserInfoWithReformer:self];
}

#pragma mark - getters and setters
- (ASByrUser *)userApi{
    if (_userApi == nil) {
        _userApi = [[ASByrUser alloc]initWithAccessToken:[ASByrToken shareInstance].accessToken];
    }
    return _userApi;
}
@end
