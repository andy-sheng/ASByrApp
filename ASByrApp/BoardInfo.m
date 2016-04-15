//
//  BoardModel.m
//  ASByrApp
//
//  Created by lxq on 16/4/14.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "BoardInfo.h"
#import "SectionModel.h"
#import "BoardModel.h"
#import "ASConfig.h"
#import <ASByrToken.h>
#import <ASByrBoard.h>

#define  AllBoardsKey @"allBoards"
#define  AllSectionKey @"allSections"

@implementation BoardInfo{
    //SectionModel *section;
    //BoardModel *board;
};

- (instancetype)init{
    if ([super init]) {
        [self initWithFetchAllBoard];
    }
    return self;
}

- (void)loadDataFromFile{
    NSUserDefaults * boardDefaults = [[NSUserDefaults alloc]init];
    self.allFetchedBoards = [boardDefaults objectForKey:AllBoardsKey];
    self.allFetchedSections = [boardDefaults objectForKey:AllSectionKey];
}
- (void)initWithFetchAllBoard{
    self.allFetchedSections=[[NSMutableArray alloc]init];
    self.allFetchedBoards=[[NSMutableArray alloc]init];
    ASByrBoard *netSection =[[ASByrBoard alloc]initWithAccessToken:[ASByrToken shareInstance].accessToken];
    
    //=============读取根分区================
    [netSection fetchRootSectionsWithSuccessBlock:^(NSInteger statusCode, id response) {
        NSArray *responseArray = [NSArray arrayWithArray:response[@"section"]];
        for (NSUInteger i=0; i < responseArray.count; i++) {
            NSDictionary *responseRootArray = responseArray[i];
            SectionModel* section=[[SectionModel alloc] setWithFullInfo:responseRootArray[@"name"] sectionDescrip:responseRootArray[@"description"] sectionIsRoot:responseRootArray[@"is_root"] sectionParent:responseRootArray[@"parent"]];
            [self.allFetchedSections addObject:section];
        }
        
        //====================读取根分区下一级==================
        [self.allFetchedSections enumerateObjectsUsingBlock:^(SectionModel* sectionModel, NSUInteger idx, BOOL * _Nonnull stop) {
            __block NSMutableArray *newAddSectionsArray =[[NSMutableArray alloc]init];
            __block NSMutableArray *newAddBoardsArray = [[NSMutableArray alloc]init];
            ASByrBoard *netBoard =[[ASByrBoard alloc]initWithAccessToken:[ASByrToken shareInstance].accessToken];
            [netBoard fetchSectionInfoWithName:[NSString stringWithFormat:@"%@",[sectionModel getName]] successBlock:^(NSInteger statusCode, id response) {
                //更新分区信息
                NSLog(@"进入第%lu个",idx);
                if(![sectionModel getDescrip])
                    [sectionModel loadOtherInfo:response[@"description"] sectionIsRoot:response[@"is_root"] sectionParent:response[@"parent"]];
                NSArray * responseSectionArray=response[@"sub_section"];//读到的子分区
                NSUInteger j = 0;
                while(j<responseSectionArray.count){
                    SectionModel* section=[[SectionModel alloc] setWithName:responseSectionArray[j]];
                    [newAddSectionsArray addObject:section];
                    j++;
                }
                NSArray * responseBoardArray=response[@"board"];//读到的版面
                j = 0;
                while (j<responseBoardArray.count) {
                    NSDictionary *responseDic = responseBoardArray[j];
                    BoardModel* board=[[BoardModel alloc]setWithFullInfo:responseDic[@"name"] boardDescrip:responseDic[@"description"] boardParent:responseDic[@"section"]];
                    [newAddBoardsArray addObject:board];
                    j++;
                }
                [self.allFetchedSections addObjectsFromArray:newAddSectionsArray];
                [self.allFetchedBoards addObjectsFromArray:newAddBoardsArray];
                self.boardSum=_allFetchedBoards.count;
                self.sectionSum=_allFetchedSections.count;
                NSLog(@"%ld",(long)self.boardSum);
                NSLog(@"%ld",(long)self.sectionSum);
            }failureBlock:^(NSInteger statusCode, id response) {
                NSLog(@"Initial fetch Sections Information Fail!");
            }];
        }];
        self.boardSum=_allFetchedBoards.count;
        self.sectionSum=_allFetchedSections.count;
        NSLog(@"%ld",(long)self.boardSum);
        NSLog(@"%ld",(long)self.sectionSum);
        /*
        //=============读取根分区下的版面和子分区==================
        for (NSUInteger i=0; i < self.allFetchedSections.count; i++) {
            //__weak typeof(SectionModel *) sectionModel = _allFetchedSections[i];
            __block NSMutableArray *newAddSectionsArray =[[NSMutableArray alloc]init];
            __block NSMutableArray *newAddBoardsArray = [[NSMutableArray alloc]init];
            ASByrBoard *netBoard =[[ASByrBoard alloc]initWithAccessToken:[ASByrToken shareInstance].accessToken];
            NSLog(@"第%lu个",(unsigned long)i);
            [netBoard fetchSectionInfoWithName:[NSString stringWithFormat:@"%@",[[self.allFetchedSections objectAtIndex:i]getName]] successBlock:^(NSInteger statusCode, id response) {
                //更新分区信息
                NSLog(@"进入第%lu个",i);
                if(![[self.allFetchedSections objectAtIndex:i] getDescrip])
                    [[self.allFetchedSections objectAtIndex:i] loadOtherInfo:response[@"description"] sectionIsRoot:response[@"is_root"] sectionParent:response[@"parent"]];
                NSArray * responseSectionArray=response[@"sub_section"];//读到的子分区
                NSUInteger j = 0;
                while(j<responseSectionArray.count){
                    SectionModel* section=[[SectionModel alloc] setWithName:responseSectionArray[i]];
                    [newAddSectionsArray addObject:section];
                    j++;
                }
                NSArray * responseBoardArray=response[@"board"];//读到的版面
                j = 0;
                while (j<responseBoardArray.count) {
                    NSDictionary *responseDic = responseBoardArray[j];
                    BoardModel* board=[[BoardModel alloc]setWithFullInfo:responseDic[@"name"] boardDescrip:responseDic[@"description"] boardParent:responseDic[@"section"]];
                    [newAddBoardsArray addObject:board];
                    j++;
                }
                [self.allFetchedSections addObjectsFromArray:newAddSectionsArray];
                [self.allFetchedBoards addObjectsFromArray:newAddBoardsArray];
            }failureBlock:^(NSInteger statusCode, id response) {
                NSLog(@"Initial fetch Sections Information Fail!");
            }];
        }
        self.boardSum=_allFetchedBoards.count;
        self.sectionSum=_allFetchedSections.count;
        NSLog(@"%ld",(long)self.boardSum);
        NSLog(@"%ld",(long)self.sectionSum);
         */
    } failureBlock:^(NSInteger statusCode, id response) {
        NSLog(@"Initial fetch All Boards Information Fail!");
    }];
}
@end
