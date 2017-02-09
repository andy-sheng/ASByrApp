//
//  UIAlertController+Extension
//  ASByrApp
//
//  Created by lixiangqian on 17/2/9.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "UIAlertController+Extension.h"

@implementation UIAlertController(Extension)

+ (UIAlertController *)alertControllerWithBriefInfo:(NSString *)message{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    return alertController;
}

@end
