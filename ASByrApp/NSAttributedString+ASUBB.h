//
//  NSAttributedString+ASUBB.h
//  ASUBBParser
//
//  Created by Andy on 16/5/17.
//  Copyright © 2016年 andysheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (ASUBB)

- (instancetype)initWithUBB:(NSString*)ubb;

+ (instancetype)string:(NSString*)ubb;

@end
