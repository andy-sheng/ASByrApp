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

@property(strong, nonatomic) NSMutableArray * shownArr;

@property(strong, nonatomic) NSMutableArray * hiddenArr;

@end

NSString * const showArrKey   = @"shownArr";

NSString * const hiddenArrKey = @"hiddenArr";

@implementation ASTop10Manager

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path =  [pathArr objectAtIndex:0];
        NSString *filePath=[path stringByAppendingPathComponent:@"top10Iterms.plist"];
        
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        self.shownArr = [tmp objectForKey:showArrKey];
        if (self.shownArr == nil) {
            NSLog(@"no");
            self.shownArr = [NSMutableArray arrayWithArray:@[
                                                             @{@"name":@"十大",
                                                               @"sectionNo":@(0),
                                                               @"type":@(ASTop10)},
                                                             @{@"name":@"本站",
                                                               @"sectionNo":@(0),
                                                               @"type":@(ASSectionTop)},
                                                             @{@"name":@"北邮",
                                                               @"sectionNo":@(1),
                                                               @"type":@(ASSectionTop)},
                                                             @{@"name":@"学术",
                                                               @"sectionNo":@(2),
                                                               @"type":@(ASSectionTop)},
                                                             @{@"name":@"信息",
                                                               @"sectionNo":@(3),
                                                               @"type":@(ASSectionTop)},
                                                             @{@"name":@"人文",
                                                               @"sectionNo":@(4),
                                                               @"type":@(ASSectionTop)},
                                                             @{@"name":@"生活",
                                                               @"sectionNo":@(5),
                                                               @"type":@(ASSectionTop)},
                                                             @{@"name":@"休闲",
                                                               @"sectionNo":@(6),
                                                               @"type":@(ASSectionTop)},
                                                             @{@"name":@"体育",
                                                               @"sectionNo":@(7),
                                                               @"type":@(ASSectionTop)},
                                                             @{@"name":@"游戏",
                                                               @"sectionNo":@(8),
                                                               @"type":@(ASSectionTop)},
                                                             @{@"name":@"乡亲",
                                                               @"sectionNo":@(9),
                                                               @"type":@(ASSectionTop)}
                                                             ]];
            tmp[@"top10Items"] = self.shownArr;
            [tmp writeToFile:path atomically:YES];
        }
        
        self.hiddenArr = [tmp objectForKey:hiddenArrKey];
        if (self.hiddenArr == nil) {
            self.hiddenArr = [NSMutableArray array];
        }
    }
    return self;
}

- (ASTop10ManageItem *) shownObjectAtIndex:(NSUInteger)index {
    ASTop10ManageItem * tmp = [[ASTop10ManageItem alloc] init];
    tmp.name = self.shownArr[index][@"name"];
    tmp.section = [self.shownArr[index][@"sectionNo"] integerValue];
    tmp.type = [self.shownArr[index][@"type"] intValue];
    return tmp;
}

- (ASTop10ManageItem *) hiddenObjectAtIndex:(NSUInteger)index {
    ASTop10ManageItem * tmp = [[ASTop10ManageItem alloc] init];
    tmp.name = self.hiddenArr[index][@"name"];
    tmp.section = [self.hiddenArr[index][@"sectionNo"] integerValue];
    tmp.type = [self.hiddenArr[index][@"type"] intValue];
    return tmp;}

- (void)save {
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path =  [pathArr objectAtIndex:0];
    NSString *filePath=[path stringByAppendingPathComponent:@"top10Iterms.plist"];
    
    NSDictionary * tmp = [NSDictionary dictionaryWithObjectsAndKeys:self.shownArr, showArrKey, self.hiddenArr, hiddenArrKey, nil];
    [tmp writeToFile:filePath atomically:YES];
}

- (void)moveFromShownAtIndex:(NSUInteger)fromIndex
             toHiddenAtIndex:(NSUInteger)toIndex {
    NSDictionary * tmp = [self.shownArr objectAtIndex:fromIndex];
    [self.hiddenArr insertObject:tmp atIndex:toIndex];
    [self.shownArr removeObjectAtIndex:fromIndex];
}

- (void)moveFromShownAtIndex:(NSUInteger)fromIndex
              toShownAtIndex:(NSUInteger)toIndex {
    NSDictionary * tmp = [self.shownArr objectAtIndex:fromIndex];
    if (fromIndex < toIndex) {
        [self.shownArr insertObject:tmp atIndex:++toIndex];
        [self.shownArr removeObjectAtIndex:fromIndex];
    }
    if (fromIndex > toIndex) {
        [self.shownArr insertObject:tmp atIndex:toIndex];
        [self.shownArr removeObjectAtIndex:++fromIndex];
    }
}

- (void)moveFromHiddenAtIndex:(NSUInteger)fromIndex
               toShownAtIndex:(NSUInteger)toIndex {
    NSDictionary * tmp = [self.hiddenArr objectAtIndex:fromIndex];
    [self.shownArr insertObject:tmp atIndex:toIndex];
    [self.hiddenArr removeObjectAtIndex:fromIndex];
}

- (void)moveFromHiddenAtIndex:(NSUInteger)fromIndex
              toHiddenAtIndex:(NSUInteger)toIndex {
    NSDictionary * tmp = [self.hiddenArr objectAtIndex:fromIndex];
    if (fromIndex < toIndex) {
        [self.hiddenArr insertObject:tmp atIndex:++toIndex];
        [self.hiddenArr removeObjectAtIndex:fromIndex];
    }
    if (fromIndex > toIndex) {
        [self.hiddenArr insertObject:tmp atIndex:toIndex];
        [self.hiddenArr removeObjectAtIndex:++fromIndex];
    }
}

#pragma mark - getter and setter

- (NSUInteger)shownItemsCount {
    return [self.shownArr count];
}

- (NSUInteger)hiddenItemsCount {
    return [self.hiddenArr count];
}

@end
