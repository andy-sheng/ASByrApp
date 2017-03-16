//
//  ASUtil.m
//  ASByrApp
//
//  Created by Andy on 2017/3/10.
//  Copyright © 2017年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NSURL* saveImage(UIImage* image, NSString* name) {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSURL *fileUrl = [NSURL fileURLWithPath:[dir stringByAppendingPathComponent:name]];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSError *err3;
    if (![data writeToURL:fileUrl options:NSDataWritingAtomic error:&err3]) {
        NSLog(@"save error:%@", err3);
        return nil;
    }
    
    return fileUrl;
}
