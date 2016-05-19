//
//  XQBoardView.m
//  ASByrApp
//
//  Created by lxq on 16/4/21.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQBoardView.h"
#import "UIImageView+AFNetworking.h"

@interface XQBoardView()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation XQBoardView
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - setup

- (void)setupWithface:(NSString *)faceUrl
                  uid:(NSString *)uid
                title:(NSString *)title{
    [self.image setImageWithURL:[NSURL URLWithString:faceUrl]];
    self.userName.text = uid;
    self.title.text = title;
    
    self.title.lineBreakMode = NSLineBreakByWordWrapping;
    self.title.numberOfLines = 0;
    [self updateTitleConstraints];    
}

#pragma 自适应标题的高度
-(void)updateTitleConstraints{
    
    CGRect txtFrame = self.title.frame;
    
    self.title.frame = CGRectMake(10, 100, 300,
                                  txtFrame.size.height =[self.title.text boundingRectWithSize:
                                                         CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                   attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.title.font,NSFontAttributeName, nil] context:nil].size.height);
    
    self.title.frame = CGRectMake(10, 100, 300, txtFrame.size.height);
}
@end
