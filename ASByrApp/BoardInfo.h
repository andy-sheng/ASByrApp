//
//  BoardModel.h
//  ASByrApp
//
//  Created by lxq on 16/4/14.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoardInfo : NSObject

@property (nonatomic, assign) NSInteger sectionSum;
@property (nonatomic, assign) NSInteger boardSum;

@property (nonatomic, strong) NSMutableArray * allFetchedSections;
@property (nonatomic, strong) NSMutableArray * allFetchedBoards;

@property (nonatomic, copy) NSString * pathOfSectionSaved;
@property (nonatomic, copy) NSString * pathOfBoardSaved;

- (instancetype)init;
- (void)loadDataFromFile;
- (void)initWithFetchAllBoard;

@end
