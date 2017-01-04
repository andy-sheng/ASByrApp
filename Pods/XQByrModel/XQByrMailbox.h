//
//  XQByrMailbox.h
//  Pods
//
//  Created by lxq on 1/4/17.
//
//

#import <Foundation/Foundation.h>

@interface XQByrMailbox : NSObject

@property (nonatomic, assign) BOOL new_mail;

@property (nonatomic, copy) NSString *space_used;

@property (nonatomic, assign) BOOL full_mail;

@property (nonatomic, assign) BOOL can_send;

@end
