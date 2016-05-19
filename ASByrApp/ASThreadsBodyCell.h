//
//  ASThreadsBodyCell.h
//  ASByrApp
//
//  Created by andy on 16/4/15.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ASThreadsBodyCellDelegate <NSObject>

@required

- (void)linkClicked:(NSURL*) url;

@end

@interface ASThreadsBodyCell : UITableViewCell

@property(nonatomic, strong) id <ASThreadsBodyCellDelegate> delegate;

- (void)setupWithContent:(NSString*)content;

@end
