//
//  ASInputTextCell.m
//  ASByrApp
//
//  Created by Andy on 2017/3/8.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "ASInputTextCell.h"
#import "ASAccessoryView.h"
#import "ASUbbParser.h"
#import <YYTextView.h>
#import <Masonry.h>


@interface ASInputTextCell ()

@property (nonatomic, strong) YYTextView *textView;

@end

@implementation ASInputTextCell

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [self.contentView addSubview:self.textView];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)updateConstraints {
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_leftMargin);
    }];
    [super updateConstraints];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"change");
    if ([keyPath isEqualToString:@"contentText"]) {
        self.textView.text = self.contentText;
    } else if ([keyPath isEqualToString:@"attachment"]) {
        NSLog(@"attachment changed");
        ((ASUbbParser*)self.textView.textParser).attachment = [change objectForKey:NSKeyValueChangeNewKey];
    }
}
# pragma mark - Private Methods
- (void)addPhoto {
    
}

- (void)dismiss {
    [self.textView resignFirstResponder];
}

# pragma mark getters and setters
- (YYTextView*)textView {
    if (_textView == nil) {
        _textView = [[YYTextView alloc] init];
        _textView.textParser = [[ASUbbParser alloc] init];
        _textView.placeholderText = @"输入帖子内容";
        ASAccessoryView *accessoryView = (ASAccessoryView*)[[NSBundle mainBundle] loadNibNamed:@"ASAccessoryView" owner:nil options:nil][0];
        
        __weak typeof(self)wself = self;
        accessoryView.addPhotoBlock = ^{
            __strong typeof(wself)sself = wself;
            if (sself && [sself.delegate respondsToSelector:@selector(addPhoto)]) {
                [sself.delegate addPhoto];
            }
        };
        
        accessoryView.dismissBlock = ^{
            __strong typeof(wself)sself = wself;
            if (sself) {
                [sself.textView resignFirstResponder];
            }
        };
        
        _textView.inputAccessoryView = accessoryView;
        [_textView setFont:[UIFont systemFontOfSize:17]];
    }
    return _textView;
}
@end
