//
//  ASInputTextCell.m
//  ASByrApp
//
//  Created by Andy on 2017/3/8.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "ASInputTextCell.h"
#import <YYTextView.h>
#import <Masonry.h>

@interface ASInputTextCell ()

@property (nonatomic, strong) YYTextView *textField;

@end

@implementation ASInputTextCell

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [self.contentView addSubview:self.textField];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)updateConstraints {
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_leftMargin);
        make.height.equalTo(@200);
    }];
    [super updateConstraints];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

# pragma mark getters and setters
- (YYTextView*)textField {
    if (_textField == nil) {
        _textField = [[YYTextView alloc] init];
        [_textField setFont:[UIFont systemFontOfSize:17]];
    }
    return _textField;
}
@end
