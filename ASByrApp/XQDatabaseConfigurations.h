//
//  XQDatabaseConfigurations.h
//  ASByrApp
//
//  Created by lixiangqian on 17/2/25.
//  Copyright © 2017年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const XQDatabaseErrorDomain = @"XQDatabaseErrorDomain";

typedef NS_ENUM (NSInteger, XQDatabaseErrorKey){
    XQDatabaseOpenError,
    
    XQDatabaseTableCreateError,
    
    XQDatabaseTableInsertError,
    
    XQDatabaseTableUpdateError,
    
    XQDatabaseTableDeleteError,
    
    XQDatabaseTableFetchError,
    
    XQDatabaseTableTransactionInsertError,
    
    XQDatabaseTableTransactionUpdateError,
    
    XQDataBaseViewCreateError,
    
    XQDatabaseMigrationError,
    
    XQDatabaseDefaultError
};
