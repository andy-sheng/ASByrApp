//
//  ASEmotionInput.h
//  ASByrApp
//
//  Created by Andy on 2017/3/15.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "ASInputCommon.h"
#import <UIKit/UIKit.h>

@interface ASEmotionCell : UICollectionViewCell

- (void)setEmotion:(NSString*) imgName;

@end

@interface ASEmotionInput : UIView

@property (nonatomic, copy) ASActionBlock addEmotionBlock;

@end
