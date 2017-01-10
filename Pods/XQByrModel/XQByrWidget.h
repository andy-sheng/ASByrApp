//
//  XQByrWidget.h
//  Pods
//
//  Created by lxq on 1/4/17.
//
//

#import <Foundation/Foundation.h>

@class XQByrArticle;
@interface XQByrWidget : NSObject

@property (nonatomic, strong) NSArray<XQByrArticle *> *article;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger time;

@end
