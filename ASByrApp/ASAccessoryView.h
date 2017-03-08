//
//  ASAccessoryView.h
//  ASByrApp
//
//  Created by Andy on 2017/3/8.
//  Copyright © 2017年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ASActionBlock)();

@interface ASAccessoryView : UIToolbar

@property (nonatomic, copy) ASActionBlock addPhotoBlock;

@property (nonatomic, copy)ASActionBlock dismissBlock;

@end
