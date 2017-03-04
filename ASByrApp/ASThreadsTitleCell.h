//
//  ASThreadsTitleCell.h
//  ASByrApp
//
//  Created by andy on 16/4/15.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ASThreadsTitleCellDelegate <NSObject>

@required

- (void)linkClicked:(NSURL*) url;

@end

@interface ASThreadsTitleCell : UITableViewCell

@property(nonatomic, weak) id <ASThreadsTitleCellDelegate> delegate;

- (void)setupWithTitle:(NSString*) title;

@end
