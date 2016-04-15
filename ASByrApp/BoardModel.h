//
//  BoardModel.h
//  ASByrApp
//
//  Created by lxq on 16/4/14.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoardModel : NSObject

- (instancetype) setWithFullInfo:(NSString *)name
                   boardDescrip:(NSString *)descirp
                   boardParent:(NSString *)parentName;

- (void)loadDescription:(NSString *)descrip;
- (NSString *)getDescrip;

- (void)loadParent:(NSString *)parentName;
- (NSString *)getParent;

@end
