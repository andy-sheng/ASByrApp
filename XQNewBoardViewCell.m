//
//  XQNewBoardViewCell.m
//  ASByrApp
//
//  Created by lxq on 16/5/3.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQNewBoardViewCell.h"
#import <UIImageView+AFNetworking.h>
#define littleImageBoardWidth 4
@implementation XQNewBoardViewCell{
    NSDictionary * paramDic;
}

+ (XQNewBoardViewCell *)newCellWithIdentifier:(NSString *) identifier andParameters:(NSDictionary *)paramDictionary{
    XQNewBoardViewCell * cell = [[XQNewBoardViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier cellParameters:paramDictionary];
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellParameters:(NSDictionary *)parameters{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    paramDic = [NSDictionary dictionaryWithDictionary:parameters];
    if (self)
        [self setUpCellWithImage:paramDic[@"user"][@"face"] userName:paramDic[@"user"][@"uid"] postTimeStamp:paramDic[@"postTime"] replyCount:paramDic[@"replyCount"] articleTitle:paramDic[@"title"]];
    return self;
}

- (void)setUpCellWithImage:(NSString *)imageUrl userName:(NSString *)userName postTimeStamp:(NSString *)timestamp
                replyCount:(NSString *)replyCount articleTitle:(NSString *)titleName{
    self.textLabel.text = [titleName copy];
    __weak __typeof(self)wself=self;
    [self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] placeholderImage:[UIImage imageNamed:@"top10.png"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        [wself setCircleImage:image];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"fetch avatar image wrong!");
    }];
    //[oldImage setImageWithURL:[NSURL URLWithString:imageUrl]];
    //[self setCircleImage:oldImage];
}

- (void)setCircleImage:(UIImage *)oldView{
    CGFloat imageW = oldView.size.width+22*littleImageBoardWidth;
    CGFloat imageH = oldView.size.height+22*littleImageBoardWidth;
    
    CGSize imageSize = CGSizeMake(imageW, imageH);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    
    [[UIColor grayColor]set];
    
    CGFloat bigRadius = imageW *0.5;//大圆半径
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI*2, 0);
    
    CGContextFillPath(ctx);
    
    //小圆
    CGFloat smallRadius = bigRadius - littleImageBoardWidth;
    
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI*2, 0);
    
    //裁剪
    CGContextClip(ctx);
    
    //画图
    [oldView drawInRect:CGRectMake(littleImageBoardWidth, littleImageBoardWidth, imageW, imageH)];
    
    //取图
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    [self.imageView setImage:newImage];
    UIGraphicsEndImageContext();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
