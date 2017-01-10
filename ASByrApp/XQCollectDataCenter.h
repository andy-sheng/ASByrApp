//
//  XQCollectDataCenter.h
//  ASByrApp
//
//  Created by lixiangqian on 17/1/6.
//  Copyright © 2017年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XQByrArticle;
@interface XQCollectDataCenter : NSObject

- (NSArray * __nullable)fetchCollectListFromLocal:(NSDictionary * __nullable)filters;

- (BOOL)addCollectData:(XQByrArticle * __nonnull)article;

@end
