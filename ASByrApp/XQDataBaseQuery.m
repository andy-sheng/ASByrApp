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

static  NSString * const XQArticleUserViewName = @"xq_article_user";

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
        if (obj && obj != (id)[NSNull null]) {
            [columnList addObject:key];
            [dataList addObject:obj];
        }
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
    BOOL result = [self.dbManager updateDataOfTable:tableName columInfo:[dataList componentsJoinedByString:@","] primaryKey:whereQuery error:&error];
    
    if (!result && error) {
        NSLog(@"更新%@ 表中数据发生错误： %@",tableName, error);
    }
}

- (NSArray *)fetchDataAtTable:(NSString *)tableName ofClass:(__unsafe_unretained Class)class{
    NSError * error = nil;
    NSArray * fetchResult = [self.dbManager fetchDataOfTable:tableName class:class error:&error];
    if ((!fetchResult || [fetchResult count]==0) && error) {
        NSLog(@"获取%@ 表中数据发生错误： %@",tableName, error);
    }
    return fetchResult;
}

- (NSArray *)fetchDataAtView{
    NSError * error = nil;
    NSArray * resultList = [self.dbManager fetchDataOfView:XQArticleUserViewName error:&error];
    if (!resultList && error) {
        NSLog(@"获取%@ 视图中数据发生错误： %@",XQArticleUserViewName, error);
    }
    return resultList;
}

//- (id)fetchDataAtTable:(NSString *)tableName ofClass:(Class)className primaryKey:(NSString *)key primaryValue:(NSString *)value{
//    NSError * error = nil;
//    id fetchResult = [self.dbManager fetchDataOfTable:tableName class:className primaryQuery:[NSString stringWithFormat:@"%@ %@",key,value] error:&error];
//    if ((!fetchResult || [fetchResult count]==0) && error) {
//        NSLog(@"更新%@ 表中数据发生错误： %@",tableName, error);
//    }
//    return fetchResult;
//}

- (void)deleteDataAtTable:(NSString *)tableName primaryKey:(NSString *)primaryKey keyValue:(NSString *)keyValue{
    NSError * error = nil;
    [self.dbManager deleteDataOfTable:tableName whereQuery:[NSString stringWithFormat:@"%@ = %@",primaryKey,keyValue] error:&error];
    if (error) {
        NSLog(@"删除%@ 表中数据发生错误： %@",tableName, error);
    }
}


- (void)createView:(NSString *)fTableName fTableColumn:(NSDictionary *)fTableColumn ftTableColumn:(NSArray *)ftTableColumn{
    NSMutableArray __block * fTableColumnList = [[NSMutableArray alloc]init];
    
    NSString * ftTableName;
    NSString * ftTableColumnInfo;
    NSEnumerator * enumeratort = [fTableColumn keyEnumerator];
    id key;
    while ((key = [enumeratort nextObject])!=nil) {
        NSString * obj = fTableColumn[key];
        if ([self p_hasForeignKey:obj]) {
            ftTableName = [self p_findForeignTableName:obj];
            NSString * tfFieldName = [self p_findForeignFieldName:obj];
            ftTableColumnInfo = [NSString stringWithFormat:@"f.%@ = ft.%@",key,tfFieldName];
        }else{
            [fTableColumnList addObject:[NSString stringWithFormat:@"f.%@ as %@",key,key]];
        }
    }
    for (int i = 0; i < [ftTableColumn count]; i++) {
        [fTableColumnList addObject:[NSString stringWithFormat:@"ft.%@ as %@",ftTableColumn[i],ftTableColumn[i]]];
    }
    
    NSError * error = nil;
    [self.dbManager createView:XQArticleUserViewName ftableName:fTableName fTableColumn:[fTableColumnList componentsJoinedByString:@","] ftTableName:ftTableName ftTableColumn:ftTableColumnInfo withError:&error];
    if (error) {
        NSLog(@"创建%@ 视图发生错误： %@",@"xq_view", error);
    }
}

#pragma mark private method
- (BOOL)p_hasForeignKey:(NSString *)str{
    NSRegularExpression * regularFirst = [NSRegularExpression regularExpressionWithPattern:@"(.*)(REFERENCES)(\\s)?(.*)" options:NSRegularExpressionCaseInsensitive error:nil];
    if([regularFirst numberOfMatchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, [str  length])] > 0){
        return true;
    }else{
        return false;
    }
}

- (NSString *)p_findForeignFieldName:(NSString *)str{
    NSRegularExpression * regularSecond = [NSRegularExpression regularExpressionWithPattern:@"\\(.*?\\)" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult * result = [regularSecond firstMatchInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, [str length])];
    if (result.range.length > 0) {
        return [str substringWithRange:NSMakeRange(result.range.location+1, result.range.length-2)];
    }else{
        return @"";
    }
}

- (NSString *)p_findForeignTableName:(NSString *)str{
    NSRegularExpression * regularSecond = [NSRegularExpression regularExpressionWithPattern:@"REFERENCES\\s*.*?\\(" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult * result = [regularSecond firstMatchInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, [str length])];
    if (result.range.length > 0) {
        return [str substringWithRange:NSMakeRange(result.range.location+11, result.range.length-13)];
    }else{
        return @"";
    }
}

@end
