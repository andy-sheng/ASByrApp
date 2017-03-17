//
//  XQCollectArticleViewModel.m
//  ASByrApp
//
//  Created by lixiangqian on 17/3/14.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQCollectArticleViewModel.h"
#import "XQCollectDataCenter.h"
#import <ASByrCollection.h>
#import <XQByrCollection.h>
#import <YYModel/YYModel.h>

@interface XQCollectArticleViewModel()


@end

@implementation XQCollectArticleViewModel{
    NSInteger _page;
    NSInteger _count;
}

- (instancetype)init{
    if (self = [super init]) {
        _count = 10;
        _page = 1;
        _fetchCollectionCommand = [self setUpRACCommand];
    }
    return self;
}


- (RACCommand *)setUpRACCommand{
    @weakify(self);
    RACCommand * command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            [self.collectionApi fetchCollectionsWithCount:_count page:_page SuccessBlock:^(NSInteger statusCode, id response) {
                NSMutableArray * reformedArticles = [NSMutableArray array];
                for(NSDictionary * article in response[@"article"]){
                    XQByrCollection * collection = [XQByrCollection yy_modelWithJSON:article];
                    [reformedArticles addObject:collection];
                }
            if ([reformedArticles count] > 0) {
                    [subscriber sendNext:reformedArticles];
            }
            if((NSInteger)response[@"pagination"][@"page_current_count"] < (NSInteger)response[@"pagination"][@"page_all_count"]) {
                     _page=(NSInteger)response[@"pagination"][@"page_current_count"]+1;
                }else{
                    NSLog(@"send completed");
                    [subscriber sendCompleted];
                }
                
                
            } failureBlock:^(NSInteger statusCode, id response) {
                NSLog(@"error %@",response);
                [subscriber sendError:nil];
            }];
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"racdisposable log.");
            }];
        }];
    }];
    return command;
}

#pragma mark - getters and setters
- (ASByrCollection *)collectionApi{
    if (_collectionApi == nil) {
        _collectionApi = [[ASByrCollection alloc]initWithAccessToken:[ASByrToken shareInstance].accessToken];
    }
    return _collectionApi;
}

- (XQCollectDataCenter *)collectDataCenter{
    if (_collectDataCenter == nil) {
        _collectDataCenter = [[XQCollectDataCenter alloc]init];
    }
    return _collectDataCenter;
}
@end
