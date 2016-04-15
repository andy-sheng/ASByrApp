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

@interface ASTop10RootVC()<WMPageControllerDelegate, WMPageControllerDataSource>

@property(nonatomic, strong) NSArray * controllers;
@property(nonatomic, strong) NSArray * menuItems;

@end

@implementation ASTop10RootVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.controllers = @[
                             [[ASTop10ListController alloc] initWithTitle:@"十大" top10Type:ASByrTop10 sectionNo:0],
                             [[ASTop10ListController alloc] initWithTitle:@"1" top10Type:ASByrSectiontop sectionNo:0],
                             [[ASTop10ListController alloc] initWithTitle:@"2" top10Type:ASByrSectiontop sectionNo:1]
                             ];
        self.menuItems = @[@"十大", @"校园", @"学术"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = self;
    self.delegate = self;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![ASByrToken shareInstance].accessToken) {
       [self presentViewController:[[ASLoginController alloc] init] animated:YES completion:nil];
    }
}

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
@end
