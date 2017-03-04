//
//  ASTop10Cell.h
//  ASByrApp
//
//  Created by andy on 16/4/6.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XQByrArticle.h"
#import "XQByrUser.h"

@interface ASTop10Cell : UITableViewCell

- (void)setupWithface:(NSString*) faceUrl
                  uid:(NSString*) uid
                title:(NSString*) title
              content:(NSString*) content
                  num:(NSUInteger)num;

- (void)setupWithArticle:(XQByrArticle*)article
                     num:(NSUInteger)num;
    
@end
