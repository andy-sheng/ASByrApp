//
//  XQDataBaseManager.m
//  ASByrApp
//
//  Created by lixiangqian on 17/2/27.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQDataBaseManager.h"
#import "XQDatabaseConfigurations.h"
#import <YYModel/YYModel.h>
#import <sqlite3.h>

@implementation XQDataBaseManager{
    sqlite3 * _database;
    NSString * _dbpath;
}


-(instancetype)initWithPath:(NSString *)path{
    
    self = [super init];
    _dbpath = [path copy];
    if (SQLITE_OK ==sqlite3_open(path.UTF8String, &_database)) {
        NSLog(@"数据库打开成功！路径  %@",path);
    }else{
        NSLog(@"数据库打开失败！路径 %@ ErrorMsg: %s",path,sqlite3_errmsg(_database));
        return nil;
    }
    return self;
}

- (BOOL)createTable:(NSString *)tableName columnInfo:(NSString *)columnInfo error:(NSError *__autoreleasing *)error{
    
    NSString * sqlQuery = [NSString stringWithFormat:@"PRAGMA foreign_keys = ON; CREATE TABLE %@ (%@)",tableName, columnInfo];
    
    sqlite3_stmt * stmt = NULL;
    int result = sqlite3_prepare_v2(_database, sqlQuery.UTF8String, -1, &stmt, NULL);
    
    if (result != SQLITE_OK) {
        *error = [NSError errorWithDomain:XQDatabaseErrorDomain code:XQDatabaseTableCreateError userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"create database at %@ failed with error:\n %s",_dbpath,sqlite3_errmsg(_database)]}];
        return NO;
    }
    
    //[self p_bindJoinedKeys:[NSArray arrayWithObjects:tableName, columnInfo, nil] stmt:stmt];
    
    result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    if (result != SQLITE_DONE) {
        *error = [NSError errorWithDomain:XQDatabaseErrorDomain code:XQDatabaseTableCreateError userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"create database at %@ failed with error:\n %s",_dbpath,sqlite3_errmsg(_database)]}];
        return NO;
    }
    return YES;
}

- (BOOL)insertDataIntoTable:(NSString *)tableName column:(NSString *)column data:(NSString *)data error:(NSError *__autoreleasing *)error{
    NSString * sqlQuery = [NSString stringWithFormat:@"PRAGMA foreign_keys = ON; INSERT INTO %@ (%@) values (%@)",tableName, column, data];
    
    sqlite3_stmt * stmt = NULL;
    int result = sqlite3_prepare_v2(_database, sqlQuery.UTF8String, -1, &stmt, NULL);
    
    if (result != SQLITE_OK) {
        *error = [NSError errorWithDomain:XQDatabaseErrorDomain code:XQDatabaseTableInsertError userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"insert data into table %@ at %@ failed with error:\n %s",tableName, _dbpath,sqlite3_errmsg(_database)]}];
        return NO;
    }
    
    //[self p_bindJoinedKeys:[NSArray arrayWithObjects:tableName, column, data, nil] stmt:stmt];
    
    result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    if (result != SQLITE_DONE) {
        *error = [NSError errorWithDomain:XQDatabaseErrorDomain code:XQDatabaseTableInsertError userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"insert data into table %@ at %@ failed with error:\n %s",tableName, _dbpath,sqlite3_errmsg(_database)]}];
        return NO;
    }
    return YES;
}

- (BOOL)updateDataOfTable:(NSString *)tableName columInfo:(NSString *)columnInfo primaryKey:(NSString *)primaryKey error:(NSError *__autoreleasing *)error{

    NSString * sqlQuery = [NSString stringWithFormat:@"PRAGMA foreign_keys = ON; UPDATE %@ SET %@ WHERE %@",tableName, columnInfo, primaryKey];
    
    sqlite3_stmt * stmt = NULL;
    int result = sqlite3_prepare_v2(_database, sqlQuery.UTF8String, -1, &stmt, NULL);
    
    if (result != SQLITE_OK) {
        *error = [NSError errorWithDomain:XQDatabaseErrorDomain code:XQDatabaseTableUpdateError userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"update data of table %@ at %@ failed with error:\n %s",tableName, _dbpath,sqlite3_errmsg(_database)]}];
        return NO;
    }
    
    //[self p_bindJoinedKeys:[NSArray arrayWithObjects:tableName, columnInfo, primaryKey, nil] stmt:stmt];
    
    result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    if (result != SQLITE_DONE) {
        *error = [NSError errorWithDomain:XQDatabaseErrorDomain code:XQDatabaseTableUpdateError userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"update data of table %@ at %@ failed with error:\n %s",tableName, _dbpath,sqlite3_errmsg(_database)]}];
        return NO;
    }
    return YES;
}

