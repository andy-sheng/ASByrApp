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

@end

@interface XQTableBaseExecutor : NSObject

@property (weak, nonatomic, readonly) id<XQTableBaseExecutorProtocol> tableProtocol;

- (void)insertRecord:(NSObject *)record;

- (void)updateRecord:(NSObject *)record;

- (void)deleteRecord:(NSObject *)record;

- (NSArray *)findAllRecord;

- (id)findRecordByPrimaryValue:(NSString *)primaryValue;
@end
