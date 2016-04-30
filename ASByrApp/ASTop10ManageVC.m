//
//  ASTop10ManageVC.m
//  ASByrApp
//
//  Created by andy on 16/4/30.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASTop10ManageVC.h"
#import "ASTop10Manager.h"

@interface ASTop10ManageVC ()

@property(strong, nonatomic) ASTop10Manager * top10Manager;

@property(strong, nonatomic) UIBarButtonItem * doneBtn;
@end

@implementation ASTop10ManageVC

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self = [self initWithStyle:UITableViewStyleGrouped];
        self.top10Manager = [[ASTop10Manager alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.doneBtn;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setEditing:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.top10Manager shownItemsCount];
    } else {
        return [self.top10Manager hiddenItemsCount];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    if (indexPath.section == 0) {
        cell.textLabel.text = [self.top10Manager shownObjectAtIndex:indexPath.row].name;
    } else {
        cell.textLabel.text = [self.top10Manager hiddenObjectAtIndex:indexPath.row].name;
    }
    [cell setEditingAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return @"感兴趣的十大";
    }else {
        return @"不感兴趣的十大";
    }
}

#pragma mark - Table view delegate

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - event handler

- (void)doneBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter and setter

- (UIBarButtonItem *)doneBtn {
    if (_doneBtn == nil) {
        _doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneBtnClick)];
    }
    return _doneBtn;
}


@end
