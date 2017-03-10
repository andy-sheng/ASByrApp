//
//  ASInputTextCell.h
//  ASByrApp
//
//  Created by Andy on 2017/3/8.
//  Copyright © 2017年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XQByrAttachment.h>

@protocol ASInputTextDelegate <NSObject>

@optional
- (void)addPhoto;

@end

@interface ASInputTextCell : UITableViewCell

@property (nonatomic, weak) XQByrAttachment *attachment;
@property (nonatomic, weak) NSMutableString *contentText;
@property (nonatomic, weak) id<ASInputTextDelegate> delegate;

@end
