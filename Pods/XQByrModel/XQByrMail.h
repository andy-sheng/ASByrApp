//
//  XQByrMail.h
//  Pods
//
//  Created by lxq on 1/4/17.
//
//

#import <Foundation/Foundation.h>
@class XQByrAttachment,XQByrUser;

@interface XQByrMail : NSObject

@property (nonatomic, assign) BOOL is_read;

@property (nonatomic, strong) XQByrUser *user;

@property (nonatomic, assign) BOOL has_attachment;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) XQByrAttachment *attachment;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL is_reply;

@property (nonatomic, assign) BOOL is_m;

@property (nonatomic, assign) NSInteger post_time;

@property (nonatomic, copy) NSString *box_name;

@property (nonatomic, assign) NSInteger index;

@end
