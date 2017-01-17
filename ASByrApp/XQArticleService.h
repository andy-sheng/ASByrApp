//
//  XQArticleService.h
//  ASByrApp
//
//  Created by lxq on 16/9/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XQSingleton.h"
@class XQByrArticle, XQByrCollection;
@interface XQArticleService : NSObject

+ (NSArray * _Nullable)getAllArticles;

- (void)addArticle:(XQByrArticle * _Nonnull)article andParameters:(NSDictionary * _Nonnull)parameters;

- (void)addArticleWithCollection:(XQByrCollection * _Nonnull )article andParameters:(NSDictionary * _Nonnull)parameters;

+ (NSDictionary * _Nullable)getArticleById:(NSString * __nonnull)articleID;

+ (NSArray * _Nullable)getArticlesByFilters:(NSDictionary * _Nonnull)filters;

@end
