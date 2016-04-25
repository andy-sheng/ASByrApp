//
//  ASKeyboard.h
//  ASByrApp
//
//  Created by andy on 16/4/22.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>


@protocol ASKeyBoardDelegate <NSObject>

@optional

- (void)sendAcion:(NSString *) text;

@end


@interface ASKeyboard : UIView

@property(strong, nonatomic) id<ASKeyBoardDelegate> delegate;

@property(strong, nonatomic) UIView * inputView;

@property(strong, nonatomic) UIView * pluginView;

@property(strong, nonatomic) UITextView * textView;

@property(strong, nonatomic) UIButton * sendBtn;

@property(strong, nonatomic) UIButton * faceBtn;

@property(strong, nonatomic) UIButton * moreBtn;

- (void)pop;

- (void)hide;

@end
