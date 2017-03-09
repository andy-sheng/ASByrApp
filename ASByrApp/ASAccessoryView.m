//
//  ASAccessoryView.m
//  ASByrApp
//
//  Created by Andy on 2017/3/8.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "ASAccessoryView.h"

@implementation ASAccessoryView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)addPhoto:(id)sender {
    if (self.addPhotoBlock) {
        self.addPhotoBlock();
    }
}


- (IBAction)dismiss:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

@end
