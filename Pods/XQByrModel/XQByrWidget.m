//
//  XQByrWidget.m
//  Pods
//
//  Created by lxq on 1/4/17.
//
//

#import "XQByrWidget.h"
#import "XQByrArticle.h"
@implementation XQByrWidget


+ (NSDictionary *)objectClassInArray{
    return @{@"article" : [XQByrArticle class]};
}
@end
