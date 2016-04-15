//
//  SectionModel.m
//  ASByrApp
//
//  Created by lxq on 16/4/15.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "SectionModel.h"

@interface SectionModel()
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * descip;
@property (nonatomic, assign) BOOL isRoot;
@property (nonatomic, strong) NSString * parentName;
@end


@implementation SectionModel

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

- (void)loadOtherInfo:(NSString *)descirp sectionIsRoot:(NSString *)isRoot sectionParent:(NSString *)parentName{
    self.descip=[descirp copy];
    self.isRoot=isRoot;
    self.parentName=parentName;
}

- (void)loadDescription:(NSString *)descrip{
    self.descip=descrip;
};

- (NSString *)getDescrip{
    return self.descip;
};

- (void)loadParent:(NSString *)parentName{
    self.parentName=parentName;
};
- (NSString *)getParent{
    return self.parentName;
};

- (NSString *)getName{
    return self.name;
}

@end
