//
//  ASThreadsReplyCell.h
//  ASByrApp
//
//  Created by andy on 16/4/15.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XQByrArticle;

@protocol ASThreadsReplyCellDelegate <NSObject>

@required

- (void)linkClicked:(NSURL*) url;

@end

@interface ASThreadsReplyCell : UITableViewCell

@property(nonatomic, weak) id <ASThreadsReplyCellDelegate> delegate;

- (void)setupWithArticle:(XQByrArticle*) article;

@end
