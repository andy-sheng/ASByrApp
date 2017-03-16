//
//  ASAccessoryView.m
//  ASByrApp
//
//  Created by Andy on 2017/3/8.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "ASAccessoryView.h"

@interface ASAccessoryView ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *emotionBtn;

@end


@implementation ASAccessoryView {
    BOOL _emotionPressed;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _emotionPressed = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)addPhoto:(id)sender {
    if (self.addPhotoBlock) {
        self.addPhotoBlock(nil);
    }
}

- (IBAction)addEmotion:(id)sender {
    
    if (self.addEmotionBlock) {
        self.addEmotionBlock(nil);
    }
}

- (IBAction)dismiss:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock(nil);
    }
}


@end
