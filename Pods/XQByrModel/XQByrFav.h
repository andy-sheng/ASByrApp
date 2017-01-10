//
//  XQByrFav.h
//  Pods
//
//  Created by lxq on 1/4/17.
//
//

#import <Foundation/Foundation.h>

@class XQByrBoard, XQByrSection, XQByrFavorite;
@interface XQByrFav : NSObject

@property (nonatomic, strong) NSArray<XQByrBoard *> *board;
@property (nonatomic, strong) NSArray<XQByrSection *> *section;
@property (nonatomic, strong) NSArray<XQByrFavorite *> *sub_favorite;

@end

@interface XQByrFavorite : NSObject

@property (nonatomic, assign) NSInteger level;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, assign) NSInteger position;

@end
