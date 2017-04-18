//
//  XQThreadsDetailViewModel.h
//  ASByrApp
//
//  Created by lixiangqian on 17/2/4.
//  Copyright © 2017年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class XQByrArticle;
@interface XQThreadsDetailViewModel : NSObject

@property(strong, nonatomic) XQByrArticle * articleEntity;

@property(copy, nonatomic) NSString * title;

- (instancetype)initWithArticleDic:(NSDictionary *)articelDic;


- (NSString *)getContentHtmlString;

- (void)setArticleEntity:(NSDictionary *)articleEntity replyCount:(NSInteger)replyCount;
@end
