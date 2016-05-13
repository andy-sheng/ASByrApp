//
//  ASTop10Cell.m
//  ASByrApp
//
//  Created by andy on 16/4/6.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASTop10Cell.h"
#import <UIImageView+AFNetworking.h>

@interface ASTop10Cell()

@property (weak, nonatomic) IBOutlet UIImageView *faceView;
@property (weak, nonatomic) IBOutlet UILabel *uidLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIView *colorBar;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@property (strong, nonatomic) NSString * faceUrl;
@property (strong, nonatomic) NSString * uid;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * content;

@end

@implementation ASTop10Cell

#pragma mark - life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setup

- (void)setupWithface:(NSString *)faceUrl
                  uid:(NSString *)uid
                title:(NSString *)title
              content:(NSString *)content
                  num:(NSUInteger)num {
    [self.faceView setImageWithURL:[NSURL URLWithString:faceUrl]];
    self.uidLabel.text = uid;
    self.titleLabel.text = title;
    self.contentLabel.text = content;
    self.numLabel.text = [NSString stringWithFormat:@"%ld", num];
    if ([content isEqualToString:@""] || content == nil) {
        self.arrow.hidden = YES;
    } else {
        self.arrow.hidden = NO;
    }
}

#pragma mark - setter and getter



@end
