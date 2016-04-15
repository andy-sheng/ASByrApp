//
//  ASThreadsReplyCell.h
//  ASByrApp
//
//  Created by andy on 16/4/15.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASThreadsReplyCell : UITableViewCell

- (void)setupWithFaceurl:(NSString*) faceUrl
                     uid:(NSString*) uid
                 content:(NSString*) content;

@end
