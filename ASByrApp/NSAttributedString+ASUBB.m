//
//  NSAttributedString+ASUBB.m
//  ASUBBParser
//
//  Created by Andy on 16/5/17.
//  Copyright © 2016年 andysheng. All rights reserved.
//

#import "NSAttributedString+ASUBB.h"
#import "UIColor+Hex.h"
#import <UIKit/UIKit.h>
#import <YYText.h>

typedef enum {
    ScanNormalChar = 1 << 0,
    ScanTagLeft    = 1 << 1,
    ScanFrontTag   = 1 << 2,
    ScanBackTag    = 1 << 3
}ASUBBState;


/**
 *  ASTagItem
 */
@interface ASTagItem : NSObject

@property(nonatomic, strong) NSString * tag;

@property(nonatomic, assign) NSRange tagRange;

@property(nonatomic, assign) NSUInteger pos;

@end

@implementation ASTagItem

@end


/**
 *  ASStack
 */
@interface ASStack : NSObject

@property (nonatomic, strong) NSDictionary * supportedTags;

@property(nonatomic, strong)NSMutableArray *stackStoragy;

@property(nonatomic, assign)NSUInteger len;

@property(nonatomic, strong)NSRegularExpression * tagName;

@property(nonatomic, strong)NSRegularExpression * value;

@property(nonatomic, strong)NSRegularExpression * additionAttr;

@property(nonatomic, strong)NSRegularExpression * attrValue;


- (void)pushWith:(NSString *)tag
        startPos:(NSUInteger) startPos
          length:(NSUInteger) length;

- (NSDictionary*)popWithTag:(NSString*)tag;

- (NSUInteger)cout;

- (void)debug;

@end

@implementation ASStack

- (instancetype)init {
    self = [super init];
    if (self) {
        self.stackStoragy = [[NSMutableArray alloc] init];
        self.tagName = [[NSRegularExpression alloc] initWithPattern:@"(?<=\\[|/| )[0-9a-zA-Z]+(?=\\=|\\])"
                                                            options:NSRegularExpressionCaseInsensitive
                                                              error:nil];
        self.value = [[NSRegularExpression alloc] initWithPattern:@"(?<=\\=)[#a-zA-Z0-9\\u4e00-\\u9fa5/:\\?\\.]+(?=\\]| )"
                                                          options:NSRegularExpressionCaseInsensitive
                                                            error:nil];
        
        self.supportedTags = @{
                               @"b":@"b",
                               @"color":@"color",
                               @"code":@"code",
                               @"email":@"email",
                               @"face":@"face",
                               @"i":@"i",
                               @"img":@"img",
                               @"mp3":@"mp3",
                               @"map":@"map",
                               @"size":@"size",
                               @"u":@"u",
                               @"url":@"url",
                               @"upload":@"upload"
                               };
    }
    return self;
}

- (void)pushWith:(NSString *)tag
        startPos:(NSUInteger) startPos
          length:(NSUInteger) length {
    NSLog(@"push tag:%@", tag);
    NSDictionary *tmp = @{@"tag":[NSMutableArray array], @"value":[NSMutableArray array], @"startPos":@(startPos), @"length":@(length)};
    NSArray *results = [self.tagName matchesInString:tag options:0 range:NSMakeRange(0, [tag length])];
    if ([results count] == 0) {
        return;
    }
    NSString * tagName = [tag substringWithRange:((NSTextCheckingResult *)results[0]).range];
    if ([self.supportedTags objectForKey:tagName] == nil) { // not support tags
        NSLog(@"%@ is not supporrted", tagName);
        return;
    }
    for (NSTextCheckingResult *result in results) {
        [tmp[@"tag"] addObject:[tag substringWithRange:result.range]];
        NSLog(@"tag name:%@ %@", NSStringFromRange(result.range), [tag substringWithRange:result.range]);
    }
    
    
    results = [self.value matchesInString:tag options:0 range:NSMakeRange(0, [tag length])];
    for (NSTextCheckingResult *result in results) {
        [tmp[@"value"] addObject:[tag substringWithRange:result.range]];
        NSLog(@"value:%@ %@", NSStringFromRange(result.range), [tag substringWithRange:result.range]);
    }
    
    [self.stackStoragy addObject:tmp];
}

