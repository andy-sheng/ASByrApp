//
//  XQArticleService.h
//  ASByrApp
//
//  Created by lxq on 16/9/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XQByrArticle, XQByrCollection;

typedef NS_ENUM(NSInteger, XQByrCollectionSyncType){
    XQByrCollectionSyncNormal,
    XQByrCollectionSyncNew,
    XQByrCollectionSyncDelete
};

@interface XQArticleService : NSObject

- (NSArray * _Nullable)getAllArticles;

- (void)addArticle:(XQByrArticle * _Nonnull)article andParameters:(NSDictionary * _Nonnull)parameters;

- (void)addArticleWithCollection:(XQByrCollection * _Nonnull )article andParameters:(NSDictionary * _Nonnull)parameters;

- (NSDictionary * _Nullable)getArticleById:(NSString * __nonnull)articleID;

- (NSArray * _Nullable)getArticlesByFilters:(NSDictionary * _Nonnull)filters;

- (void)updateArticle:(NSString * _Nonnull)articleID andParameters:(NSDictionary * _Nonnull)dic;

- (void)deleteArticle:(NSString * _Nullable)articleID;
@end
