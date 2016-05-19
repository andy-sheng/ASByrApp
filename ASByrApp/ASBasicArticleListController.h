//
//  ASBasicArticleListController.h
//  ASByrApp
//
//  Created by andy on 16/4/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface ASBasicArticleListController : UITableViewController
@property(assign, nonatomic) BOOL isLoaded;


- (instancetype)initWithTitle:(NSString*) title;

- (void)loadIfNotLoaded;

- (void)loadData;

- (void)moreData;

@end
