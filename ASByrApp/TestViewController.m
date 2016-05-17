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

#import <MBProgressHUD.h>
//#import <YYText.h>
@interface TestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
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
//    attach.image = [UIImage imageNamed:@"top10.png"];
//    attach.bounds = CGRectMake(0, 0, 20, 20);
//    [str yy_setColor:[UIColor greenColor] range:NSMakeRange(4, 1)];
//    //[str addAttribute:NSAttachmentAttributeName value:attach range:NSMakeRange(3, 2)];
//    NSAttributedString *str2 = [NSMutableAttributedString attributedStringWithAttachment:attach];
//    [str appendAttributedString:str2];
   // [self.testLabel setAttributedText:str];
    self.keyboard = [[ASKeyboard alloc] init];
    
    [self.view addSubview:self.keyboard];
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithUBB:@"123[size=10]asdf[/size]asdf[code]abcd[/code]as[i]fd[/i]"];
    //NSAttributedString * attrStr = [[NSAttributedString alloc] initWithUBB:@"12[b]34[/b]56"];
//    [parser parserUbb:@"[b]处了一段时间，其他都好，就是两个人的想法、观点冲突太大。也不知道是她的问题还是我的问题，大家都快给评评理吧，都要上爱情保卫战了。。。我想了很久也没有想明白。现在她总是认为她是对的，我认为她不对。大家都说说吧，我会让她看到的。如果是我的问题告诉我，我改，处一个对象不容易，不想分。跟她处了一段时间，完全不懂她。我（28）比她大三岁（25），我是东北人，父母都是东北人。她也是东北人，她爸东北人，她妈天津人。[/b]\n\n[b]想法一：[/b]\n        男朋友的对话：自己父母都60多了，还在工作，很辛苦。\n        女朋友的对话：你爸妈有儿有孙子有孙女的（我还有哥），干的更有劲啊。\n\n[b]想法二：[/b]\n        男朋友的对话：自己家里将来分家的话，想让哥哥多得些，哥哥不在北京，要在家照顾父母。\n        女朋友的对话：女朋友说我划不清里外拐，说我不知道将来跟谁过日子，她妈因此说我对她不好。\n\n[b]想法三：[/b]\n        女朋友的对话：如果女朋友家里有弟弟的话，那男朋友应该给弟弟零花钱，负责这个弟弟上学，娶老婆。\n        男朋友的对话：这样就不算里外拐了？？\n        女朋友的对话：现在都是这样啊，她大姨家就是这样的啊·····。 女朋家庭白白给你养了一个媳妇，你不知道感恩吗？\n\n[b]想法四：[/b]\n        男朋友的对话：北京压力大，买房子两个家庭都出一份力吧（我自己家出钱刚买完）。\n        女朋友的对话：买房子是给你和你孩子住，跟我有什么关系。\n        男朋友的对话：那不买房子了，租房子住吧.\n        女朋友的对话：现在结婚哪有不买房子的呢。\n     \n[b]想法五：[/b]\n        男朋友的对话：咱俩结婚你家应该出嫁妆吧。   \n        女朋友的对话：我给你生你家的种，竟然还让我家出钱？\n        男朋友的对话：没有嫁妆也行，那咱俩努力工作吧，多赚点钱。\n        女朋友的对话：别闹了，工作是你们男人的责任啊，我生儿育女已经很辛苦了啊。\n        男朋友的对话：你怎么育的，还不是我家人过来看孩子(她说她妈身体不好，他爸照顾她妈妈)。\n        女朋友的对话：生孩子已经很辛苦了。哪里有给生孩子教育孩子还给老公赚钱的傻逼女人呢，我也要一个。\n        男朋友的对话：咱俩结婚你家要彩礼吗？\n        女朋友的对话：一般都要。\n[b]想法六（我俩现在没有分手，又和好了，但是问题还是没有解决）：[/b]\n        男朋友的对话：咱俩观点冲突太大，分手吧。\n        女朋友的对话：你嫌弃我没钱是吗，你等着我将来肯定比你有钱。\n        男朋友的对话：不是的，不是钱的事。\n        女朋友的对话：就是钱的事，你不明说。\n \n--\n"];
    [self.testLabel setAttributedText:attrStr];
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
