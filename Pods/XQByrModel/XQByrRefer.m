//
//  XQByrRefer.m
//  Pods
//
//  Created by lxq on 1/4/17.
//
//

#import "XQByrRefer.h"

@implementation XQByrRefer


+ (NSDictionary *)objectClassInArray{
    return @{@"article" : [XQByrReference class]};
}

@end
@implementation XQByrReference

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"rid" : @"id"};
}
@end

