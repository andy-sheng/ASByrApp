//
//  XQTableBaseExecutor.h
//  ASByrApp
//
//  Created by lixiangqian on 17/2/25.
//  Copyright © 2017年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@protocol XQTableBaseExecutorProtocol <NSObject>

@required

- (NSString *)databaseName;

- (NSString *)tableName;

- (NSDictionary *)tableColumnInfo;

- (Class)tableClass;

- (NSString *)primaryKey;

@optional

- (Class)foreignTableClass;

- (Class)foreignModelClass;

@end

@protocol XQForeignTableBaseProtocol <NSObject>

@required

- (NSArray *)foreignColumnInfo;

@end

@interface XQTableBaseExecutor : NSObject

@property (weak, nonatomic, readonly) id<XQTableBaseExecutorProtocol> tableProtocol;

- (instancetype)initDatabase;

- (void)insertRecord:(NSObject *)record;

- (void)updateRecord:(NSObject *)record;

- (void)deleteRecord:(NSObject *)record;

- (NSArray *)findRecordWithPage:(NSInteger)page pageCount:(NSInteger)pageCount;

@end
