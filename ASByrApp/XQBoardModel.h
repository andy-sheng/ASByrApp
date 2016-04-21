//
//  XQBoardModel.h
//  ASByrApp
//
//  Created by lxq on 16/4/20.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQBoardModel : NSObject
- (instancetype) initWithFullInfo:(NSString *)name
                    boardDescrip:(NSString *)descirp
                     boardParent:(NSString *)parentName
                      boardColor:(NSString *)color;

- (instancetype) initWithOnlyName:(NSString *)name;

- (NSString *)getName;

- (NSString *)getDescrip;

- (void)setDescrip:(NSString *)description;

- (NSString *)getParent;

- (NSString *)getColor;
@end
