//
//  ASTop10Cell.h
//  ASByrApp
//
//  Created by andy on 16/4/6.
//  Copyright © 2016年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASTop10Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *sectionIcon;
@property (weak, nonatomic) IBOutlet UILabel *uid;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end
