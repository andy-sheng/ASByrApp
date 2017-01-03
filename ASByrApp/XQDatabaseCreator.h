//
//  XQDatabaseCreator.h
//  ASByrApp
//
//  Created by lxq on 16/9/4.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQDatabaseCreator : NSObject

+ (void)createDatabase;

+ (void)closeDatabase;

+ (void)openDatabase;
@end
