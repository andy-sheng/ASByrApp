//
//  XQDataBaseQuery.m
//  ASByrApp
//
//  Created by lixiangqian on 17/2/25.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQDataBaseQuery.h"
#import "XQDatabaseConfigurations.h"
#import "XQDataBaseManager.h"

@interface XQDataBaseQuery()

@property (copy, nonatomic, readwrite) NSString * dbName;
@property (copy, nonatomic, readwrite) NSString * dbPath;

@property (strong, nonatomic) XQDataBaseManager * dbManager;

@end

@implementation XQDataBaseQuery

NSString * const XQByrDatabaseName = @"XQByrDatabase.db";

- (instancetype)init{
    return [self initWithDatabaseName:XQByrDatabaseName];
}

- (instancetype)initWithDatabaseName:(NSString *)dbname{
    self = [super init];
    if (self) {
        
        _dbName = dbname;
        NSString *directory=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath=[directory stringByAppendingPathComponent:dbname];
        _dbPath = filePath;
        
        XQDataBaseManager * dbManager = [[XQDataBaseManager alloc]initWithPath:filePath];
        
        if (!dbManager) {
            return nil;
        }
        _dbManager = dbManager;
    }
    return self;
}

- (void)createTable:(NSString *)tbname tableColumn:(NSDictionary *)tableColumnInfo{
    
    NSMutableArray __block * columnList = [[NSMutableArray alloc]init];
    
    NSEnumerator * enumerator = [tableColumnInfo keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])!=nil) {
        NSString * obj = tableColumnInfo[key];
        [columnList addObject:[NSString stringWithFormat:@"%@ %@",key,obj]];
    }
    
    NSError * error = nil;
    BOOL result = [self.dbManager createTable:tbname columnInfo:[columnList componentsJoinedByString:@","] error:&error];
    
    if (!result && error) {
        NSLog(@"新建Table发生错误： %@",error);
    }
}

- (void)insertDataAtTable:(NSString *)tableName dataInfo:(NSDictionary *)dataInfo{
    NSMutableArray __block * columnList = [[NSMutableArray alloc]init];
    
    NSMutableArray __block * dataList = [[NSMutableArray alloc]init];
    
    NSEnumerator * enumerator = [dataInfo keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])!=nil) {
        NSString * obj = dataInfo[key];
        [columnList addObject:key];
        [dataList addObject:obj];
    }
    
    NSError * error = nil;
    BOOL result = [self.dbManager insertDataIntoTable:tableName column:[columnList componentsJoinedByString:@","] data:[dataList componentsJoinedByString:@","] error:&error];
    
    if (!result && error) {
        NSLog(@"向%@ 表中插入数据发生错误： %@",tableName, error);
    }
}

- (void)updateDataAtTable:(NSString *)tableName dataInfo:(NSDictionary *)dataInfo primaryKey:(NSString *)primaryKey{
    
    NSMutableArray __block * dataList = [[NSMutableArray alloc]init];
    
    NSMutableString __block * whereQuery = [[NSMutableString alloc]init];
    
    NSEnumerator * enumerator = [dataInfo keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])!=nil) {
        NSString * obj = dataInfo[key];
        if ([key isEqualToString:primaryKey]) {
            [whereQuery setString:[NSString stringWithFormat:@"%@ = %@",key,obj]
             ];
        }else if(obj && ![obj isEqualToString:@""]){
            NSMutableString *dataQuery = [NSMutableString stringWithFormat:@"%@ = %@",key,obj];
            [dataList addObject:dataQuery];
        }
    }
    
    NSError * error = nil;
    BOOL result = [self.dbManager updateDataOfTable:tableName columInfo:[dataList componentsJoinedByString:@","] primaryKey:primaryKey error:&error];
    
    if (!result && error) {
        NSLog(@"更新%@ 表中数据发生错误： %@",tableName, error);
    }
}

- (NSArray *)fetchDataAtTable:(NSString *)tableName ofClass:(__unsafe_unretained Class)class{
    NSError * error = nil;
    NSArray * fetchResult = [self.dbManager fetchDataOfTable:tableName class:class error:&error];
    if ((!fetchResult || [fetchResult count]==0) && error) {
        NSLog(@"更新%@ 表中数据发生错误： %@",tableName, error);
    }
    return fetchResult;
}

- (id)fetchDataAtTable:(NSString *)tableName ofClass:(Class)className primaryKey:(NSString *)key primaryValue:(NSString *)value{
    NSError * error = nil;
    id fetchResult = [self.dbManager fetchDataOfTable:tableName class:className primaryQuery:[NSString stringWithFormat:@"%@ %@",key,value] error:&error];
    if ((!fetchResult || [fetchResult count]==0) && error) {
        NSLog(@"更新%@ 表中数据发生错误： %@",tableName, error);
    }
    return fetchResult;
}
- (void)deleteDataAtTable:(NSString *)tableName primaryKey:(NSString *)primaryKey keyValue:(NSString *)keyValue{
    NSError * error = nil;
    [self.dbManager deleteDataOfTable:tableName whereQuery:[NSString stringWithFormat:@"%@ = %@",primaryKey,keyValue] error:&error];
    if (error) {
        NSLog(@"删除%@ 表中数据发生错误： %@",tableName, error);
    }
}

#pragma mark private method

@end
