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

- (void)fetchCollectListFromLocal:(NSDictionary * __nullable)filters withBlock:(void(^__nullable)(NSArray * __nullable objects))block;

- (void)saveCollectDataFromCollections:(NSArray * _Nullable)array withBlock:(void(^__nullable)(void))block;

- (void)addCollectData:(XQByrArticle * __nonnull)article withBlock:(void(^__nullable)(void))block;

- (void)updateCollectData:(XQByrArticle * __nonnull)article options:(XQCollectionUpdateType)type withBlock:(void(^__nullable)(void))block;

- (void)deleteCollectData:(NSString * __nonnull)articleID withBlock:(void(^__nullable)(NSString * __nonnull articleID))block;

- (void)deleteAllCollectDataWithBlock:(void(^__nullable)(void))block;

@end
