//
//  ASTop10Manager.h
//  ASByrApp
//
//  Created by andy on 16/4/30.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASConfig.h"

#import <Foundation/Foundation.h>



@interface ASTop10ManageItem : NSObject

@property(strong, nonatomic) NSString * name;

@property(assign, nonatomic) NSInteger section;

@property(assign, nonatomic) ASTop10Type type;

@property(assign, nonatomic) BOOL isShown;

+ (instancetype)itemWithName:(NSString*)name
                   sectionNo:(NSInteger)section
                        type:(ASTop10Type)type
                     isShown:(BOOL)isShown;

@end

@interface ASTop10Manager : NSObject

@property(assign, nonatomic) NSUInteger shownItemsCount;

@property(assign, nonatomic) NSUInteger hiddenItemsCount;

- (ASTop10ManageItem*)shownObjectAtIndex:(NSUInteger)index;

- (ASTop10ManageItem*)hiddenObjectAtIndex:(NSUInteger)index;

- (void)save;

- (void)moveFromShownAtIndex:(NSUInteger)fromIndex
             toHiddenAtIndex:(NSUInteger)toIndex;

- (void)moveFromShownAtIndex:(NSUInteger)fromIndex
              toShownAtIndex:(NSUInteger)toIndex;

- (void)moveFromHiddenAtIndex:(NSUInteger)fromIndex
               toShownAtIndex:(NSUInteger)toIndex;

- (void)moveFromHiddenAtIndex:(NSUInteger)fromIndex
              toHiddenAtIndex:(NSUInteger)toIndex;

@end
