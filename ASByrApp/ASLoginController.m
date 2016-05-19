//
//  ASLoginController.m
//  ASByrApp
//
//  Created by andy on 16/4/8.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASLoginController.h"

#import "ASByrOAth2.h"
#import "ASByrToken.h"
#import "Masonry.h"

@interface ASLoginController()<UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webview;

@property(nonatomic, strong) ASByrOAth2 * oath;

@property(nonatomic, assign) BOOL test;
@end

@implementation ASLoginController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.test = NO;
        self.oath = [[ASByrOAth2 alloc] initWithAppkey:@"dcaea32813eca7e0a547728b73ab060a"
                                           redirectUri:[NSURL URLWithString:@"http://bbs.byr.cn/oauth2/callback"]
                                               appleId:@""
                                              bundleId:@""];
    }
    return self;
}

# pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webview = [[UIWebView alloc] init];
    self.webview.delegate = self;
    
    
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[self.oath oathUrl]]];
    [self.view addSubview:self.webview];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.trailing.equalTo(self.view.mas_trailing);
        make.bottom.equalTo(self.view.mas_bottom);
        make.leading.equalTo(self.view.mas_leading);
    }];
}


#pragma mark - UIWebViewDelegate


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //[self.oath parseRedirectUri:webView.request.URL.absoluteString];
    //NSString * url = webView.request.URL.absoluteString;
    if ([self.oath parseRedirectUri:webView.request.URL.absoluteString]) {
        //[byrToken saveToken];
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"success");
    } else {
        NSLog(@"fail");
    }
}










@end
