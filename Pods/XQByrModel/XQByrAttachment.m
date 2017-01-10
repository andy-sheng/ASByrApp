//
//  XQByrAttachment.m
//  Pods
//
//  Created by lxq on 1/4/17.
//
//

#import "XQByrAttachment.h"
#import "XQByrFile.h"

@implementation XQByrAttachment

+ (NSDictionary *)objectClassInArray{
    return @{@"file" : [XQByrFile class]};
}
@end
