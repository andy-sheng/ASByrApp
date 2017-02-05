//
//  XQThreadsDetailViewModel.h
//  ASByrApp
//
//  Created by lixiangqian on 17/2/4.
//  Copyright © 2017年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XQByrArticle;
@interface XQThreadsDetailViewModel : NSObject

@property(strong, nonatomic) XQByrArticle * articleEntity;
@property(assign, nonatomic) NSString * title;
- (instancetype)initWithArticleDic:(NSDictionary *)articelDic;

- (NSString *)getContentHtmlString;
@end
