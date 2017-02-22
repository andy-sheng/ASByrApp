//
//  XQCollectDataCenter.m
//  ASByrApp
//
//  Created by lixiangqian on 17/1/6.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQCollectDataCenter.h"
#import "XQArticleService.h"
#import "XQUserService.h"

#import <XQByrArticle.h>
#import <XQByrAttachment.h>
#import <XQByrCollection.h>
#import <XQByrFile.h>
#import <XQByrUser.h>
#import <YYModel/YYModel.h>


@interface XQCollectDataCenter()

@property (strong, nonatomic) XQUserService * userService;
@property (strong, nonatomic) XQArticleService * articleService;

@end

@implementation XQCollectDataCenter{
    dispatch_queue_t _queue;
}

- (instancetype)init{
    if(self = [super init]){
        _userService = [[XQUserService alloc]init];
        _articleService = [[XQArticleService alloc]init];
        _queue = dispatch_queue_create("com.BUPT.ASByrApp.collect.database", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)fetchCollectListFromLocal:(NSDictionary * __nullable)filters withBlock:(void(^__nullable)( NSArray * __nullable objects))block{
    //暂时不考虑处理横向切片(将有图的帖子和无图的帖子分开)的情况
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        NSMutableArray * articleArray =[NSMutableArray arrayWithArray:[self.articleService getArticlesByFilters:filters]];
        for (NSInteger i = 0; i < [articleArray count]; i++) {
            NSMutableDictionary * articleDic = [NSMutableDictionary dictionaryWithDictionary:articleArray[i]];
            if ([articleDic objectForKey:@"author"]) {
                NSString * userID = articleDic[@"author"];
                NSDictionary * userDic = [self.userService getUserById:userID];
                [articleDic addEntriesFromDictionary:userDic];
            }else{
                articleDic[@"userName"] = @"unknown";
            }
            articleArray[i] = articleDic;
        }
        if(block) block(articleArray);
    });
}

- (void)saveCollectDataFromCollections:(NSArray *)array withBlock:(void (^ _Nullable)(void))block{
    if (array == nil || [array count] == 0) {
        return;
    }
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        for (NSInteger i = 0; i < [array count]; i++) {
            
            XQByrCollection* collection = (XQByrCollection *)[array objectAtIndex:i];
            XQByrUser * user = [[XQByrUser alloc]init];
            if (collection.user){
                if([collection.user isKindOfClass:[XQByrUser class]]){
                    user = collection.user;
                }else{
                    user.uid = (NSString *)collection.user;
                    user.user_name = @"";
                }
                [self.userService addUser:user];
            }
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:user.uid,@"userID",nil];
            [self.articleService addArticleWithCollection:(XQByrCollection *)[array objectAtIndex:i] andParameters:dic];
            if (block) block();
        }
    });
}

- (void)addCollectData:(XQByrArticle *)article withBlock:(void (^ _Nullable)(void))block{
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;

        NSString * firstImageUrl = @"";
    
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
            firstImageUrl = filedic[@"url"];
        }
    
        //文章正文在子数组中时需要对content单独赋值
        if(article.content == nil){
            article.content = childArticle.content;
        }
    
        XQByrUser * user = [[XQByrUser alloc]init];
        if ([article.user isKindOfClass:[XQByrUser class]]){
            user = article.user;
        }else{
            user.face_url = @"";
            user.uid = (NSString *)article.user;
        }
        [self.userService addUser:user];
    
        NSDictionary * parameters = [NSDictionary dictionaryWithObjectsAndKeys:user.uid,@"userID",firstImageUrl,@"firstImageUrl", nil];
        [self.articleService addArticle:article andParameters:parameters];
        if (block) block();
    });
}

- (void)updateCollectData:(XQByrArticle *)article options:(XQCollectionUpdateType)type withBlock:(void (^ _Nullable)(void))block{
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
    NSString * articleID = [NSString stringWithFormat:@"%ld",(long)article.group_id];
    NSDictionary * parameters;
    switch (type) {
        case XQCollectionUpdateContent:
            if (article.has_attachment) {
                NSString * firstImageUrl = @"";
                //NSString * content = @"";
                XQByrAttachment * attachment;
                XQByrFile * file;
                attachment = article.attachment;
                
                file = [XQByrFile yy_modelWithDictionary:[NSArray arrayWithArray:attachment.file][0]];
                firstImageUrl = file.url;
                parameters = [NSDictionary dictionaryWithObjectsAndKeys:firstImageUrl,@"firstImageUrl",article.board_description,@"boardDescription",[NSNumber numberWithInteger:article.reply_count],@"replyCount",nil];
            }else{
                parameters = [NSDictionary dictionaryWithObjectsAndKeys:article.board_description,@"boardDescription",[NSNumber numberWithInteger:article.reply_count],@"replyCount",nil];
            }
            break;
        case XQCollectionUpdateReply:
            parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:article.reply_count],@"replyCount",nil];
            break;
    }
    [self.articleService updateArticle:articleID andParameters:parameters];
    if (block) block();

    });
}

- (void)deleteCollectData:(NSString *)articleID withBlock:(void (^ _Nullable)(NSString * articleID))block{
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        [self.articleService deleteArticle:articleID];
        if (block) {
            block(articleID);
        }
    });
}

- (void)deleteAllCollectDataWithBlock:(void (^)(void))block{
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        [self.articleService deleteArticle:nil];
        [self.userService deleteAllUser];
        if (block) {
            block();
        }
    });
}
@end
