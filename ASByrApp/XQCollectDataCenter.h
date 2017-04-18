//
//  XQCollectDataCenter.h
//  ASByrApp
//
//  Created by lixiangqian on 17/1/6.
//  Copyright © 2017年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, XQCollectionUpdateType){
    //update after enter the article detail
    XQCollectionUpdateContent,
    //update after add article from user motion
    XQCollectionUpdateUserAdd,
    //update after receive add success msg from the server 这种是用collection存储
    //XQCollectionUpdateStateReceive
};

typedef NS_ENUM(NSInteger, XQCollectionStateType){
    //刚添加
    XQCollectionStateAdd,
    //待删除
    XQCollectionStateDelete,
    //和服务器同步
    XQCollectionStateSync
};

@class XQByrArticle,XQByrCollection;

@interface XQCollectDataCenter : NSObject

@property (assign, nonatomic) BOOL firstLoad;

@property (copy, nonatomic) NSString * __nullable createdTimeMax;

- (void)fetchCollectListFromLocalWithPage:(NSInteger)page pageCount:(NSInteger)count withBlock:(void(^__nullable)( NSArray * __nullable objects))block;

- (void)saveCollectDataFromCollections:(NSArray * _Nullable)array withBlock:(void(^__nullable)(void))block;

- (void)compareCollectDataFromCollectons:(NSArray * _Nullable)array withPage:(NSInteger)page pageCount:(NSInteger)count withBlock:(void(^__nullable)(void))block;

- (void)addCollectData:(XQByrArticle * __nonnull)article withBlock:(void(^__nullable)(void))block;

- (void)updateCollectFromArticle:(XQByrArticle * __nonnull)article withBlock:(void(^__nullable)(void))block;

- (void)updateCollect:(XQByrCollection * __nonnull)collection withBlock:(void (^__nullable)(void))block;

- (void)deleteCollectData:(NSString * __nonnull)articleID withBlock:(void(^__nullable)(NSString * __nonnull articleID))block;

- (void)deleteAllCollectDataWithBlock:(void(^__nullable)(void))block;

@end
