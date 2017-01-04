//
//  XQByrVote.h
//  Pods
//
//  Created by lxq on 1/4/17.
//
//

#import <Foundation/Foundation.h>

@class XQByrVoted,XQByrVoteOptions,XQByrUser;
@interface XQByrVote : NSObject

@property (nonatomic, copy) NSString *start;

@property (nonatomic, strong) NSArray<XQByrVoteOptions *> *options;

@property (nonatomic, copy) NSString *user_count;

@property (nonatomic, copy) NSString *vid;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL is_result_voted;

#warning 如果用户没投票则为false
@property (nonatomic, strong) XQByrVoted *voted;

@property (nonatomic, copy) NSString *limit;

@property (nonatomic, assign) NSInteger vote_count;

@property (nonatomic, assign) BOOL is_deleted;

@property (nonatomic, copy) NSString *end;

@property (nonatomic, assign) BOOL is_end;

@property (nonatomic, strong) XQByrUser *user;

@property (nonatomic, copy) NSString *aid;

@property (nonatomic, strong) XQByrVoted *vote_status;

@end
@interface XQByrVoted : NSObject

@property (nonatomic, strong) NSArray<NSString *> *viid;

@property (nonatomic, copy) NSString *time;

@end

@interface XQByrVoteOptions : NSObject

@property (nonatomic, copy) NSString *viid;

@property (nonatomic, copy) NSString *label;

@property (nonatomic, copy) NSString *num;

@end

