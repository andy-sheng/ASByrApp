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
        
        NSString * createTimeMax = [[NSUserDefaults standardUserDefaults]objectForKey:@"XQCollectCreatedTimeMax"];
        if (createTimeMax == nil) {
            createTimeMax = @"";
        }
        _createdTimeMax = createTimeMax;
    }
    return self;
}


- (void)fetchCollectListFromLocalWithPage:(NSInteger)page pageCount:(NSInteger)count withBlock:(void(^__nullable)( NSArray * __nullable objects))block{

    //暂时不考虑处理横向切片(将有图的帖子和无图的帖子分开)的情况
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        NSArray * articleArray =[NSArray arrayWithArray:[self.articleService findRecordWithPage:page pageCount:count]];
    
        if(block) block(articleArray);
    });
}

- (void)saveCollectDataFromCollections:(NSArray *)array withBlock:(void (^ _Nullable)(void))block{
    if (array == nil || [array count] == 0) {
        return;
    }
    NSArray * _array = [NSArray arrayWithArray:array];
   
        for (NSInteger i = 0; i < [_array count]; i++) {
            
            XQByrCollection* collection = [(XQByrCollection *)[_array objectAtIndex:i] copy];
            if (self.firstLoad == YES || [_createdTimeMax isEqualToString:@""] || (self.firstLoad == NO && [collection.createdTime compare:_createdTimeMax options:NSNumericSearch]==NSOrderedDescending)) {
                collection.state = XQCollectionStateSync;
                collection.firstImageUrl = @"";
                XQByrUser * user;
                if (collection.user){
                    if([collection.user isKindOfClass:[XQByrUser class]]){
                        user = [collection.user copy];
                    }else{
                        user.uid = (NSString *)collection.user;
                        user.user_name = @"";
                    }
                    [self.userService insertRecord:user];
                }
                [self.articleService insertRecord:collection];
                self.createdTimeMax = collection.createdTime;
            }
        }
        if (block) block();
}

- (void)compareCollectDataFromCollectons:(NSArray *)array withPage:(NSInteger)page pageCount:(NSInteger)count withBlock:(void (^)(void))block{
    
    //dispatch_queue_t backgroundqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    //dispatch_async(_queue, ^{
        NSArray * haveArticles = [self.articleService findRecordWithPage:page pageCount:count];
        
        NSInteger i = 0, j = 0;
        NSInteger lastj = 0;
        if (haveArticles != nil && [haveArticles count]>0) {
            NSDictionary * collection;
            while (i < [array count]) {
                if (j == [haveArticles count]) {
                    haveArticles = [self.articleService findRecordWithPage:page pageCount:count];
                    j = lastj;
                }
                collection = [haveArticles objectAtIndex:j];
                if (([collection[@"createdTime"] compare:[[array objectAtIndex:i] valueForKey:@"createdTime"] options:NSLiteralSearch] == NSOrderedAscending)) {
                    i++;
                }else if([collection[@"createdTime"] compare:[[array objectAtIndex:i] valueForKey:@"createdTime"] options:NSLiteralSearch] == NSOrderedDescending){
                    j++;
                    [self.articleService deleteRecord:[collection copy]];
                }else{
                    i++;
                    j++;
                    lastj ++;
                }

            }
        }
    //});
}

- (void)addCollectData:(XQByrArticle *)article withBlock:(void (^ _Nullable)(void))block{

    XQByrCollection * collection = [self p_articleToCollection:article withType:XQCollectionUpdateUserAdd];
    
    [self.userService insertRecord:collection.user];
    [self.articleService insertRecord:collection];
    if (block) block();
}

- (void)updateCollectFromArticle:(XQByrArticle * __nonnull)article withBlock:(void(^__nullable)(void))block{

    XQByrCollection * collection = [self p_articleToCollection:article withType:XQCollectionUpdateContent];
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        [self.articleService updateRecord:collection];
        if (block) block();
    });
}

- (void)updateCollect:(XQByrCollection *)collection withBlock:(void (^)(void))block{
    
    XQByrCollection * collect = [[XQByrCollection alloc]init];
    collect.gid = collection.gid;
    collect.state = XQCollectionStateSync;
    collect.createdTime = collection.createdTime;
    
    [self.articleService updateRecord:collect];
    
    if (block) block();
}


- (void)deleteCollectData:(NSString *)articleID withBlock:(void (^ _Nullable)(NSString * articleID))block{
    dispatch_async(_queue, ^{
        XQByrCollection * collection = [[XQByrCollection alloc]init];
        collection.gid = articleID;
        [self.articleService deleteRecord:collection];
        if (block) block(articleID);
    });
}

- (void)deleteAllCollectDataWithBlock:(void (^)(void))block{

        if (block) {
            block();
        }
}

#pragma mark private method
- (XQByrCollection *)p_articleToCollection:(XQByrArticle *)article withType:(XQCollectionUpdateType)type{

    XQByrCollection * collection = [[XQByrCollection alloc]init];
    
    //设置附件
    XQByrArticle * childArticle = [XQByrArticle yy_modelWithDictionary:(NSDictionary *)[article.article firstObject]];
    
    if (article.has_attachment) {
        XQByrAttachment * attachment;
        XQByrFile * filedic;
        if(article.attachment != nil){
            attachment = article.attachment;
            filedic = [[NSArray arrayWithArray:attachment.file] firstObject];
        }else{
            attachment = childArticle.attachment;
            filedic = [[NSArray arrayWithArray:attachment.file] firstObject];
        }
        collection.firstImageUrl = filedic.staticUrl;
    }
    
    //设置主键
    collection.gid = [NSString stringWithFormat:@"%ld",(long)article.group_id];
    
    if (type == XQCollectionUpdateContent) {
        collection.replyCount = article.reply_count;
    }else if(type == XQCollectionUpdateUserAdd){
        collection.state = XQCollectionStateAdd;

        XQByrUser * user = [[XQByrUser alloc]init];
        if ([article.user isKindOfClass:[XQByrUser class]]){
            user = article.user;
        }else{
            user.face_url = @"";
            user.uid = (NSString *)article.user;
        }
        
        collection.user = user;
        collection.replyCount = article.reply_count;
        collection.bname = article.board_name;
        collection.title = article.title;
        collection.postTime = [NSString stringWithFormat:@"%ld",(long)article.post_time];
        
        //获取当前时间戳
        NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval interval = [date timeIntervalSince1970];
        collection.createdTime = [NSString stringWithFormat:@"%0.f",interval];
        
    }
    return collection;
}

- (BOOL)needSave:(NSString *)createdTime{
    if ([self.createdTimeMax isEqualToString:@""]) {
        return true;
    }
    return true;
}

#pragma mark getters and setters
- (void)setCreatedTimeMax:(NSString *)createdTimeMax{
    if ([self.createdTimeMax isEqualToString:@""] ||( [createdTimeMax compare:self.createdTimeMax options:NSNumericSearch] == NSOrderedAscending && !_firstLoad)) {
        _createdTimeMax = createdTimeMax;
        [[NSUserDefaults standardUserDefaults]setObject:createdTimeMax forKey:@"XQCollectCreatedTimeMax"];
    }
}

- (BOOL)firstLoad{
    if (!_firstLoad) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"XQCollectFirstLoad"] == nil) {
            _firstLoad = true;
        }else{
            _firstLoad = false;
        }
    }
    return _firstLoad;
}

@end
