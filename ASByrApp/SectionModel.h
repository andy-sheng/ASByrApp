//
//  SectionModel.h
//  ASByrApp
//
//  Created by lxq on 16/4/15.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionModel : NSObject
- (instancetype) setWithFullInfo:(NSString *)name
                  sectionDescrip:(NSString *)descirp
                   sectionIsRoot:(NSString *)isRoot
                   sectionParent:(NSString *)parentName;

- (instancetype) setWithName:(NSString *)name;

- (void) loadOtherInfo:(NSString *)descirp
         sectionIsRoot:(NSString *)isRoot
         sectionParent:(NSString *)parentName;
- (void)loadDescription:(NSString *)descrip;
- (NSString *)getDescrip;

- (void)loadParent:(NSString *)parentName;
- (NSString *)getParent;

- (NSString *)getName;

@end