- (NSArray *)fetchDataOfTable:(NSString *)tableName class:(Class)classType error:(NSError *__autoreleasing *)error{
    NSString * sqlQuery = [NSString stringWithFormat:@"PRAGMA foreign_keys = ON; SELECT * FROM TABLE %@",tableName];
    NSMutableArray *rows=[NSMutableArray array];//数据行
    
    //评估语法正确性
    sqlite3_stmt *stmt;
    //检查语法正确性
    if (SQLITE_OK==sqlite3_prepare_v2(_database, sqlQuery.UTF8String, -1, &stmt, NULL)) {
        //单步执行sql语句
        while (SQLITE_ROW==sqlite3_step(stmt)) {
            int columnCount= sqlite3_column_count(stmt);
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            for (int i=0; i<columnCount; i++) {
                const char *name= sqlite3_column_name(stmt, i);//取得列名
                const unsigned char *value= sqlite3_column_text(stmt, i);//取得某列的值
                if (value) {
                    dic[[NSString stringWithUTF8String:name]]=[NSString stringWithUTF8String:(const char *)value];
                }
            }
            NSObject * object = [classType yy_modelWithDictionary:dic];
            [rows addObject:object];
        }
    }else{
        *error = [NSError errorWithDomain:XQDatabaseErrorDomain code:XQDatabaseTableFetchError userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"update data of table %@ at %@ failed with error:\n %s",tableName, _dbpath,sqlite3_errmsg(_database)]}];
        return nil;

    }
    //释放句柄
    sqlite3_finalize(stmt);
    return rows;
    
}

- (id)fetchDataOfTable:(NSString *)tableName class:(Class)classType primaryQuery:(NSString *)query error:(NSError *__autoreleasing *)error{
    NSString * sqlQuery = [NSString stringWithFormat:@"SELECT * FROM TABLE %@ WHERE %@", tableName, query];
    return [classType yy_modelWithDictionary:[[self p_executeQuery:sqlQuery] firstObject]];

}
- (BOOL)deleteDataOfTable:(NSString *)tableName whereQuery:(NSString *)whereQuery error:(NSError *__autoreleasing *)error{
    NSString * sqlQuery = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",tableName, whereQuery];
    
    sqlite3_stmt * stmt = NULL;
    int result = sqlite3_prepare_v2(_database, sqlQuery.UTF8String, -1, &stmt, NULL);
    
    if (result != SQLITE_OK) {
        *error = [NSError errorWithDomain:XQDatabaseErrorDomain code:XQDatabaseTableDeleteError userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"delete data of table %@ at %@ failed with error:\n %s",tableName, _dbpath,sqlite3_errmsg(_database)]}];
        return NO;
    }
    
    [self p_bindJoinedKeys:[NSArray arrayWithObjects:tableName,whereQuery,nil]  stmt:stmt];
    
    result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    if (result != SQLITE_DONE) {
        *error = [NSError errorWithDomain:XQDatabaseErrorDomain code:XQDatabaseTableDeleteError userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"delete data of table %@ at %@ failed with error:\n %s",tableName, _dbpath,sqlite3_errmsg(_database)]}];
        return NO;
    }
    return YES;
    
}

#pragma mark private method
- (void)p_bindJoinedKeys:(NSArray *)keys stmt:(sqlite3_stmt *)stmt{
    for (int i = 0; i < [keys count]; i++) {
        NSString * key = keys[i];
        sqlite3_bind_text(stmt, i+1, key.UTF8String, -1, NULL);
    }
}

- (void)p_executeNonQuery:(NSString *)sql{
    char *error;
    //单步执行sql语句，用于插入、修改、删除
    if (SQLITE_OK!=sqlite3_exec(_database, sql.UTF8String, NULL, NULL,&error)) {
        NSLog(@"执行SQL语句过程中发生错误！错误信息：%s",error);
        //落掉这一句会memory leak
        sqlite3_free(error);
    }
}

- (NSArray *)p_executeQuery:(NSString *)sql{
    NSMutableArray *rows=[NSMutableArray array];//数据行
    
    //评估语法正确性
    sqlite3_stmt *stmt;
    //检查语法正确性
    if (SQLITE_OK==sqlite3_prepare_v2(_database, sql.UTF8String, -1, &stmt, NULL)) {
        //单步执行sql语句
        while (SQLITE_ROW==sqlite3_step(stmt)) {
            int columnCount= sqlite3_column_count(stmt);
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            for (int i=0; i<columnCount; i++) {
                const char *name= sqlite3_column_name(stmt, i);//取得列名
                const unsigned char *value= sqlite3_column_text(stmt, i);//取得某列的值
                if (value) {
                    dic[[NSString stringWithUTF8String:name]]=[NSString stringWithUTF8String:(const char *)value];
                }
            }
            [rows addObject:dic];
        }
    }else{
        NSLog(@"获取数据库信息错误！%s",sqlite3_errmsg(_database));
    }
    //释放句柄
    sqlite3_finalize(stmt);
    return rows;
}

@end
