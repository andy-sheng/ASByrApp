//
//  ASTop10ListController.h
//  ASByrApp
//
//  Created by andy on 16/4/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASBasicArticleListController.h"
#import "ASConfig.h"

@interface ASTop10ListController : ASBasicArticleListController

- (instancetype)initWithTitle:(NSString *)title
                    top10Type:(ASTop10Type)top10Type
                    sectionNo:(NSInteger)section;

@end
