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
#import <XQByrPagination.h>
#import <YYModel/YYModel.h>

@interface XQCollectArticleViewModel()

@property (strong, nonatomic) NSArray * arrayList;

@end

@implementation XQCollectArticleViewModel{
    NSInteger _count;
    dispatch_semaphore_t _semaphore;
}

- (instancetype)init{
    if (self = [super init]) {
        _arrayList = [[NSArray alloc]init];
        _databaseArrayList = [[NSArray alloc]init];
        _collectionApi = [[ASByrCollection alloc]initWithAccessToken:[ASByrToken shareInstance].accessToken];
        _collectDataCenter = [[XQCollectDataCenter alloc]init];
        _count = 10;
        _page = 0;
        _semaphore = dispatch_semaphore_create(1);
        [self setUp];
    }
    return self;
}

- (void)setUp{
    @weakify(self);
    [RACObserve(self, page) subscribeNext:^(id x) {
        @strongify(self);
        if (self.collectDataCenter.firstLoad == YES) {//第一次加载，加载网络层
            [self.collectionApi fetchCollectionsWithCount:_count page:_page SuccessBlock:^(NSInteger statusCode, id response) {
                NSMutableArray * reformedArticles = [NSMutableArray array];
                for(NSDictionary * article in response[@"article"]){
                    XQByrCollection * collection = [XQByrCollection yy_modelWithJSON:article];
                    [reformedArticles addObject:collection];
                }
                if ([reformedArticles count] > 0) {
                    self.arrayList = reformedArticles;
                }
                XQByrPagination * pagination = [XQByrPagination yy_modelWithDictionary:response[@"pagination"]];
                _maxPage = [NSNumber numberWithInteger:pagination.page_all_count];
                [[NSUserDefaults standardUserDefaults]setObject:_maxPage forKey:@"XQCollectMaxPage"];
            } failureBlock:nil];
            
        }else{
            @strongify(self);
            [self.collectionApi fetchCollectionsWithCount:_count page:_page SuccessBlock:^(NSInteger statusCode, id response) {
                NSMutableArray * reformedArticles = [NSMutableArray array];
                for(NSDictionary * article in response[@"article"]){
                    XQByrCollection * collection = [XQByrCollection yy_modelWithJSON:article];
                    if ([self.collectDataCenter.createdTimeMax compare:collection.createdTime options:NSNumericSearch] == NSOrderedAscending) {
                        [reformedArticles addObject:collection];
                    }
                }
                
                if ([reformedArticles count] > 0) {//从网站上新取下来的数据
                    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
                    self.arrayList = reformedArticles;
                    dispatch_semaphore_signal(_semaphore);
                }
                
                //＝＝＝＝＝＝＝＝＝＝＝＝从数据库取剩下的数据
                NSInteger nextCount = [response[@"article"] count] < _count? _count: [response[@"article"] count] - [reformedArticles count];
                if (nextCount > 0 && _page > 0) {
                    [self.collectDataCenter fetchCollectListFromLocalWithPage:_page pageCount:nextCount withBlock:^(NSArray * _Nullable objects) {
                        if (objects && [objects count]>0) {
                            dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
                            self.arrayList = objects;
                            dispatch_semaphore_signal(_semaphore);
                        }
                    }];
                }

                XQByrPagination * pagination = [XQByrPagination yy_modelWithDictionary:response[@"pagination"]];
                _maxPage = [NSNumber numberWithInteger:pagination.page_all_count];
                [[NSUserDefaults standardUserDefaults]setObject:_maxPage forKey:@"XQCollectMaxPage"];
            } failureBlock:^(NSInteger statusCode, id response) {
                @strongify(self);
                if (_page > 0) {//防止是NSInteger初始化时的0
                    [self.collectDataCenter fetchCollectListFromLocalWithPage:_page pageCount:_count withBlock:^(NSArray * _Nullable objects) {
                        if (objects && [objects count]>0) {
                            self.arrayList = objects;
                        }
                    }];
                }
            }];
        }
    }];
     
    
    [RACObserve(self, arrayList) subscribeNext:^(id x) {
        @strongify(self);
        
        id firstItem = [x firstObject];
        if (firstItem && [firstItem isKindOfClass:[XQByrCollection class]]) {
            dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
            [self.collectDataCenter saveCollectDataFromCollections:x withBlock:nil];
            dispatch_semaphore_signal(_semaphore);
        }
    }];
}

- (void)endDatabaseInitialSave{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"XQCollectFirstLoad"];
    self.collectDataCenter.firstLoad = NO;
}

#pragma mark - getters and setters

- (NSNumber *)maxPage{
    if (_maxPage == nil) {
        NSNumber * maxpage = [[NSUserDefaults standardUserDefaults]objectForKey:@"XQCollectMaxPage"];
        if (maxpage) {
            _maxPage = maxpage;
        }
    }
    return _maxPage;
}
@end
