//
//  XQSectionModel.m
//  ASByrApp
//
//  Created by lxq on 16/4/20.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQSectionModel.h"

@interface XQSectionModel()
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * descip;
@property (nonatomic, assign) BOOL isRoot;
@property (nonatomic, strong) NSString * parentName;
@end


@implementation XQSectionModel

- (instancetype) setWithFullInfo:(NSString *)name
                  sectionDescrip:(NSString *)descirp
                   sectionIsRoot:(NSString *)isRoot
                   sectionParent:(NSString *)parentName{
    
    if ([super init]) {
        self.name=[name copy];
        self.descip=[descirp copy];
        self.isRoot=isRoot;
        self.parentName=parentName;
    }
    return self;
};

- (instancetype) setWithName:(NSString *)name{
    if ([super init])
        self.name=[name copy];
    return self;
};

- (NSString *)getDescrip{
    return self.descip;
};

- (NSString *)getParent{
    return self.parentName;
};

- (NSString *)getName{
    return self.name;
}


@end
