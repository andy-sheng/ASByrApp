//
//  ASTop10RootVC.m
//  ASByrApp
//
//  Created by andy on 16/4/1.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASTop10RootVC.h"
#import "ASTop10ListController.h"
#import "ASLoginController.h"
#import <ASByrToken.h>
#import <WMPageController.h>
#import <Masonry.h>

@interface ASTop10RootVC()<WMPageControllerDelegate, WMPageControllerDataSource>

@property(nonatomic, strong) UIBarButtonItem *manageTop10Btn;
@property(nonatomic, strong) NSArray * controllers;
@property(nonatomic, strong) NSArray * menuItems;

@end

@implementation ASTop10RootVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.controllers = @[
                             [[ASTop10ListController alloc] initWithTitle:@"十大" top10Type:ASByrTop10 sectionNo:0],
                             [[ASTop10ListController alloc] initWithTitle:@"1" top10Type:ASByrSectiontop sectionNo:1],
                             [[ASTop10ListController alloc] initWithTitle:@"2" top10Type:ASByrSectiontop sectionNo:2]
                             ];
        self.menuItems = @[@"十大", @"校园", @"学术"];
        self.showOnNavigationBar = YES;
        self.menuBGColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.manageTop10Btn;
    self.dataSource = self;
    self.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self updateViewConstraints];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![ASByrToken shareInstance].accessToken) {
       [self presentViewController:[[ASLoginController alloc] init] animated:YES completion:nil];
    }
}

//- (void)updateViewConstraints {
//    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(@64);
//        make.trailing.mas_equalTo(self.view.superview.mas_trailing);
//        make.bottom.mas_equalTo(self.view.superview.mas_bottom);
//        make.leading.mas_equalTo(self.view.superview.mas_leading);
//        NSLog(@"%f", self.navigationController.navigationBar.frame.size.height);
//        NSLog(@"%f",[[UIApplication sharedApplication] statusBarFrame].size.height);
//    }];
//    [super updateViewConstraints];
//}

#pragma mark - WMPageControllerDataSource

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return [self.menuItems count];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.controllers[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return [self.menuItems objectAtIndex:index];
}

#pragma mark - WMPageControllerDelegate
- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    ASBasicArticleListController* tmp = viewController;
    [tmp loadIfNotLoaded];
}

#pragma mark - event reponser

- (void)manageTop10 {

}

#pragma mark - getter and setter

- (UIBarButtonItem *)manageTop10Btn {
    if (_manageTop10Btn == nil) {
        _manageTop10Btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(manageTop10)];
    }
    return _manageTop10Btn;
}
@end
