//
//  XQByrCollection.h
//  Pods
//
//  Created by lxq on 1/4/17.
//
//

#import <Foundation/Foundation.h>

@class XQByrUser;
@interface XQByrCollection : NSObject

@property (nonatomic, strong) XQByrUser *user;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger createdTime;

@property (nonatomic, assign) NSInteger postTime;

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, assign) NSInteger gid;

@property (nonatomic, copy) NSString *bname;

@end
