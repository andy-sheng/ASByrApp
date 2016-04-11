//
//  TestViewController.m
//  ASByrApp
//
//  Created by andy on 16/4/6.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "TestViewController.h"
#import <YYText.h>
@interface TestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testLabel;


@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"adsfasdfa"];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, 2)];
    [str addAttribute:NSLinkAttributeName value:@"https://google.com" range:NSMakeRange(2, 2)];

    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"top10.png"];
    attach.bounds = CGRectMake(0, 0, 20, 20);
    [str yy_setColor:[UIColor greenColor] range:NSMakeRange(4, 1)];
    //[str addAttribute:NSAttachmentAttributeName value:attach range:NSMakeRange(3, 2)];
    NSAttributedString *str2 = [NSMutableAttributedString attributedStringWithAttachment:attach];
    [str appendAttributedString:str2];
    [self.testLabel setAttributedText:str];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
