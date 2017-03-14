//
//  XQDataBaseQuery.h
//  ASByrApp
//
//  Created by lixiangqian on 17/2/25.
//  Copyright © 2017年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQDataBaseQuery : NSObject

extern NSString * const XQByrDatabaseName;

@property(copy, nonatomic, readonly)NSString * dbName;

@property(copy, nonatomic, readonly)NSString * dbPath;

- (instancetype)initWithDatabaseName:(NSString *)dbname;

- (void)createTable:(NSString *)tbname tableColumn:(NSDictionary *)tableColumnInfo;

- (void)insertDataAtTable:(NSString *)tableName dataInfo:(NSDictionary *)dataInfo;

- (void)updateDataAtTable:(NSString *)tableName dataInfo:(NSDictionary *)dataInfo primaryKey:(NSString *)primaryKey;

- (NSArray *)fetchDataAtTable:(NSString *)tableName ofClass:(Class)className;

//- (id)fetchDataAtTable:(NSString *)tableName ofClass:(Class)className primaryKey:(NSString *)key primaryValue:(NSString *)value;

- (void)deleteDataAtTable:(NSString *)tableName primaryKey:(NSString *)primaryKey keyValue:(NSString *)keyValue;

- (void)createView:(NSString *)fTableName fTableColumn:(NSDictionary*)fTableColumn ftTableColumn:(NSArray *)ftTableColumn;

- (NSArray *)fetchDataAtView;

@end
