//
//  XQTableBaseExecutor.m
//  ASByrApp
//
//  Created by lixiangqian on 17/2/25.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQTableBaseExecutor.h"
#import "XQDataBaseQuery.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface XQTableBaseExecutor()

@property (weak, nonatomic) id<XQTableBaseExecutorProtocol> tableProtocol;

@property (strong, nonatomic) XQDataBaseQuery * databaseQuery;

@end

static void * xqdatabaseforeignkey = "xqdbforeigntablekey";

@implementation XQTableBaseExecutor

- (instancetype)initDatabase{
    self = [super init];
    if (self && [self conformsToProtocol:@protocol(XQTableBaseExecutorProtocol)]) {
        _tableProtocol = (XQTableBaseExecutor<XQTableBaseExecutorProtocol> *)self;
        XQDataBaseQuery * dataBaseQuery= [[XQDataBaseQuery alloc]initWithDatabaseName:self.tableProtocol.databaseName];
        if (dataBaseQuery) {
            [dataBaseQuery createTable:self.tableProtocol.tableName tableColumn:self.tableProtocol.tableColumnInfo];
        }
        if ([_tableProtocol respondsToSelector:@selector(foreignTableClass)]) {
            Class cl = self.tableProtocol.foreignTableClass;
            id clobj = [[cl alloc]init];
            if (clobj && [clobj isKindOfClass:[XQTableBaseExecutor class]]) {
                NSArray * ftTableColumn = [clobj foreignColumnInfo];
                [dataBaseQuery createView:self.tableProtocol.tableName fTableColumn:self.tableProtocol.tableColumnInfo ftTableColumn:ftTableColumn];
            }
        }
        _databaseQuery = dataBaseQuery;
    }else{
        NSLog(@"Create Database Error: Persistance table must comform to protocal XQTableBaseExecutorProtocal.");
    }
    return self;
}

- (void)insertRecord:(NSObject *)record{
    NSDictionary * dictionary = [self p_changeObjectToDictionary:record];
    [self.databaseQuery insertDataAtTable:_tableProtocol.tableName dataInfo:dictionary];
}

- (void)updateRecord:(NSObject *)record{
    NSDictionary * dictionary = [self p_changeObjectToDictionary:record];
    
    [self.databaseQuery updateDataAtTable:_tableProtocol.tableName dataInfo:dictionary primaryKey:_tableProtocol.primaryKey];
}

//只有在article类中会调用 待优化
- (NSArray *)findRecordWithPage:(NSInteger)page pageCount:(NSInteger)pageCount{
    return [self.databaseQuery fetchDataAtViewWithLimit:pageCount offset:(page-1)*pageCount];
}

- (void)deleteRecord:(NSObject *)record{
    if ([record valueForKey:_tableProtocol.primaryKey]!=nil) {
        [self.databaseQuery deleteDataAtTable:_tableProtocol.tableName primaryKey:_tableProtocol.primaryKey keyValue:[record valueForKey:_tableProtocol.primaryKey]];
    }
}

//- (id)findRecordByPrimaryValue:(NSString *)primaryValue{
//    return [self.databaseQuery fetchDataAtTable:_tableProtocol.tableName ofClass:_tableProtocol.tableClass primaryKey:_tableProtocol.primaryKey primaryValue:primaryValue];
//}


#pragma mark -- private method
-(void)dealloc{
    if ([_tableProtocol respondsToSelector:@selector(foreignTableClass)]) {
        objc_setAssociatedObject(self, xqdatabaseforeignkey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

- (NSDictionary *)p_changeObjectToDictionary:(NSObject *)record{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    NSLog(@"%@",self.tableProtocol.tableColumnInfo);
    
    NSEnumerator * enumerator = [self.tableProtocol.tableColumnInfo keyEnumerator];
    id key;
    while ((key = [enumerator nextObject]) != nil) {
        NSString * obj = [self.tableProtocol.tableColumnInfo objectForKey:key];
        id o = [record valueForKey:key];
        if (o!=nil){
            if ([self.tableProtocol respondsToSelector:@selector(foreignTableClass)]&&[o isKindOfClass:self.tableProtocol.foreignModelClass]) {
                NSString * tkey = [self p_findForeignFieldName:obj];
                id oo = [o valueForKey:tkey];
                if (oo!=nil) {
                    [dictionary setObject:[NSString stringWithFormat:@"\"%@\"",oo] forKey:key];
                }
            }else if(![o isEqual:@""]){
                [dictionary setObject:[NSString stringWithFormat:@"\"%@\"",o] forKey:key];
            }
        }
    }
    return dictionary;
}
@end
