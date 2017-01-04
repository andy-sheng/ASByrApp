//
//  XQByrAttachment.h
//  Pods
//
//  Created by lxq on 1/4/17.
//
//

#import <Foundation/Foundation.h>
@class XQByrFile;
@interface XQByrAttachment : NSObject

@property (nonatomic, assign) NSInteger remain_count;

@property (nonatomic, strong) NSArray<XQByrFile *> *file;

@property (nonatomic, copy) NSString *remain_space;

@end
