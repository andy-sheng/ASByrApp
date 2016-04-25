//
//  XQBoardListVC.m
//  ASByrApp
//
//  Created by lxq on 16/4/24.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "XQBoardListVC.h"
#import "ASArticleListVC.h"
#import <ASByrBoard.h>

@interface XQBoardListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (copy, nonatomic) NSString *sectionName;
@end

@implementation XQBoardListVC{
    NSMutableArray * __block subSectionNameList;
    NSMutableArray * __block subSectionDescripList;
    NSMutableArray * __block subBoardNameList;
    NSMutableArray * __block subBoardDescripList;
}

- (instancetype)initWithSectionName:(NSString *)sectionName{
    self = [super init];
    if (self) {
        self.sectionName=sectionName;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self loadData:self.sectionName];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UITableView *tableView = [[UITableView alloc]initWithFrame:[[UIScreen mainScreen]bounds] style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate=self;
    tableView.dataSource=self;
    self.view=tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData:(NSString *)sectionName{
    subBoardNameList=[[NSMutableArray alloc]init];
    subBoardDescripList = [[NSMutableArray alloc]init];
    subSectionDescripList = [[NSMutableArray alloc]init];
    ASByrBoard *netBoard =[[ASByrBoard alloc]initWithAccessToken:[ASByrToken shareInstance].accessToken];
    
    [netBoard fetchSectionInfoWithName:sectionName successBlock:^(NSInteger statusCode, id response) {
        if ([response[@"sub_section"] count]>0)
            subSectionNameList=[NSMutableArray arrayWithArray:response[@"sub_section"]];//读到的子分区
        if ([response[@"board"] count]>0){
            NSUInteger j=0;
            while (j<[response[@"board"] count]) {
                NSDictionary *responseDic = response[@"board"][j];
                [subBoardDescripList addObject:responseDic[@"description"]];
                [subBoardNameList addObject:responseDic[@"name"]];
                j++;
            }
        }
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"OtherSectionList" ofType:@"plist"];
        NSDictionary * dict = [[NSDictionary alloc]initWithContentsOfFile:filePath];
        NSString * sectionListName;
        for (sectionListName in subSectionNameList)
            [subSectionDescripList addObject:dict[sectionListName]];
        [self.tableView reloadData];
    } failureBlock:^(NSInteger statusCode, id response) {
        NSLog(@"Fetch subsections and boards Info fail!");
    }];    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return [subSectionNameList count]+[subBoardNameList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuseSectionIdentifier = @"subSection";
    static NSString * reuseBoardIdentifier = @"otherBoard";
    UITableViewCell *cell;
    if (indexPath.section<[subSectionNameList count]){
        cell = [tableView dequeueReusableCellWithIdentifier:reuseSectionIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseSectionIdentifier];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=subSectionDescripList[indexPath.section];
        }
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:reuseBoardIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseBoardIdentifier];
            cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"collection.png"]];
            [cell.accessoryView setFrame:CGRectMake(0, 0, 24, 24)];
            //NSUInteger indexSection=indexPath.section-[subSectionNameList count];
            NSLog(@"section下表%ld",indexPath.section);
            //NSLog(@"index下标%lu",indexSection);
        }
        cell.textLabel.text=subBoardDescripList[indexPath.section-[subSectionNameList count]];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section<[subSectionNameList count]) {
        XQBoardListVC * boardListView=[[XQBoardListVC alloc]initWithSectionName:[subSectionNameList objectAtIndex:indexPath.section]];
        [self.navigationController pushViewController:boardListView animated:YES];
    }else{
        NSUInteger indexSection=indexPath.section-[subSectionNameList count];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"chooseBoardFromAllSection" object:nil
                                                             userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[subBoardNameList objectAtIndex:indexSection],[subBoardDescripList objectAtIndex:indexSection],nil] forKeys:[NSArray arrayWithObjects:@"boardName",@"boardDescription",nil]]];
        }];
    }
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

@end
