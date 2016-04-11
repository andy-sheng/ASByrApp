//
//  UIViewController+ASBase.m
//  ASByrApp
//
//  Created by andy on 16/4/10.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "UIViewController+ASBase.h"


@implementation UIViewController(ASBase)

@dynamic byrToken;

- (ASByrToken*)byrToken {
    return [[ASByrToken alloc] initFromStorage];
}



- (BOOL)loadToken {
    self.byrToken = [[ASByrToken alloc] initFromStorage];
    if (self.byrToken.accessToken) {
        return YES;
    }
    return NO;
}

@end
