//
//  ASTop10Manager.m
//  ASByrApp
//
//  Created by andy on 16/4/30.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASTop10Manager.h"

@implementation ASTop10ManageItem

+ (instancetype)itemWithName:(NSString *)name
                     sectionNo:(NSInteger)section
                        type:(ASTop10Type)type
                     isShown:(BOOL)isShown {
    ASTop10ManageItem *item = [[ASTop10ManageItem alloc] init];
    if (item != nil) {
        item.name    = name;
        item.section = section;
        item.type    = type;
        item.isShown = isShown;
    }
    return item;
}

@end

@interface ASTop10Manager()

@property(strong, nonatomic) NSArray * top10ItemArr;

@end

@implementation ASTop10Manager

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.top10ItemArr = @[[ASTop10ManageItem itemWithName:@"十大" sectionNo:0 type:ASTop10 isShown:YES],
                              [ASTop10ManageItem itemWithName:@"本站" sectionNo:0 type:ASSectionTop isShown:YES],
                              [ASTop10ManageItem itemWithName:@"北邮" sectionNo:1 type:ASSectionTop isShown:YES],
                              [ASTop10ManageItem itemWithName:@"学术" sectionNo:2 type:ASSectionTop isShown:YES],
                              [ASTop10ManageItem itemWithName:@"信息" sectionNo:3 type:ASSectionTop isShown:YES],
                              [ASTop10ManageItem itemWithName:@"人文" sectionNo:3 type:ASSectionTop isShown:YES],
                              [ASTop10ManageItem itemWithName:@"生活" sectionNo:3 type:ASSectionTop isShown:NO]];
    }
    return self;
}

- (ASTop10ManageItem *) shownObjectAtIndex:(NSUInteger)index {
    for (ASTop10ManageItem * item in self.top10ItemArr) {
        if (item.isShown) {
            if (index == 0) {
                return item;
            } else {
                --index;
            }
        }
        
    }
    return nil;
}

- (ASTop10ManageItem *) hiddenObjectAtIndex:(NSUInteger)index {
    for (ASTop10ManageItem * item in self.top10ItemArr) {
        if (!item.isShown) {
            if (index == 0) {
                return item;
            } else {
                --index;
            }
        }
        
    }
    return nil;
}

#pragma mark - getter and setter

- (NSUInteger)shownItemsCount {
    NSUInteger tmp = 0;
    for (ASTop10ManageItem* item in self.top10ItemArr) {
        if (item.isShown) {
            ++tmp;
        }
    }
    return tmp;
}

- (NSUInteger)hiddenItemsCount {
    NSUInteger tmp = 0;
    for (ASTop10ManageItem* item in self.top10ItemArr) {
        if (!item.isShown) {
            ++tmp;
        }
    }
    return tmp;
}

@end
