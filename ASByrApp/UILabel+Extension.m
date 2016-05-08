//
//  UILabel+Extension.m
//  ASByrApp
//
//  Created by lxq on 16/4/14.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "UILabel+Extension.h"
#import "UIColor+Hex.h"

@implementation UILabel (Extension)

- (UILabel *)setUpRoundLabelWithBackgroundColor:(NSString *) colorHex{
    UILabel * roundLabel=[[UILabel alloc]init];
    //填充到label最大
    roundLabel.numberOfLines=1;
    roundLabel.adjustsFontSizeToFitWidth=YES;
    roundLabel.backgroundColor=[UIColor colorWithHexString:colorHex];
    return roundLabel;
}

@end