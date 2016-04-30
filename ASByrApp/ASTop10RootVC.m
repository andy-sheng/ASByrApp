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
#import "ASTop10ManageVC.h"
#import "ASTop10Manager.h"

#import <ASByrToken.h>
#import <WMPageController.h>
#import <Masonry.h>

@interface ASTop10RootVC()<WMPageControllerDelegate, WMPageControllerDataSource>

@property(nonatomic, strong) UIBarButtonItem *manageTop10Btn;

@property(nonatomic, strong) NSArray * controllers;

@property(nonatomic, strong) NSArray * menuItems;

@property(nonatomic, strong) ASTop10Manager * top10Manager;
@end

@implementation ASTop10RootVC

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableArray *controllers = [NSMutableArray array];
        NSMutableArray *titles = [NSMutableArray array];
        self.top10Manager = [[ASTop10Manager alloc] init];
        for (int i = 0; i < [self.top10Manager shownItemsCount]; ++i) {
            ASTop10ManageItem * item = [self.top10Manager shownObjectAtIndex:i];
            [controllers addObject:[[ASTop10ListController alloc] initWithTitle:item.name
                                                                      top10Type:item.type
                                                                      sectionNo:item.section]];
            [titles addObject:item.name];
        }
        self.controllers = controllers;
        self.menuItems   = titles;
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
    UIViewController *tmp = [[ASTop10ManageVC alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:tmp]
                       animated:YES
                     completion:nil];
}

#pragma mark - getter and setter

- (UIBarButtonItem *)manageTop10Btn {
    if (_manageTop10Btn == nil) {
        _manageTop10Btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                        target:self
                                                                        action:@selector(manageTop10)];
    }
    return _manageTop10Btn;
}

@end
