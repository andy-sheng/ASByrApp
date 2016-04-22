
//
//  ASBasicArticleListController.m
//  ASByrApp
//
//  Created by andy on 16/4/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASBasicArticleListController.h"

@interface ASBasicArticleListController()

@property(assign, nonatomic) BOOL isLoaded;

@end

@implementation ASBasicArticleListController

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.title = title;
        self.isLoaded = NO;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    }
    return self;
}


- (void)loadData {
    //[self.tableView.mj_header beginRefreshing];
    self.isLoaded = YES;
}

- (void)moreData {
    //[self.tableView.mj_footer beginRefreshing];
}

- (void)loadIfNotLoaded {
    if (!self.isLoaded) {
        [self.tableView.mj_header beginRefreshing];
        [self loadData];
    }
}

@end
