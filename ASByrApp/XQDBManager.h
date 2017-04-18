//
//  XQDBManager.h
//  ASByrApp
//
//  Created by lixiangqian on 17/2/22.
//  Copyright © 2017年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "XQSingleton.h"

@interface XQDBManager : NSObject

singleton_interface(XQDBManager)

@property (nonatomic) sqlite3 *database;

#pragma mark - 共有方法
/**
 *  打开数据库
 *
 *  @param dbname 数据库名称
 */
-(void)openDb:(NSString *)dbname;

/**
 *  关闭数据库
 *
 */
-(void)closeDb;

/**
 *  执行无返回值的sql
 *
 *  @param sql sql语句
 */
-(void)executeNonQuery:(NSString *)sql;

/**
 *  执行有返回值的sql
 *
 *  @param sql sql语句
 *
 *  @return 查询结果
 */
-(NSArray *)executeQuery:(NSString *)sql;

@end
