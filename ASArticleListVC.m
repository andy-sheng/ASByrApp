//
//  ASArticleListVC.m
//  ASByrApp
//
//  Created by andy on 16/4/18.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASArticleListVC.h"
#import "ASSectionListVC.h"

@interface ASArticleListVC()

@property(strong, nonatomic) UINavigationController * sectionListVC;
@property(strong, nonatomic) UIBarButtonItem *addPostBtn;
@property(strong, nonatomic) UIBarButtonItem *sectionListBtn;

@end
@implementation ASArticleListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addPostBtn = [[UIBarButtonItem alloc] initWithTitle:@"发帖" style:UIBarButtonItemStylePlain target:self action:@selector(addPost)];
    self.addPostBtn.image = [UIImage imageNamed:@"edit"];
    self.navigationItem.leftBarButtonItem = self.addPostBtn;
    
    self.sectionListBtn = [[UIBarButtonItem alloc] initWithTitle:@"版面" style:UIBarButtonItemStylePlain target:self action:@selector(listSection)];
    self.sectionListBtn.image = [UIImage imageNamed:@"list2"];
    self.navigationItem.rightBarButtonItem = self.sectionListBtn;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"xx版";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void) addPost {
    NSLog(@"add");
}

- (void)listSection {
    if (self.sectionListVC == nil) {
        self.sectionListVC = [[UINavigationController alloc] initWithRootViewController:[[ASSectionListVC alloc] init]];;
    }
    [self presentViewController:self.sectionListVC animated:YES completion:nil];
}

@end
