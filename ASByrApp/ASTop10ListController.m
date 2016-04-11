//
//  ASTop10ListController.m
//  ASByrApp
//
//  Created by andy on 16/4/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASTop10ListController.h"
#import "ASConfig.h"
#import "ASTop10Cell.h"
#import <ASByrToken.h>
#import <ASByrWidget.h>

#define END_REFRESHING [self.tableView.mj_header endRefreshing];
@interface ASTop10ListController()<ASByrWidgetResponseDelegate, ASByrWidgetResponseReformer>

@property(nonatomic, strong) ASByrWidget *widgerApi;

@property(nonatomic, assign) ASByrTop10Type top10Type;

@property(nonatomic, strong) NSArray *top10;

@property(nonatomic, assign) NSInteger sectionNo;

@end

@implementation ASTop10ListController

#pragma mark - lifecycle

- (instancetype)initWithTitle:(NSString *)title
                    top10Type:(ASByrTop10Type)top10Type
                    sectionNo:(NSInteger)section{
    self = [super initWithTitle:title];
    if (self) {
        self.sectionNo = section;
        self.top10Type = top10Type;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 100.0;
        [self.tableView registerNib:[UINib nibWithNibName:@"ASTop10Cell" bundle:nil] forCellReuseIdentifier:@"test"];
        //[self.tableView registerClass:[ASTop10Cell class] forCellReuseIdentifier:@"test"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.widgerApi = [[ASByrWidget alloc] initWithAccessToken:[[ASByrToken alloc] initFromStorage].accessToken];
    self.widgerApi.responseDelegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.top10 count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASTop10Cell *cell = (ASTop10Cell*)[tableView dequeueReusableCellWithIdentifier:@"test"];
    cell.title.text = self.top10[indexPath.row][@"title"];
    cell.content.text = self.top10[indexPath.row][@"content"];
    return cell;
}




# pragma mark - private function

- (void)loadData {
    [super loadData];
    switch (self.top10Type) {
        case ASByrSectiontop:
            [self.widgerApi fetchSectionTopWithSectionNo:self.sectionNo reformer:self];
            break;
        case ASByrRecommend:
            [self.widgerApi fetchRecommendWithReformer:self];
            break;
        default:
            [self.widgerApi fetchTop10WithReformer:self];
            break;
    }
}

- (void)moreData {
    [super moreData];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - ASByrWidgetResponseDelegate

- (void)fetchTop10Response:(ASByrResponse *)response {
    [self commenResponseRecv:response];
}

- (void)fetchRecommendResponse:(ASByrResponse *)response {
    [self commenResponseRecv:response];
}

- (void)fetchSectionTopResponse:(ASByrResponse *)response {
    [self commenResponseRecv:response];
}

- (void)commenResponseRecv:(ASByrResponse*)response {
    self.top10 = response.reformedData;
    [self.tableView reloadData];
    END_REFRESHING
}

#pragma mark - ASByrWidgetResponseReformer 

- (ASByrResponse*) reformTop10Response:(ASByrResponse *)response {
    return [self commenReformer:response];
}

- (ASByrResponse*)reformRecommendResponse:(ASByrResponse *)response {
    return [self commenReformer:response];
}

- (ASByrResponse*)reformSectionTopResponse:(ASByrResponse *)response {
    return [self commenReformer:response];
}

- (ASByrResponse*)commenReformer:(ASByrResponse*)response {
    if (response.statusCode >= 200 && response.statusCode < 300) {
        NSMutableArray * reformedData = [[NSMutableArray alloc] init];
        for (NSDictionary* article in response.response[@"article"]) {
            NSMutableDictionary * reformedArticle = [[NSMutableDictionary alloc] init];
            reformedArticle[@"title"] = article[@"title"];
            reformedArticle[@"aid"]   = article[@"id"];
            reformedArticle[@"content"] = article[@"content"];
            [reformedData addObject:reformedArticle];
        }
        response.reformedData = [reformedData copy];
        response.isSucceeded = YES;
    } else {
        response.isSucceeded = NO;
    }
    return response;
}


@end
