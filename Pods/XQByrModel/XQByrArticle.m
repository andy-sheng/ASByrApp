//
//  XQByrArticle.m
//  Pods
//
//  Created by lxq on 1/4/17.
//
//

#import "XQByrArticle.h"
#import "XQByrUser.h"
#import "XQByrFile.h"
#import "XQByrAttachment.h"

@implementation XQByrArticle
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"aid" : @"id"};
}
@end