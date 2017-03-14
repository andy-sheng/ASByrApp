//
//  XQDataBaseManager.h
//  ASByrApp
//
//  Created by lixiangqian on 17/2/27.
//  Copyright © 2017年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQDataBaseManager : NSObject

-(instancetype)initWithPath:(NSString *)path;

- (BOOL)createTable:(NSString *)tableName columnInfo:(NSString *)columnInfo error:(NSError * __autoreleasing *)error;

- (BOOL)insertDataIntoTable:(NSString *)tableName column:(NSString *)column data:(NSString *)data error:(NSError *__autoreleasing *)error;

- (BOOL)updateDataOfTable:(NSString *)tableName columInfo:(NSString *)columnInfo primaryKey:(NSString *)primaryKey error:(NSError *__autoreleasing *)error;

- (NSArray *)fetchDataOfTable:(NSString *)tableName class:(Class)classType error:(NSError * __autoreleasing *)error;

//- (id)fetchDataOfTable:(NSString *)tableName class:(Class)classType primaryQuery:(NSString *)query error:(NSError * __autoreleasing *)error;

- (BOOL)deleteDataOfTable:(NSString *)tableName whereQuery:(NSString *)whereQuery error:(NSError * __autoreleasing *)error;

- (BOOL)createView:(NSString *)viewName ftableName:(NSString *)fTableName fTableColumn:(NSString *)fTableColumnInfo ftTableName:(NSString *)ftTableName  ftTableColumn:(NSString *)ftTableColumnInfo withError:(NSError *__autoreleasing *)error;

- (NSArray *)fetchDataOfView:(NSString *)viewName error:(NSError *__autoreleasing *)error;
@end
