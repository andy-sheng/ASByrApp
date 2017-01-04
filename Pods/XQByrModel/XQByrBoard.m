//
//  XQByrBoard.m
//  Pods
//
//  Created by lxq on 1/4/17.
//
//

#import "XQByrBoard.h"
#import "XQByrArticle.h"
@implementation XQByrBoard
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"clazz" : @"class"};
}

+ (NSDictionary *)objectClassInArray{
    return @{@"article" : [XQByrArticle class]};
}
@end
