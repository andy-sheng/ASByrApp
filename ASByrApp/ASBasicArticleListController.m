
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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"y:%f", self.navigationController.navigationBar.frame.size.height);
//    NSLog(@"y:%f", scrollView.superview.superview.frame.origin.y);
//    NSLog(@"滑动：%f", scrollView.contentOffset.y);
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
