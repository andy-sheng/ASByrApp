//
//  ASUbbParser.h
//  ASByrApp
//
//  Created by Andy on 2017/2/8.
//  Copyright © 2017年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYTextParser.h>

@class XQByrAttachment;

@interface ASUbbParser : NSObject <YYTextParser>

@property(nonatomic, assign) CGFloat fontSize;

@property(nonatomic, weak) XQByrAttachment *attachement;

@property(nonatomic, weak) id linkHandler;
//- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)selectedRange;

@end
