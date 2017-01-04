//
//  XQByrRefer.h
//  Pods
//
//  Created by lxq on 1/4/17.
//
//

#import <Foundation/Foundation.h>

@class XQByrPagination,XQByrReference,XQByrUser;
@class XQByrUser;
@interface XQByrRefer : NSObject

@property (nonatomic, strong) XQByrPagination *pagination;

@property (nonatomic, strong) NSArray<XQByrReference *> *article;

@property (nonatomic, copy) NSString *description;

@end

@interface XQByrReference : NSObject


@property (nonatomic, strong) XQByrUser *user;

@property (nonatomic, assign) BOOL is_read;

@property (nonatomic, assign) NSInteger group_id;

@property (nonatomic, assign) NSInteger rid;

@property (nonatomic, copy) NSString *board_name;

@property (nonatomic, assign) NSInteger reply_id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, assign) NSInteger pos;

@property (nonatomic, assign) NSInteger index;

@end