//
//  XQBoardView.h
//  ASByrApp
//
//  Created by lxq on 16/4/21.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQBoardView : UITableViewCell

- (void)setupWithface:(NSString*) faceUrl
                  uid:(NSString*) uid
                title:(NSString*) title;

@end
