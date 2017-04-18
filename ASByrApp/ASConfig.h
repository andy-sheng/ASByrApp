//
//  ASConfig.h
//  ASByrApp
//
//  Created by andy on 16/4/4.
//  Copyright © 2016年 andy. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef ASConfig_h
#define ASConfig_h

typedef NS_OPTIONS(NSUInteger, ASTop10Type) {
    ASTop10      = 1 << 0,
    ASRecommend  = 1 << 1,
    ASSectionTop = 1 << 2
};
#endif /* ASConfig_h */
