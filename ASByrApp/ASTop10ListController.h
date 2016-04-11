//
//  ASTop10ListController.h
//  ASByrApp
//
//  Created by andy on 16/4/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASBasicArticleListController.h"

typedef enum{
    ASByrTop10,
    ASByrRecommend,
    ASByrSectiontop
} ASByrTop10Type;

@interface ASTop10ListController : ASBasicArticleListController

- (instancetype)initWithTitle:(NSString *)title
                    top10Type:(ASByrTop10Type)top10Type
                    sectionNo:(NSInteger)section;

@end
