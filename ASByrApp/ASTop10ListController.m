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
#import "ASTop10SeperatorCell.h"
#import "ASThreadsController.h"
#import "ASByrToken.h"
#import "ASByrWidget.h"

#define END_REFRESHING [self.tableView.mj_header endRefreshing];

@interface ASTop10ListController()<ASByrWidgetResponseDelegate, ASByrWidgetResponseReformer>

@property(nonatomic, strong) ASByrWidget *widgerApi;

@property(nonatomic, assign) ASTop10Type top10Type;

@property(nonatomic, strong) NSArray *top10;

@property(nonatomic, assign) NSInteger sectionNo;

@end

@implementation ASTop10ListController

#pragma mark - lifecycle

- (instancetype)initWithTitle:(NSString *)title
                    top10Type:(ASTop10Type)top10Type
                    sectionNo:(NSInteger)section{
    self = [super initWithTitle:title];
    if (self) {
        self.sectionNo = section;
        self.top10Type = top10Type;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 100.0;
        [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg3.png"]]];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView registerNib:[UINib nibWithNibName:@"ASTop10Cell" bundle:nil] forCellReuseIdentifier:@"ASTop10Cell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"ASTop10SeperatorCell" bundle:nil] forCellReuseIdentifier:@"ASTop10SeperatorCell"];
        //[self.tableView registerClass:[ASTop10Cell class] forCellReuseIdentifier:@"test"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //NSLog(@"accesstoken:%@", [ASByrToken shareInstance].accessToken);
    self.widgerApi = [[ASByrWidget alloc] initWithAccessToken:[ASByrToken shareInstance].accessToken];
    NSLog(@"%@", [ASByrToken shareInstance].accessToken);
    self.widgerApi.responseDelegate = self;
    //self.widgerApi
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.top10 count] * 2 - 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        ASTop10Cell *cell = (ASTop10Cell*)[tableView dequeueReusableCellWithIdentifier:@"ASTop10Cell"];
        [cell setupWithface:self.top10[indexPath.row / 2][@"user"][@"face"]
                        uid:self.top10[indexPath.row / 2][@"user"][@"uid"]
                      title:self.top10[indexPath.row / 2][@"title"]
                    content:self.top10[indexPath.row / 2][@"content"]
                        num:indexPath.row / 2 + 1];
        return cell;
    } else {
        ASTop10SeperatorCell *cell = (ASTop10SeperatorCell*)[tableView dequeueReusableCellWithIdentifier:@"ASTop10SeperatorCell"];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        return UITableViewAutomaticDimension;
    } else {
        return 30;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", indexPath.row);
    if (indexPath.row % 2 == 0) {
        ASThreadsController *threadsVC = [[ASThreadsController alloc] initWithWithBoard:self.top10[indexPath.row / 2][@"board"]
                                                                                    aid:[self.top10[indexPath.row / 2][@"aid"] integerValue]];
        [self.navigationController pushViewController:threadsVC animated:YES];
    }
}



# pragma mark - private function

- (void)loadData {
    [super loadData];
    switch (self.top10Type) {
        case ASSectionTop:
            [self.widgerApi fetchSectionTopWithSectionNo:self.sectionNo reformer:self];
            break;
        case ASRecommend:
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
            reformedArticle[@"title"]   = article[@"title"];
            reformedArticle[@"aid"]     = article[@"id"];
            reformedArticle[@"content"] = article[@"content"];
            reformedArticle[@"board"]   = article[@"board_name"];
            if ([article objectForKey:@"user"] != nil && [article objectForKey:@"user"] != [NSNull null]) {
                reformedArticle[@"user"]    = @{@"face": [article[@"user"] objectForKey:@"face_url"] ?: @"",
                                                @"uid": [article[@"user"] objectForKey:@"id"] ?: @""};
            } else {
                reformedArticle[@"user"]    = @{@"face": @"",
                                                @"uid": @"unknown" };
            }
            
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
