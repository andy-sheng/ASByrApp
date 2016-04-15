//
//  BoardModel.m
//  ASByrApp
//
//  Created by lxq on 16/4/14.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "BoardModel.h"

@interface BoardModel()
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * descip;
@property (nonatomic, strong) NSString * parentName;
@end

@implementation BoardModel

- (instancetype) setWithFullInfo:(NSString *)name
                    boardDescrip:(NSString *)descirp
                     boardParent:(NSString *)parentName{
    self.name=[name copy];
    self.descip=[descirp copy];
    self.parentName=[parentName copy];
    return self;
};

- (void)loadDescription:(NSString *)descrip{
    self.descip=[descrip copy];
};
- (NSString *)getDescrip{
    return self.descip;
};


- (void)loadParent:(NSString *)parentName{
    self.parentName=[parentName copy];
};
- (NSString *)getParent{
    return self.parentName;
};


@end
