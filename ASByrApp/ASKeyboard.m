//
//  ASKeyboard.m
//  ASByrApp
//
//  Created by andy on 16/4/22.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASKeyboard.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ASKeyboard()


@end


@implementation ASKeyboard

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300)];
    if (self) {
        //[self setBackgroundColor:[UIColor redColor]];
        [self setupUI];
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)setupUI {
    // add subviews into inputview
    [self.inputView addSubview:self.textView];
    [self.inputView addSubview:self.sendBtn];
    [self.inputView addSubview:self.faceBtn];
    [self.inputView addSubview:self.moreBtn];
    
    // add subviews into pluginview
    
    
    // add subviews into pluginview
    [self addSubview:self.inputView];
    [self addSubview:self.pluginView];
}

- (void)updateConstraints {
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.bottom.equalTo(self.superview.mas_bottom).offset(self.bounds.size.height);
//    }];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.trailing.equalTo(self.mas_trailing);
        make.leading.equalTo(self.mas_leading);
        make.height.equalTo(@40);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputView.mas_top).offset(8);
        make.bottom.equalTo(self.inputView.mas_bottom).offset(-8);
        make.leading.equalTo(self.inputView.mas_leading).offset(8);
        make.width.equalTo(self.moreBtn.mas_height);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputView.mas_top).offset(4);
        make.bottom.equalTo(self.inputView.mas_bottom).offset(-4);
        make.leading.equalTo(self.moreBtn.mas_trailing).offset(8);
    }];
    
    [self.faceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputView.mas_top).offset(8);
        make.bottom.equalTo(self.inputView.mas_bottom).offset(-8);
        make.leading.equalTo(self.textView.mas_trailing).offset(8);
        make.width.equalTo(self.faceBtn.mas_height);
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputView.mas_top).offset(8);
        make.trailing.equalTo(self.inputView.mas_trailing).offset(-8);
        make.bottom.equalTo(self.inputView.mas_bottom).offset(-8);
        make.leading.equalTo(self.faceBtn.mas_trailing).offset(8);
    }];
    [self.pluginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputView.mas_bottom);
        make.trailing.equalTo(self.mas_trailing);
        make.leading.equalTo(self.mas_leading);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.superview.mas_bottom);
//    }];
    [super updateConstraints];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat newY = keyboardRect.origin.y - self.inputView.bounds.size.height;
    CGRect frame = self.frame;
    frame.origin.y = newY;
    self.frame = frame;
//    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.superview).offset(newConstraint);
//    }];
}

# pragma mark - public method

- (void)pop {
    [self.textView becomeFirstResponder];
}

- (void)hide {
    [self.textView resignFirstResponder];
    CGRect frame = self.frame;
    frame.origin.y = SCREEN_HEIGHT;
    self.frame = frame;
}

- (void)sendBtnClick {
    [self hide];
    [self.delegate sendAcion:self.textView.text];
}

#pragma mark - getters and setters

- (UIView *)inputView {
    if (_inputView == nil) {
        _inputView = [[UIView alloc] init];
        // init code goes here
        [_inputView setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00]];
        [_inputView.layer setBorderWidth:1.0];
    }
    return _inputView;
}

- (UIView *)pluginView {
    if (_pluginView == nil) {
        _pluginView = [[UIView alloc] init];
        // init code goes here
        //[_pluginView setBackgroundColor:[UIColor greenColor]];
    }
    return _pluginView;
}

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        [_textView setFont:[UIFont systemFontOfSize:15.0]];
        [_textView.layer setBorderWidth:1.0];
        [_textView.layer setCornerRadius:10.0];
    }
    return _textView;
}

- (UIButton *)sendBtn {
    if (_sendBtn == nil) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateHighlighted];
        [_sendBtn setBackgroundColor:[UIColor colorWithRed:0.19 green:0.49 blue:0.95 alpha:1.00]];
        [_sendBtn.layer setBorderWidth:1.0];
        [_sendBtn.layer setCornerRadius:5.0];
    }
    return _sendBtn;
}

- (UIButton *)faceBtn {
    if (_faceBtn == nil) {
        _faceBtn = [[UIButton alloc] init];
        [_faceBtn setBackgroundImage:[UIImage imageNamed:@"smile"] forState:UIControlStateNormal];
    }
    return _faceBtn;
}

- (UIButton *)moreBtn {
    if (_moreBtn == nil) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    }
    return _moreBtn;
}



@end
