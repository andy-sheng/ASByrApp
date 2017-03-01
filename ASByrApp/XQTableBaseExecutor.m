//
//  XQTableBaseExecutor.m
//  ASByrApp
//
//  Created by lixiangqian on 17/2/25.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQTableBaseExecutor.h"
#import "XQDataBaseQuery.h"


@interface XQTableBaseExecutor()

@property (weak, nonatomic) id<XQTableBaseExecutorProtocol> tableProtocol;

@property (strong, nonatomic) XQDataBaseQuery * databaseQuery;

@end

@implementation XQTableBaseExecutor

- (instancetype)init{
    self = [super init];
    if (self && [self conformsToProtocol:@protocol(XQTableBaseExecutorProtocol)]) {
        _tableProtocol = (XQTableBaseExecutor<XQTableBaseExecutorProtocol> *)self;
        XQDataBaseQuery * dataBaseQuery= [[XQDataBaseQuery alloc]initWithDatabaseName:self.tableProtocol.databaseName];
        if (dataBaseQuery) {
            [dataBaseQuery createTable:self.tableProtocol.tableName tableColumn:self.tableProtocol.tableColumnInfo];
        }
        _databaseQuery = dataBaseQuery;
    }else{
        NSLog(@"Create Database Error: Persistance table must comform to protocal XQTableBaseExecutorProtocal.");
    }
    return self;
}

- (void)insertRecord:(NSObject *)record{
    NSMutableDictionary * __block dictionary = [NSMutableDictionary dictionary];
    NSLog(@"%@",self.tableProtocol.tableColumnInfo);
    [self.tableProtocol.tableColumnInfo enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSString *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString * o = [record valueForKey:key];
        NSLog(@"%@",key);
        if (o!=nil) {
            NSLog(@"%@",o);
            NSRegularExpression * regularFirst = [NSRegularExpression regularExpressionWithPattern:@".*FOREGIN KEY.*" options:NSRegularExpressionCaseInsensitive error:nil];
            if([regularFirst numberOfMatchesInString:obj options:NSMatchingReportCompletion range:NSMakeRange(0, [obj count])] > 0){
                NSRegularExpression * regularSecond = [NSRegularExpression regularExpressionWithPattern:@"\\(.*?\\)" options:NSRegularExpressionCaseInsensitive error:nil];
                NSTextCheckingResult * result = [regularSecond firstMatchInString:obj options:NSMatchingReportCompletion range:NSMakeRange(0, [obj count])];
                result
            }
            [dictionary setObject:o forKey:key];
        }
    }];
    [self.databaseQuery insertDataAtTable:_tableProtocol.tableName dataInfo:dictionary];
}

- (void)updateRecord:(NSObject *)record{
    NSMutableDictionary * __block dictionary = [NSMutableDictionary dictionary];
    [self.tableProtocol.tableColumnInfo enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSString *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([record valueForKey:key]!=nil) {
            [dictionary setObject:[record valueForKey:key] forKey:key];
        }
    }];
    [self.databaseQuery updateDataAtTable:_tableProtocol.tableName dataInfo:dictionary primaryKey:_tableProtocol.primaryKey];
}

- (NSArray *)findAllRecord{
    return [self.databaseQuery fetchDataAtTable:_tableProtocol.tableName ofClass:_tableProtocol.tableClass];
}

- (void)deleteRecord:(NSObject *)record{
    if ([record valueForKey:_tableProtocol.primaryKey]!=nil) {
        [self.databaseQuery deleteDataAtTable:_tableProtocol.tableName primaryKey:_tableProtocol.primaryKey keyValue:[record valueForKey:_tableProtocol.primaryKey]];
    }
}

- (id)findRecordByPrimaryValue:(NSString *)primaryValue{
    return [self.databaseQuery fetchDataAtTable:_tableProtocol.tableName ofClass:_tableProtocol.tableClass primaryKey:_tableProtocol.primaryKey primaryValue:primaryValue];
}

@end
