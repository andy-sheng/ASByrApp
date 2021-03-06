//
//  ASKeyboard.h
//  ASByrApp
//
//  Created by andy on 16/4/22.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import <XQByrArticle.h>

@protocol ASKeyBoardDelegate <NSObject>

@optional

- (void)moreAction:(id) context;

- (void)sendAcionWithInput:(NSString *) input context:(id)context;

@end


@interface ASKeyboard : UIView

@property(weak, nonatomic) id<ASKeyBoardDelegate> delegate;

@property(strong, nonatomic) UIView * inputView;

@property(strong, nonatomic) UIView * pluginView;

@property(strong, nonatomic) UITextView * textView;

@property(strong, nonatomic) UIButton * sendBtn;

@property(strong, nonatomic) UIButton * faceBtn;

@property(strong, nonatomic) UIButton * moreBtn;

@property(strong, nonatomic) NSDictionary * context;

- (void)pop;

- (void)popWithContext:(NSDictionary*) context;

- (void)hide;

@end