- (NSDictionary*)popWithTag:(NSString *)tag {
    NSArray *results = [self.tagName matchesInString:tag options:0 range:NSMakeRange(0, [tag length])];
    for (NSTextCheckingResult *result in results) {
        NSString *tagName = [tag substringWithRange:result.range];
        NSDictionary *tmp = [self.stackStoragy lastObject];
        if ([tagName isEqualToString:tmp[@"tag"][0]]) {
            [self.stackStoragy removeObject:tmp];
            return tmp;
        } else {
            return nil;
        }
    }
    return nil;
}

- (NSUInteger)cout {
    return [self.stackStoragy count];
}

- (void)debug {
    NSLog(@"------------");
    for (NSDictionary* tag in self.stackStoragy) {
        NSLog(@"tag:%@ pos:%@", tag[@"tag"], tag[@"startAt"]);
    }
}

@end



@implementation NSAttributedString (ASUBB)

- (instancetype)initWithUBB:(NSString *)ubb {
    self = [self initWithAttributedString:[self parserUbb:ubb]];
    if (self) {
        
    }
    return self;
}

- (BOOL)checkForwardWithUbbStr:(NSString*)ubbStr
                      startPtr:(NSUInteger)scanPtr {
    NSUInteger strLen = [ubbStr length];
    for (; scanPtr < strLen; scanPtr++) {
        NSString *tmp = [ubbStr substringWithRange:NSMakeRange(scanPtr, 1)];
        if ([tmp isEqualToString:@"]"]) {
            return YES;
        }
        if ([tmp isEqualToString:@"["]) {
            return NO;
        }
    }
    return NO;
}

- (NSAttributedString*)parserUbb:(NSString*)ubbStr {
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:ubbStr];
    
    BOOL debug = NO;
    ASUBBState state = ScanNormalChar;
    NSUInteger ubbStrLen = [ubbStr length];
    NSUInteger startPtr = 0, len = 0;
    ASStack *stack = [[ASStack alloc] init];
    
    for (NSUInteger scanPtr = 0; scanPtr < ubbStrLen; scanPtr++) {
        NSString *letter = [ubbStr substringWithRange:NSMakeRange(scanPtr, 1)];
        switch (state) {
            case ScanNormalChar: // 0
                if ([letter isEqualToString: @"["] && [self checkForwardWithUbbStr:ubbStr startPtr:scanPtr + 1]) {
                    //self.cleanStr = [self.cleanStr stringByAppendingString:[ubbStr substringWithRange:NSMakeRange(startPtr, len)]];
                    state = ScanTagLeft;
                    
                    startPtr = scanPtr;
                    len = 1;
                }
                break;
            case ScanTagLeft: // 1
                if ([letter isEqualToString:@"["]) {
                    state = ScanTagLeft;
                    
                    startPtr = scanPtr;
                    len = 1;
                    
                } else if ([letter isEqualToString:@"/"]) {
                    state = ScanBackTag;
                    
                    ++len;
                } else {
                    state = ScanFrontTag;
                    
                    ++len;
                }
                break;
            case ScanFrontTag: // 2
                if ([letter isEqualToString:@"["]) {
                    state = ScanFrontTag;
                    
                    startPtr = scanPtr;
                    len = 1;
                } else if ([letter isEqualToString:@"]"]) {
                    state = ScanNormalChar;
                    
                    ++len;
                    /**
                     *  add more info in stack node, todo
                     */
                    [stack pushWith:[ubbStr substringWithRange:NSMakeRange(startPtr, len)] startPos:startPtr length:len];
                    //[stack pushWith:[ubbStr substringWithRange:NSMakeRange(startPtr, len)] startAtCleanStr:[self.cleanStr length]];
                    
                    
                    startPtr = scanPtr + 1;
                    len = 0;
                } else {
                    
                    ++len;
                }
                break;
            case ScanBackTag: // 3
                if ([letter isEqualToString:@"["]) {
                    state = ScanTagLeft;
                    
                    startPtr = scanPtr;
                    len = 1;
                } else if ([letter isEqualToString:@"]"]) {
                    state = ScanNormalChar;
                    
                    ++len;
                    
                    /**
                     *  do more when pop from the stack, todo
                     */
                    NSDictionary * tmp = [stack popWithTag:[ubbStr substringWithRange:NSMakeRange(startPtr, len)]];
                    if (tmp) { // pop success, then add attributes to string  delete tag
                        
                        NSLog(@"str before delete tag:%@\n--------", ubbStr);
                        
                        NSUInteger cleanStart = [tmp[@"startPos"] integerValue] + [tmp[@"length"] integerValue];
                        attrStr = [self addAttributesToString:attrStr
                                                        range:NSMakeRange(cleanStart, startPtr - cleanStart)
                                                         tags:tmp[@"tag"]
                                                       values:tmp[@"value"]];
                        //[attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:];
                        NSLog(@"attributed str:%@", [ubbStr substringWithRange:NSMakeRange(cleanStart, startPtr - cleanStart)]);
                        
                        NSLog(@"delete back tag");
                        NSLog(@"start at:%ld, len:%ld", startPtr, len);
                        ubbStr = [ubbStr stringByReplacingCharactersInRange:NSMakeRange(startPtr, len) withString:@""];
                        [attrStr replaceCharactersInRange:NSMakeRange(startPtr, len) withString:@""];
                        
                        NSLog(@"delete front tag");
                        NSLog(@"start at:%ld, len:%ld", [tmp[@"startPos"] integerValue], [tmp[@"length"] integerValue]);
                        ubbStr = [ubbStr stringByReplacingCharactersInRange:NSMakeRange([tmp[@"startPos"] integerValue], [tmp[@"length"] integerValue]) withString:@""];
                        [attrStr replaceCharactersInRange:NSMakeRange([tmp[@"startPos"] integerValue], [tmp[@"length"] integerValue]) withString:@""];

                        NSLog(@"str after delete tag:%@\n---------", ubbStr);
                        ubbStrLen = [ubbStr length];
                        scanPtr = scanPtr - [tmp[@"length"] integerValue] - len;
                    }
                    startPtr = scanPtr + 1;
                    len = 0;
                } else {
                    ++len;
                }
                break;
            default:
                break;
        }
        if (debug) {
            NSLog(@"%@", stack);
            NSLog(@"%d", state);
            NSLog(@"%@", letter);
        }
        
        
    }
    return attrStr;
}

