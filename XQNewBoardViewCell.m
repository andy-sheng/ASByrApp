//
//  XQNewBoardViewCell.m
//  ASByrApp
//
//  Created by lxq on 16/5/3.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQNewBoardViewCell.h"
#import "UIColor+Hex.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

@implementation XQNewBoardViewCell

+ (XQNewBoardViewCell *)newCellWithIdentifier:(NSString *)identifier andStyle:(UITableViewCellStyle)style andParameters:(NSDictionary *)paramDictionary{
    
    XQNewBoardViewCell *cell = [[XQNewBoardViewCell alloc]initWithStyle:style reuseIdentifier:identifier];
    [cell setUpCellWithParameters:paramDictionary];
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier{
    self=[super initWithStyle:style reuseIdentifier:identifier];
    if (self)
    {
        UIView *wapView = [UIView new];
        self.wapView=wapView;
        [self.contentView addSubview:wapView];
        
        UIImageView * imView=[UIImageView new];
        self.imView=imView;
        [self.imageView removeFromSuperview];
        imView.layer.masksToBounds=YES;
        imView.layer.cornerRadius=IMAGE_WIDTH/2;
        imView.layer.borderWidth =1;
        imView.layer.borderColor = [UIColor colorWithHexString:IMAGE_BACKCOLOR].CGColor;
        //imView.layer.borderColor = [UIColor grayColor].CGColor;
        [wapView addSubview:imView];
        
        UILabel * titleLabel=[UILabel new];
        self.titleLabel = titleLabel;
        titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        titleLabel.numberOfLines=0;
        titleLabel.preferredMaxLayoutWidth=[UIScreen mainScreen].bounds.size.width-2*PADDING_TO_CONTENTVIEW;
        [wapView addSubview:titleLabel];
        
        UILabel *timeLabel = [UILabel new];
        self.timeLabel = timeLabel;
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.numberOfLines=1;
        [wapView addSubview:timeLabel];
        
        UILabel * nameLabel = [UILabel new];
        self.nameLabel = nameLabel;
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.textColor = [UIColor blueColor];
        nameLabel.numberOfLines=1;
        [wapView addSubview:nameLabel];
        
        UILabel * replyLabel = [UILabel new];
        self.replyLabel = replyLabel;
        replyLabel.font = [UIFont systemFontOfSize:12];
        replyLabel.numberOfLines=1;
        [wapView addSubview:replyLabel];
        

        [wapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(PADDING_TO_CONTENTVIEW);
        make.top.equalTo(self.contentView.mas_top).offset(PADDING_TO_CONTENTVIEW);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-PADDING_TO_CONTENTVIEW);
        make.right.equalTo(self.contentView.mas_right).offset(-PADDING_TO_CONTENTVIEW);
        }];
        
        [imView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wapView).offset(PADDING_WITHIN);
            make.left.equalTo(wapView).offset(PADDING_WITHIN);
            make.size.mas_equalTo(CGSizeMake(IMAGE_WIDTH, IMAGE_WIDTH));
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imView.mas_right).offset(PADDING_WITHIN);
            make.centerY.equalTo(imView.mas_centerY);
            make.width.mas_lessThanOrEqualTo(@100);
        }];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_right).offset(PADDING_WITHIN);
            make.centerY.equalTo(nameLabel);
            make.width.mas_lessThanOrEqualTo(@100);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wapView.mas_left).offset(PADDING_TO_CONTENTVIEW);
            make.top.equalTo(imView.mas_bottom).offset(PADDING_WITHIN);
            make.bottom.equalTo(wapView).offset(-PADDING_WITHIN);
            make.right.equalTo(wapView.mas_right).offset(-PADDING_TO_CONTENTVIEW);
        }];
        
        [replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wapView.mas_right).offset(-PADDING_TO_CONTENTVIEW);
            make.centerY.equalTo(imView.mas_centerY);
            make.width.lessThanOrEqualTo(@100);
        }];
        
        [super updateConstraints];
        /* code */
    }
    return self;
}

- (void)setUpCellWithParameters:(NSDictionary *)paramDictionary{
    if (paramDictionary!=nil) {
        //当前时间戳
        NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval currentStamp = [currentDate timeIntervalSince1970];
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
        
        if ([paramDictionary[@"isTop"] isEqual:@1]){
            [formatter setDateFormat:@"yyyy.MM.dd"];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[paramDictionary[@"postTime"] longValue]];
            self.timeLabel.text = [formatter stringFromDate:date];
        }else{
            NSTimeInterval middleTime = currentStamp - [paramDictionary[@"postTime"] doubleValue];
            if (middleTime<D_MINUTE)
                self.timeLabel.text=@"刚刚";
            else if (middleTime<D_HOUR){
                NSInteger minuteCount = middleTime/D_MINUTE;
                self.timeLabel.text=[NSString stringWithFormat:@"%ld分钟前",(long)minuteCount];
            }else if (middleTime<D_DAY){
                NSInteger hourCount = middleTime/D_HOUR;
                self.timeLabel.text=[NSString stringWithFormat:@"%ld小时前",hourCount];
            }else if (middleTime<2*D_DAY)
                self.timeLabel.text = @"昨天";
            else{
                [formatter setDateFormat:@"MM.dd"];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[paramDictionary[@"postTime"] longValue]];
                self.timeLabel.text = [formatter stringFromDate:date];
            }
        }
        self.titleLabel.text = [paramDictionary[@"title"] copy];
        self.nameLabel.text = [paramDictionary[@"user"][@"uid"] copy];
        self.replyLabel.text = [[NSString stringWithFormat:@"%@条回复",paramDictionary[@"replyCount"]] copy];
        [self.imView sd_setImageWithURL:[NSURL URLWithString:paramDictionary[@"user"][@"face"]]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
