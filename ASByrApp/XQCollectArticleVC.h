//
//  XQCollectArticleVC.h
//  ASByrApp
//
//  Created by lxq on 16/5/8.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQCollectArticleVC : UICollectionViewController


- (void)writeIntoFile:(NSString *)name articleInfo:(NSDictionary *)articleInfo;

@end
