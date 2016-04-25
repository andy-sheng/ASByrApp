//
//  ASArticleListVC.h
//  ASByrApp
//
//  Created by andy on 16/4/18.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASBasicArticleListController.h"
#import <UIKit/UIKit.h>

@interface ASArticleListVC :ASBasicArticleListController
- (instancetype)initWithNameAndTitle:(NSString *)boardName boardTitle:(NSString *)title;

- (void)updateBarTheme;
@end
