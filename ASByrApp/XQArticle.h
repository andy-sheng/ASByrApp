//
//  XQArticle.h
//  ASByrApp
//
//  Created by lxq on 16/9/2.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XQUserEntity;

@interface XQArticle : NSObject

#pragma mark 文章id
@property (copy, nonatomic) NSString * articleID;

#pragma mark 作者user
@property (strong, nonatomic) XQUserEntity * author;

#pragma mark 文章标题title
@property (copy, nonatomic) NSString * title;

#pragma mark 版面名称board_name
@property (copy, nonatomic) NSString * boardName;

#pragma mark 版面描述board_description
@property (copy, nonatomic) NSString * boardDescription;

#pragma mark 文章内容article[0].content
@property (copy, nonatomic) NSString * content;

#pragma mark 图片地址article[0].attchment.file[0].url
@property (copy, nonatomic) NSString * firstImageUrl;

#pragma mark 时间
@property (copy, nonatomic) NSString * collectTime;

#pragma mark -动态方法

/**
 *  初始化收藏文章
 *
 *  @param articleID 文章id
 *  @param auther 作者对象
 *  @param title 标题title
 *  @param boardName 版面名称board_name
 *
 *  @return 文章对象
 */
- (id)initWithArticleID:(NSString *)articleID auther:(XQUserEntity *)auther title:(NSString *)title boardName:(NSString *)boardName boardDescription:(NSString *)boardDescription content:(NSString *)content firstImageUrl:(NSString *)firstImageUrl;

- (id)initWithArticleID:(NSString *)articleID autherID:(NSString *)autherID title:(NSString *)title boardName:(NSString *)boardName boardDescription:(NSString *)boardDescription content:(NSString *)content firstImageUrl:(NSString *)firstImageUrl;

/**
 *  使用字典初始化收藏文章
 *
 *  @param dic 文章数据
 *
 *  @return 文章对象
 */
- (id)initWithDictionary:(NSDictionary *)dic;

#pragma mark -静态方法

+ (XQArticle *)articleWithArticleID:(NSString *)articleID auther:(XQUserEntity *)auther title:(NSString *)title boardName:(NSString *)boardName boardDescription:(NSString *)boardDescription content:(NSString *)content firstImageUrl:(NSString *)firstImageUrl;

+ (XQArticle *)articleWithArticleID:(NSString *)articleID autherID:(NSString *)autherID title:(NSString *)title boardName:(NSString *)boardName boardDescription:(NSString *)boardDescription content:(NSString *)content firstImageUrl:(NSString *)firstImageUrl;

@end
