//
//  ASTop10Cell.h
//  ASByrApp
//
//  Created by andy on 16/4/6.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASTop10Cell : UITableViewCell

- (void)setupWithface:(NSString*) faceUrl
                  uid:(NSString*) uid
                title:(NSString*) title
              content:(NSString*) content;

@end