- (NSMutableAttributedString*)addAttributesToString:(NSMutableAttributedString*) str
                        range:(NSRange)range
                         tags:(NSArray*)tags
                       values:(NSArray*)values {
    if ([tags count] == 0) {
        return str;
    }
    if ([tags[0] isEqualToString:@"b"]) {
        [str yy_setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17] range:range];
        
    } else if ([tags[0] isEqualToString:@"color"]) {
        [str yy_setColor:[UIColor colorWithHexString:values[0]] range:range];
    } else if ([tags[0] isEqualToString:@"code"]) {
        [str yy_setBackgroundColor:[UIColor grayColor] range:range];
    } else if ([tags[0] isEqualToString:@"email"]) {
        
    } else if ([tags[0] isEqualToString:@"face"]) {
        
    } else if ([tags[0] isEqualToString:@"i"]) {
        CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
        UIFontDescriptor *desc =  [UIFontDescriptor fontDescriptorWithName:[UIFont systemFontOfSize:17].fontName matrix:matrix];
        [str yy_setFont:[UIFont fontWithDescriptor:desc size:17] range:range];
    } else if ([tags[0] isEqualToString:@"img"]) {
        
    } else if ([tags[0] isEqualToString:@"mp3"]) {
        
    } else if ([tags[0] isEqualToString:@"map"]) {
        
    } else if ([tags[0] isEqualToString:@"size"]) {
        [str yy_setFont:[UIFont systemFontOfSize:[values[0] integerValue]] range:range];
        NSLog(@"setting size:%ld", [values[0] integerValue]);
    } else if ([tags[0] isEqualToString:@"u"]) {
        
    } else if ([tags[0] isEqualToString:@"url"]) {
        
    } else if ([tags[0] isEqualToString:@"upload"]) {
        
    }
    return str;
}
@end
