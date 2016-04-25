//
//  ASSectionListVC.m
//  ASByrApp
//
//  Created by andy on 16/4/18.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ASSectionListVC.h"
#import "XQBoardListVC.h"

@interface ASSectionListVC ()

@property(strong, nonatomic) UIBarButtonItem * dismissBtn;
@property(strong, nonatomic) NSMutableArray *sectionNameList;
@property(strong, nonatomic) NSMutableArray *sectionDescripList;

@end

@implementation ASSectionListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dismissBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"down"] style:UIBarButtonItemStyleDone target:self action:@selector(dismissVC)];
    self.navigationItem.rightBarButtonItem = self.dismissBtn;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:[[UIScreen mainScreen]bounds] style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate=self;
    tableView.dataSource=self;
    [self loadRootSectionData];
    
    self.view=tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"版面列表";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRootSectionData{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"RootSectionList" ofType:@"plist"];
    ///self.sectionList = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    NSDictionary * dict = [[[NSDictionary alloc]initWithContentsOfFile:filePath] objectForKey:@"Section"];
    self.sectionNameList=[NSMutableArray arrayWithCapacity:[dict count]];
    self.sectionDescripList=[NSMutableArray arrayWithCapacity:[dict count]];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.sectionNameList addObject:key];
        [self.sectionDescripList addObject:obj];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
<<<<<<< HEAD
#warning Incomplete implementation, return the number of sections
    return [self.sectionNameList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
=======
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
>>>>>>> upstream/master
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"XQRootSection";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text=[self.sectionDescripList objectAtIndex:indexPath.section];
    return cell;
    // Configure the cell...
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"%@",[self.sectionNameList objectAtIndex:indexPath.section]);
    XQBoardListVC * boardListView=[[XQBoardListVC alloc]initWithSectionName:[self.sectionNameList objectAtIndex:indexPath.section]];
    [self.navigationController pushViewController:boardListView animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
