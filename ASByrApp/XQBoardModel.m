//
//  XQBoardModel.m
//  ASByrApp
//
//  Created by lxq on 16/4/20.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQBoardModel.h"
#import "ASConfig.h"
#import "ASByrToken.h"
#import "ASByrBoard.h"

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
    if (self = [super init]) {
        self.name=[name copy];
        self.descip=[descirp copy];
        self.parentName=[parentName copy];
    }
    return self;
};

- (instancetype) initWithOnlyName:(NSString *)name{
    if (self = [super init]) {
        self.name=[name copy];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"color_board" ofType:@"plist"];;
        NSLog(@"color_board文件路径%@",filePath);
        NSDictionary * dict = [[NSDictionary alloc]initWithContentsOfFile:filePath];
        self.color=[dict objectForKey:name];
        //=======若版面颜色未对应上，则取第363位颜色“030303”======
        if (self.color==nil) {
            self.color=@"030303";
        }
        //ASByrBoard *netBoard =[[ASByrBoard alloc]initWithAccessToken:[ASByrToken shareInstance].accessToken];
        NSLog(@"版面颜色：%@",self.color);
        self.descip=@"";
        self.parentName=@"";
    }
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
