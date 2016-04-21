//
//  XQBoardModel.m
//  ASByrApp
//
//  Created by lxq on 16/4/20.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQBoardModel.h"
#import "ASConfig.h"
#import <ASByrToken.h>
#import <ASByrBoard.h>

@interface XQBoardModel()

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * descip;
@property (nonatomic, strong) NSString * parentName;
@property (nonatomic, strong) NSString * color;
@end

@implementation XQBoardModel

- (instancetype) initWithFullInfo:(NSString *)name
                    boardDescrip:(NSString *)descirp
                     boardParent:(NSString *)parentName
                      boardColor:(NSString *)color{
    self.name=[name copy];
    self.descip=[descirp copy];
    self.parentName=[parentName copy];
    return self;
};

- (instancetype) initWithOnlyName:(NSString *)name{
    self.name=[name copy];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"color_board" ofType:@"plist"];;
    NSLog(@"color_board文件路径%@",filePath);
    NSDictionary * dict = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    self.color=[dict objectForKey:name];
    ASByrBoard *netBoard =[[ASByrBoard alloc]initWithAccessToken:[ASByrToken shareInstance].accessToken];
    NSLog(@"版面颜色：%@",self.color);
    [netBoard fetchBoardDetailInfoWithName:name successBlock:^(NSInteger statusCode, id response) {
        self.descip = [response[@"description"] copy];
        self.parentName = [response[@"section"] copy];
        NSLog(@"当前版面名称：%@，分区：%@",self.descip,self.parentName);
    } failureBlock:^(NSInteger statusCode, id response) {
        NSLog(@"fetch other Info of A board fail!");
    }];
    return self;
}

- (NSString *)getName{
    return self.name;
}

- (NSString *)getDescrip{
    return self.descip;
};

- (void)setDescrip:(NSString *)description{
    self.descip=[description copy];
}
- (NSString *)getParent{
    return self.parentName;
};

- (NSString *)getColor{
    return self.color;
};


@end
