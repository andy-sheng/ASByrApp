//
//  UIViewController+ASBase.h
//  ASByrApp
//
//  Created by andy on 16/4/10.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ASByrToken.h>

@interface UIViewController (ASBase)

@property(nonatomic, strong) ASByrToken* byrToken;

- (BOOL) loadToken;

@end
