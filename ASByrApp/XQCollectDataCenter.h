//
//  XQCollectDataCenter.h
//  ASByrApp
//
//  Created by lixiangqian on 17/1/6.
//  Copyright © 2017年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XQCollectionUpdateType){
    //update after enter the article detail
    XQCollectionUpdateContent,
    //update after fetch from the server
    XQCollectionUpdateReply
};

@class XQByrArticle,XQByrCollection;
@interface XQCollectDataCenter : NSObject

- (NSArray * __nullable)fetchCollectListFromLocal:(NSDictionary * __nullable)filters;

- (BOOL)saveCollectDataFromCollections:(NSArray * _Nullable)array;
- (BOOL)addCollectData:(XQByrArticle * __nonnull)article;

- (void)updateCollectData:(XQByrArticle * __nonnull)article options:(XQCollectionUpdateType)type;

- (void)deleteCollectData:(NSString * __nonnull)articleID;

- (void)deleteAllCollectData;
@end
