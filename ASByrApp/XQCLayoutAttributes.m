//
//  XQCLayoutAttributes.m
//  ASByrApp
//
//  Created by lxq on 16/5/12.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQCLayoutAttributes.h"
@interface XQCLayoutAttributes()<NSCopying>
@end
@implementation XQCLayoutAttributes
-(id)copyWithZone:(NSZone *)zone{
    XQCLayoutAttributes * copy = [super copyWithZone:zone];
    if ([copy class]==[XQCLayoutAttributes class]) {
        copy.photoHeight = self.photoHeight;
        copy.titleHeight = self.titleHeight;
        copy.boardNameHeight = self.boardNameHeight;
    }
    return copy;
}

- (BOOL)isEqual:(id)object{
    if ([object class]==[XQCLayoutAttributes class]) {
        XQCLayoutAttributes * tempObj = object;
        if (tempObj.photoHeight == self.photoHeight) {
            return [super isEqual:object];
        }
    }
    return false;
}
@end
