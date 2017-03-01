//
//  XQCollectDataCenter.m
//  ASByrApp
//
//  Created by lixiangqian on 17/1/6.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQCollectDataCenter.h"
#import "XQByrUserTable.h"
#import "XQByrArticleTable.h"

#import <XQByrArticle.h>
#import <XQByrAttachment.h>
#import <XQByrCollection.h>
#import <XQByrFile.h>
#import <XQByrUser.h>
#import <YYModel/YYModel.h>


#define XQDatabaseLock() dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER)
#define XQDatabaseUnlock() dispatch_semaphore_signal(self->_lock)
@interface XQCollectDataCenter()

@property (strong, nonatomic) XQByrUserTable * userService;
@property (strong, nonatomic) XQByrArticleTable * articleService;

@end

@implementation XQCollectDataCenter{
    dispatch_queue_t _queue;
    dispatch_semaphore_t _lock;
}

- (instancetype)init{
    if(self = [super init]){
        _userService = [[XQByrUserTable alloc]init];
        _articleService = [[XQByrArticleTable alloc]init];
        _queue = dispatch_queue_create("com.BUPT.ASByrApp.collect.database", DISPATCH_QUEUE_CONCURRENT);
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)fetchCollectListFromLocal:(NSDictionary * __nullable)filters withBlock:(void(^__nullable)( NSArray * __nullable objects))block{
    //暂时不考虑处理横向切片(将有图的帖子和无图的帖子分开)的情况
//    __weak typeof(self) _self = self;
//    dispatch_async(_queue, ^{
//        __strong typeof(_self) self = _self;
//        
//        XQDatabaseLock();
        NSMutableArray * articleArray =[NSMutableArray arrayWithArray:[self.articleService findAllRecord]];
//        XQDatabaseUnlock();
    
        for (NSInteger i = 0; i < [articleArray count]; i++) {
            XQByrCollection * articleDic = articleArray[i];
            if ([articleDic valueForKey:@"user"]) {
                NSString * userID = [articleDic valueForKey:@"user"];
//                XQDatabaseLock();
                XQByrUser * userDic = (XQByrUser *)[self.userService findRecordByPrimaryValue:userID];
//                XQDatabaseUnlock();
                [articleDic setUser:userDic];
            }else{
                XQByrUser * user = [[XQByrUser alloc]init];
                user.user_name = @"unknown";
                [articleDic setUser:user];
            }
            articleArray[i] = articleDic;
        }
        if(block) block(articleArray);
//    });
}

- (void)saveCollectDataFromCollections:(NSArray *)array withBlock:(void (^ _Nullable)(void))block{
    if (array == nil || [array count] == 0) {
        return;
    }
//    __weak typeof(self) _self = self;
//    dispatch_async(_queue, ^{
//        __strong typeof(_self) self = _self;
        for (NSInteger i = 0; i < [array count]; i++) {
            
            XQByrCollection* collection = (XQByrCollection *)[array objectAtIndex:i];
            collection.fristImageUrl = @"";
            XQByrUser * user = [[XQByrUser alloc]init];
            if (collection.user){
                if([collection.user isKindOfClass:[XQByrUser class]]){
                    user = collection.user;
                }else{
                    user.uid = (NSString *)collection.user;
                    user.user_name = @"";
                }
//                XQDatabaseLock();
                [self.userService insertRecord:user];
//                XQDatabaseUnlock();
            }
            //collection.user = user;
//            XQDatabaseLock();
            [self.articleService insertRecord:collection];
//            XQDatabaseUnlock();
        }
        if (block) block();
//    });
}

- (void)addCollectData:(XQByrArticle *)article withBlock:(void (^ _Nullable)(void))block{
//    __weak typeof(self) _self = self;
//    dispatch_async(_queue, ^{
//        __strong typeof(_self) self = _self;

        XQByrCollection * collection = [self p_articleToCollection:article];
        XQByrUser * user = [[XQByrUser alloc]init];
        if ([article.user isKindOfClass:[XQByrUser class]]){
            user = article.user;
        }else{
            user.face_url = @"";
            user.uid = (NSString *)article.user;
        }
//        XQDatabaseLock();
        [self.userService insertRecord:user];
//        XQDatabaseUnlock();
        collection.user = user;
//        XQDatabaseLock();
        [self.articleService insertRecord:collection];
//        XQDatabaseUnlock();
        if (block) block();
//    });
}

- (void)updateCollectData:(XQByrArticle *)article options:(XQCollectionUpdateType)type withBlock:(void (^ _Nullable)(void))block{
//    __weak typeof(self) _self = self;
//    dispatch_async(_queue, ^{
//        __strong typeof(_self) self = _self;
    XQByrCollection * collection = [self p_articleToCollection:article];
    
//    XQDatabaseLock();
    [self.articleService updateRecord:collection];
//    XQDatabaseUnlock();
    if (block) block();

//    });
}

- (void)deleteCollectData:(NSString *)articleID withBlock:(void (^ _Nullable)(NSString * articleID))block{
//    __weak typeof(self) _self = self;
//    dispatch_async(_queue, ^{
//        __strong typeof(_self) self = _self;
//        XQDatabaseLock();
    XQByrCollection * collection = [[XQByrCollection alloc]init];
    collection.gid = articleID;
    [self.articleService deleteRecord:collection];
//        XQDatabaseUnlock();
        if (block) {
            block(articleID);
        }
//    });
}

- (void)deleteAllCollectDataWithBlock:(void (^)(void))block{
//    __weak typeof(self) _self = self;
//    dispatch_async(_queue, ^{
//        __strong typeof(_self) self = _self;
//        XQDatabaseLock();
        //[self.articleService deleteArticle:nil];
        //[self.userService deleteAllUser];
//        XQDatabaseUnlock();
        if (block) {
            block();
        }
//    });
}

#pragma mark private method
- (XQByrCollection *)p_articleToCollection:(XQByrArticle *)article{

    XQByrCollection * collection = [[XQByrCollection alloc]init];
    
    XQByrArticle * childArticle = [XQByrArticle yy_modelWithDictionary:(NSDictionary *)[article.article firstObject]];
    
    if (article.has_attachment) {
        XQByrAttachment * attachment;
        NSDictionary * filedic;
        if(article.attachment != nil){
            attachment = article.attachment;
            filedic = [[NSArray arrayWithArray:attachment.file] firstObject];
        }else{
            attachment = childArticle.attachment;
            filedic = [[NSArray arrayWithArray:attachment.file] firstObject];
        }
        collection.fristImageUrl = filedic[@"url"];
    }
    
    collection.state = 2;
    collection.replyCount = article.reply_count;
    collection.gid = [NSString stringWithFormat:@"%ld",(long)article.group_id];
    collection.bname = article.board_name;
    collection.title = article.title;
    collection.postTime = [NSString stringWithFormat:@"%ld",(long)article.post_time];
    return collection;
}

@end
