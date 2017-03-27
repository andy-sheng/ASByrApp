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
            } failureBlock:^(NSInteger statusCode, id response) {
                @strongify(self);
                if (_page > 0) {//防止是NSInteger初始化时的0
                    [self.collectDataCenter fetchCollectListFromLocalWithPage:_page pageCount:_count withBlock:^(NSArray * _Nullable objects) {
                        if (objects && [objects count]>0) {
                            self.databaseArrayList = objects;
                        }
                    }];
                }
            }
        ];
    }];
     
            
    
    [RACObserve(self, arrayList) subscribeNext:^(id x) {
        @strongify(self);
        
        XQByrCollection * firstItem = [x firstObject];
        if (firstItem && ([firstItem.createdTime compare:self.collectDataCenter.createdTimeMax options:NSNumericSearch] == NSOrderedDescending || self.collectDataCenter.firstLoad)) {
            dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
            [self.collectDataCenter saveCollectDataFromCollections:x withBlock:nil];
            dispatch_semaphore_signal(_semaphore);
        }
        
        if (_page > 0) {
            dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
            [self.collectDataCenter fetchCollectListFromLocalWithPage:_page pageCount:_count withBlock:^(NSArray * _Nullable objects) {
                if (objects && [objects count]>0) {
                    self.databaseArrayList = objects;
                }
            }];
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
