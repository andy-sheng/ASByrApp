//
//  ASThreadsReplyCell.h
//  ASByrApp
//
//  Created by andy on 16/4/15.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ASThreadsReplyCellDelegate <NSObject>

@required

- (void)linkClicked:(NSURL*) url;

@end

@interface ASThreadsReplyCell : UITableViewCell

@property(nonatomic, strong) id <ASThreadsReplyCellDelegate> delegate;

- (void)setupWithFaceurl:(NSString*) faceUrl
                     uid:(NSString*) uid
                 content:(NSString*) content;

@end
