//
//  XQByrBoard.h
//  Pods
//
//  Created by lxq on 1/4/17.
//
//

#import <Foundation/Foundation.h>

@class XQByrPagination,XQByrArticle,XQByrUser;
@interface XQByrBoard : NSObject

@property (nonatomic, assign) NSInteger post_all_count;

@property (nonatomic, assign) BOOL is_read_only;

@property (nonatomic, assign) BOOL is_no_reply;

@property (nonatomic, copy) NSString *clazz;

@property (nonatomic, assign) BOOL allow_post;

@property (nonatomic, strong) XQByrPagination *pagination;

@property (nonatomic, assign) BOOL is_favorite;

@property (nonatomic, assign) NSInteger post_threads_count;

@property (nonatomic, assign) BOOL allow_outgo;

@property (nonatomic, assign) NSInteger post_today_count;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL allow_attachment;

@property (nonatomic, assign) NSInteger user_online_max_time;

@property (nonatomic, strong) NSArray<XQByrArticle *> *article;

@property (nonatomic, assign) BOOL allow_anonymous;

@property (nonatomic, assign) NSInteger user_online_count;

@property (nonatomic, assign) NSInteger user_online_max_count;

@property (nonatomic, copy) NSString *manager;

@property (nonatomic, assign) NSInteger threads_today_count;

@property (nonatomic, copy) NSString *section;

@property (nonatomic, copy) NSString *description;

@end