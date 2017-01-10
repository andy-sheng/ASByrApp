//
//  XQByrUser.h
//  Pods
//
//  Created by lxq on 1/4/17.
//
//

#import <Foundation/Foundation.h>

@interface XQByrUser : NSObject

@property (nonatomic, copy) NSString *home_page;

@property (nonatomic, assign) NSInteger face_width;

@property (nonatomic, copy) NSString *astro;

@property (nonatomic, assign) NSInteger last_login_time;

@property (nonatomic, assign) BOOL is_hide;

@property (nonatomic, assign) NSInteger life;

@property (nonatomic, assign) BOOL is_online;

@property (nonatomic, assign) BOOL is_register;

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, assign) BOOL is_follow;

@property (nonatomic, copy) NSString *msn;

@property (nonatomic, assign) NSInteger fans_num;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, assign) BOOL is_fan;

@property (nonatomic, assign) NSInteger follow_num;

@property (nonatomic, assign) NSInteger face_height;

@property (nonatomic, assign) NSInteger post_count;

@property (nonatomic, copy) NSString *face_url;

@property (nonatomic, copy) NSString *qq;

@property (nonatomic, copy) NSString *last_login_ip;

@property (nonatomic, copy) NSString *user_name;

//以下几项存在于当前登陆用户为 自己或是当前用户具有管理权限
@property (nonatomic, assign) NSInteger first_login_time;

@property (nonatomic, assign) NSInteger login_count;

@property (nonatomic, assign) NSInteger stay_count;

@property (nonatomic, assign) BOOL is_admin;

@end