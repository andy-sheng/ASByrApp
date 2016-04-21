//
//  XQSectionModel.h
//  ASByrApp
//
//  Created by lxq on 16/4/20.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQSectionModel : NSObject

- (instancetype) setWithFullInfo:(NSString *)name
                  sectionDescrip:(NSString *)descirp
                   sectionIsRoot:(NSString *)isRoot
                   sectionParent:(NSString *)parentName;

- (instancetype) setWithName:(NSString *)name;

- (NSString *)getDescrip;

- (NSString *)getParent;

- (NSString *)getName;
@end
