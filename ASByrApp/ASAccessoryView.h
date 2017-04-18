//
//  ASAccessoryView.h
//  ASByrApp
//
//  Created by Andy on 2017/3/8.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "ASInputCommon.h"
#import <UIKit/UIKit.h>


@interface ASAccessoryView : UIToolbar

@property (nonatomic, copy) ASActionBlock addPhotoBlock;

@property (nonatomic, copy)ASActionBlock dismissBlock;

@property (nonatomic, copy) ASActionBlock addEmotionBlock;

@end
