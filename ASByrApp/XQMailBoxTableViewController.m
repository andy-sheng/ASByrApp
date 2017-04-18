//
//  XQMailBoxTableViewController.m
//  ASByrApp
//
//  Created by lixiangqian on 17/4/10.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "XQMailBoxTableViewController.h"

@interface XQMailBoxTableViewController ()

@property (strong, nonatomic) NSMutableArray * receiveMailBoxArray;

@property (strong, nonatomic) NSMutableArray * sendMailBoxArray;

@property (strong, nonatomic) NSMutableArray * dropMailBoxArray;

@end

@implementation XQMailBoxTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style{
    if (self = [super initWithStyle:style]) {
        [self configureToolbarItems];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/
#pragma mark - private methods
- (void)configureToolbarItems{
    
    UISegmentedControl * sortToggle = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"收件箱",@"发件箱",nil]];
    sortToggle.selectedSegmentIndex = 0;
    [sortToggle addTarget:self action:@selector(changeMailBox) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = sortToggle;

}

- (void)changeMailBox{
    
}

#pragma mark - getters and setters

@end
