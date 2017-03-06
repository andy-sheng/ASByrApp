//
//  ASUbbParser.m
//  ASByrApp
//
//  Created by Andy on 2017/2/8.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "ASUbbParser.h"
#import "UIColor+Hex.h"

#import "NSAttributedString+YYText.h"
#import "YYTextUtilities.h"
#import "YYTextAttribute.h"
#import "YYImage.h"
#import "YYWebImage.h"

@implementation ASUbbParser {
    UIFont *_font;
    UIFont *_boldFont;
    UIFont *_italicFont;
    UIColor *_codeTextColor;
    UIFont *_monospaceFont;
    YYTextBorder *_border;
    
    NSRegularExpression *_regexEm;
    NSRegularExpression *_regexB;
    NSRegularExpression *_regexColor;
    NSRegularExpression *_regexCode;
    NSRegularExpression *_regexEmail;
    NSRegularExpression *_regexFace;
    NSRegularExpression *_regexI;
    NSRegularExpression *_regexImg;
    NSRegularExpression *_regexMp3; //
    NSRegularExpression *_regexMap; //
    NSRegularExpression *_regexSize;
    NSRegularExpression *_regexU;
    NSRegularExpression *_regexUrl;
    NSRegularExpression *_regexUpload;
    NSRegularExpression *_regexTag;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _fontSize = 14;
        _font = [UIFont systemFontOfSize:_fontSize];
        _boldFont = YYTextFontWithBold(_font);
        _italicFont = YYTextFontWithItalic(_font);
        _codeTextColor = [UIColor colorWithWhite:0.906 alpha:1.000];
        _border = [[YYTextBorder alloc] init];
        _border.lineStyle = YYTextLineStyleSingle;
        _border.fillColor = [UIColor colorWithWhite:0.184 alpha:0.090];
        _border.strokeColor = [UIColor colorWithWhite:0.546 alpha:0.650];
        _border.insets = UIEdgeInsetsMake(-1, 0, -1, 0);
        _border.cornerRadius = 2;
        _border.strokeWidth = YYTextCGFloatFromPixel(1);
        _monospaceFont = [UIFont fontWithName:@"Menlo" size:_fontSize];
        
        [self initRegex];
    }
    return self;
}

- (void)initRegex {
#define regexp(reg, option) [NSRegularExpression regularExpressionWithPattern : @reg options : option error : NULL]
    _regexEm = regexp("\\[(em[abc]?[0-9]+)\\]", NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators);
    
    _regexB = regexp("(\\[b\\])(.*?)(\\[/b\\])", NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators);
    
    _regexColor = regexp("(\\[color=(#[a-zA-Z0-9]+)\\])(.*?)(\\[/color\\])", NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators);

    _regexCode = regexp("(\\[code=[a-zA-Z0-9]+\\])(.*?)(\\[/code\\])", NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators);
    
    _regexEmail = regexp("(\\[email=(.*)\\])(.*?)(\\[/email\\])", NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators);
    
    _regexFace = regexp("(\\[face=(.*)\\])(.*?)(\\[/face\\])", NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators);
    
    _regexI = regexp("(\\[i\\])(.*?)(\\[/i\\])", NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators);
    
    _regexImg = regexp("(\\[img=(.*?)\\])(.*?)(\\[/img\\])", NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators);
    
    _regexSize = regexp("(\\[size=([0-9]+)\\])(.*?)(\\[/size\\])", NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators);
    
    _regexU = regexp("(\\[u\\])(.*?)(\\[/u\\])", NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators);
    
    _regexUrl = regexp("(\\[url=(.*)\\])(.*?)(\\[/url\\])", NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators);
    
    _regexUpload = regexp("(\\[upload=([0-9]+)\\])(.*?)(\\[/upload\\])", NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators);
    
    _regexTag = regexp("(\\[.*?\\])|(\\[/.*?\\])|(\\[em[abc]?[0-9]+\\])", NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators);
#undef regexp
}

- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)selectedRange {
    NSLog(@"parser:%@", text.string);
    if (text.length == 0) return NO;
    [text yy_removeAttributesInRange:NSMakeRange(0, text.length)];
    text.yy_font = _font;
    
    [_regexEm enumerateMatchesInString:text.string options:0 range:NSMakeRange(0, text.string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange emRange = [result rangeAtIndex:1];
        
        
        UIImage *img = [YYImage imageNamed:[NSString stringWithFormat:@"%@.gif", [text.string substringWithRange:emRange]]];
        
        NSLog(@"%@", [NSString stringWithFormat:@"%@.gif", [text.string substringWithRange:emRange]]);
        YYAnimatedImageView *imgView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, _fontSize * 2, _fontSize * 2)];
        [imgView setImage:img];
        
        
        NSMutableAttributedString *imgStr = [NSMutableAttributedString yy_attachmentStringWithContent:imgView contentMode:UIViewContentModeCenter attachmentSize:imgView.frame.size alignToFont:_font alignment:YYTextVerticalAlignmentCenter];
        [text insertAttributedString:imgStr atIndex:emRange.location + emRange.length+1];
    }];
    
    [_regexB enumerateMatchesInString:text.string options:0 range:NSMakeRange(0, text.string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange innerTextRange = [result rangeAtIndex:2];
        NSLog(@"add bold to string:%@", [text.string substringWithRange:innerTextRange]);
   
        [text yy_setExpansion:@1 range:innerTextRange];
    }];
    
    [_regexColor enumerateMatchesInString:text.string options:0 range:NSMakeRange(0, text.string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange valRange = [result rangeAtIndex:2];
        NSRange innerTextRange = [result rangeAtIndex:3];
        
        NSLog(@"color:%@, text:%@", [text.string substringWithRange:valRange], [text.string substringWithRange:innerTextRange]);
        [text yy_setColor:[UIColor colorWithHexString:[text.string substringWithRange:valRange]] range:innerTextRange];
    }];
    
    [_regexCode enumerateMatchesInString:text.string options:0 range:NSMakeRange(0, text.string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange codeRange = [result rangeAtIndex:2];
        [text yy_setColor:_codeTextColor range:codeRange];
        [text yy_setFont:_monospaceFont range:codeRange];
        YYTextBorder *border = [[YYTextBorder alloc] init];
        border.lineStyle = YYTextLineStyleSingle;
        border.fillColor = [UIColor colorWithWhite:0.184 alpha:0.090];
        border.strokeColor = [UIColor colorWithWhite:0.200 alpha:0.300];
        border.insets = UIEdgeInsetsMake(-1, 0, -1, 0);
        border.cornerRadius = 3;
        border.strokeWidth = YYTextCGFloatFromPixel(2);
        [text yy_setTextBlockBorder:_border.copy range:codeRange];
        
    }];
    
    [_regexEmail enumerateMatchesInString:text.string options:0 range:NSMakeRange(0, text.string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange urlRange = [result rangeAtIndex:2];
        NSRange innerTextRange = [result rangeAtIndex:3];
        
        [text yy_setTextHighlightRange:innerTextRange color:[UIColor blueColor] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", [text.string substringWithRange:urlRange]]]];
        }];
        
    }];
    
    [_regexFace enumerateMatchesInString:text.string options:0 range:NSMakeRange(0, text.string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        //NSRange faceRange = [result rangeAtIndex:2];
        //NSRange innerTextRange = [result rangeAtIndex:3];
        //[text yy_setFont:[UIFont fontWithName:@"" size:_fontSize] range:innerTextRange];
        
    }];
    
    [_regexI enumerateMatchesInString:text.string options:0 range:NSMakeRange(0, text.string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange innerTextRange = [result rangeAtIndex:2];
        NSLog(@"add italic to string:%@", [text.string substringWithRange:innerTextRange]);
        [text yy_setFont:_italicFont range:innerTextRange];
    }];
    
    [_regexImg enumerateMatchesInString:text.string options:0 range:NSMakeRange(0, text.string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange imgUrlRange = [result rangeAtIndex:2];
        NSRange innerTextRange = [result rangeAtIndex:3];
        
        YYAnimatedImageView *imgView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder.jpg"]];
       [imgView yy_setImageWithURL:[NSURL URLWithString:[text.string substringWithRange:imgUrlRange]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
   
        NSLog(@"%@", [text.string substringWithRange:imgUrlRange]);
        NSMutableAttributedString *imgStr = [NSMutableAttributedString yy_attachmentStringWithContent:imgView contentMode:UIViewContentModeCenter attachmentSize:imgView.frame.size alignToFont:_font alignment:YYTextVerticalAlignmentCenter];
        [text insertAttributedString:imgStr atIndex:innerTextRange.location];
    }];
    
    [_regexSize enumerateMatchesInString:text.string options:0 range:NSMakeRange(0, text.string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange valRange = [result rangeAtIndex:2];
        NSRange innerTextRange = [result rangeAtIndex:3];

        //[text yy_setFont:[UIFont systemFontOfSize:[[text.string substringWithRange:valRange] integerValue]] range:innerTextRange];
    }];
    
    [_regexU enumerateMatchesInString:text.string options:0 range:NSMakeRange(0, text.string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
        NSRange innerTextRange = [result rangeAtIndex:2];
        [text yy_setTextUnderline:[YYTextDecoration decorationWithStyle:YYTextLineStyleSingle width:@1 color:[UIColor blackColor]] range:innerTextRange];
    }];
    
    [_regexUrl enumerateMatchesInString:text.string options:0 range:NSMakeRange(0, text.string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange urlRange = [result rangeAtIndex:2];
        NSRange innerTextRange = [result rangeAtIndex:3];
        
        [text yy_setTextHighlightRange:innerTextRange color:[UIColor blueColor] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[text.string substringWithRange:urlRange]]];
        }];
        
    }];
    
    [_regexUpload enumerateMatchesInString:text.string options:0 range:NSMakeRange(0, text.string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
        
    }];
    
    
    [_regexTag replaceMatchesInString:text.mutableString options:0 range:NSMakeRange(0, text.length) withTemplate:@""];
    
    return YES;
}
@end
