//
//  TestViewController.m
//  ASByrApp
//
//  Created by andy on 16/4/6.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "TestViewController.h"
#import "ASKeyboard.h"

#import "NSAttributedString+ASUBB.h"

#import "FLAnimatedImage.h"
#import "OLImage.h"
#import "YYLabel.h"
#import "YYText.h"
#import "TTTAttributedLabel.h"
#import <MBProgressHUD.h>
//#import <YYText.h>
@interface TestViewController ()
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *testLabel;
@property (strong, nonatomic) ASKeyboard *keyboard;

@end

@implementation TestViewController
- (IBAction)popup:(id)sender {
    [self.keyboard pop];
}

- (IBAction)hide:(id)sender {
    [self.keyboard hide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"adsfasdfa"];
//    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, 2)];
//    [str addAttribute:NSLinkAttributeName value:@"https://google.com" range:NSMakeRange(2, 2)];
//
//    [str replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
//    
//    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
//    attach.image = [UIImage imageNamed:@"em1.gif"];
//    attach.bounds = CGRectMake(0, 0, 20, 20);
//    [str yy_setColor:[UIColor greenColor] range:NSMakeRange(4, 1)];
//    //[str addAttribute:NSAttachmentAttributeName value:attach range:NSMakeRange(3, 2)];
//    NSAttributedString *str2 = [NSMutableAttributedString attributedStringWithAttachment:attach];
//    [str appendAttributedString:str2];
//    [self.testLabel setAttributedText:str];
    self.keyboard = [[ASKeyboard alloc] init];
    
    [self.view addSubview:self.keyboard];
    self.testLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"sdfasdf http://www.baidu.com asdfasf"];
    [self.testLabel setText:str];

//
//    NSMutableAttributedString *text = [NSMutableAttributedString new];
//    UIFont *font = [UIFont systemFontOfSize:16];
//    
//    
//    NSString *title = @"This is UIImage attachment:";
//    [text appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
//    
//    
//    
//
//    [self.testLabel setAttributedText:text];
//    
//    YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(100, 100, 400, 400)];
//    [label setAttributedText:text];
//    [self.view addSubview:label];
    //NSLog(@"%@", keyboard.inputView)
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //NSLog(@"%@", self.keyboard.inputView);
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
