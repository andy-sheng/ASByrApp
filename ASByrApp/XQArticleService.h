//
//  XQArticleService.h
//  ASByrApp
//
//  Created by lxq on 16/9/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XQSingleton.h"
@class XQArticle;
@interface XQArticleService : NSObject

+ (NSArray *)getAllArticles;

- (void)addArticle:(XQArticle *)article;

- (void)removeArticle:(XQArticle *)article;

- (void)modifyArticle:(XQArticle *)article;

+ (XQArticle *)getArticleById:(NSString *)articleID;
@end
