//
//  ASThreadsVC.h
//  ASByrApp
//
//  Created by andy on 16/4/14.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XQByrArticle;
typedef NS_ENUM(NSInteger, ASThreadsEnterType){
    ASThreadsEnterTypeNormal,
    ASThreadsEnterTypeCollection
};

@interface ASThreadsController : UIViewController

- (instancetype)initWithWithBoard:(NSString*)board
                              aid:(NSUInteger)aid;

@end
