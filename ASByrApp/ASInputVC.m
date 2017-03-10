//
//  ASInputVCViewController.m
//  ASByrApp
//
//  Created by Andy on 2017/3/8.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "ASInputVC.h"
#import "ASKeyboard.h"
#import "ASInputTextCell.h"
#import "ASInputImageCell.h"
#import "ASSectionListVC.h"
#import "ASUtil.h"
#import <XQByrAttachment.h>
#import <ASByrAttachment.h>
#import <Masonry.h>


static const NSInteger kBoardRow = 0;
static const NSInteger kInputTitleRow = 1;
static const NSInteger kInputBodyRow = 2;
static const NSInteger kInputImageRow = 3;

@interface ASInputVC ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ASInputTextDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIBarButtonItem *sendBtn;

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) NSMutableArray *imgArr;

@property (nonatomic, strong) ASInputTextCell *inputTextCell;

@property (nonatomic, strong) NSArray *uploads;

@property (nonatomic, strong) ASByrAttachment *attachmentApi;

@property (nonatomic, strong) XQByrAttachment *attachment;

@end


@implementation ASInputVC

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.imgArr = [NSMutableArray array];
    }
    return self;
}

# pragma mark lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = self.sendBtn;
    [self.view setNeedsUpdateConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
    }];
    [super updateViewConstraints];
}

# pragma mark - ASInputTextDelegate
- (void)addPhoto {
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

# pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    [self.imgArr addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@", [info objectForKey:UIImagePickerControllerReferenceURL]);
    
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *imageName = [[info objectForKey:UIImagePickerControllerReferenceURL] lastPathComponent];
    
    NSURL *fileUrl = saveImage(img, imageName);
    
    __weak typeof(self)wself = self;
    [self.attachmentApi addAttachmentWithBoard:@"Advertising" file:fileUrl successBlock:^(NSInteger statusCode, id response) {
        __strong typeof(wself)sself = wself;
        if (sself) {
            sself.attachment = response;
            //sself.
        }
    } failureBlock:^(NSInteger statusCode, id response) {
        
    }];
    
    [self.inputTextCell willChangeValueForKey:@"contentText"];
    [self.inputTextCell.contentText appendString:@"asf[ema20]"];
    [self.inputTextCell didChangeValueForKey:@"contentText"];
}

# pragma mark - UITableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == kBoardRow) {
        [self.navigationController pushViewController:[[ASSectionListVC alloc] init] animated:YES];
    } else if (indexPath.row == kInputImageRow) {
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kInputBodyRow) {
        return XQSCREEN_H
        - self.navigationController.navigationBar.frame.origin.y
        - self.navigationController.navigationBar.frame.size.height
        - [tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:kBoardRow inSection:0]].size.height
        - [tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:kInputTitleRow inSection:0]].size.height;
    }
    return UITableViewAutomaticDimension;
}

# pragma mark - UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == kBoardRow) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.textLabel.text = @"版面";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == kInputTitleRow ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.textLabel.text = @"RE:";
    } else if (indexPath.row == kInputBodyRow) {
        cell = self.inputTextCell;
    } else if (indexPath.row == kInputImageRow) {
        cell = [[ASInputImageCell alloc] init];
    }
    return cell;
}


# pragma mark - Private methods

- (void)send {
    [self.tableView setNeedsLayout];
    NSLog(@"send");
}

# pragma makr - setters and getters

- (UITableView*)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50.0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIBarButtonItem*)sendBtn {
    if (_sendBtn == nil) {
        _sendBtn = [[UIBarButtonItem alloc] init];
        _sendBtn.title = @"发送";
        _sendBtn.target = self;
        _sendBtn.action = @selector(send);
    }
    return _sendBtn;
}

- (UIImagePickerController*)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

- (ASInputTextCell*)inputTextCell {
    if (_inputTextCell == nil) {
        _inputTextCell = [[ASInputTextCell alloc] init];
        _inputTextCell.attachment = self.attachment;
        _inputTextCell.delegate = self;
        [self addObserver:_inputTextCell forKeyPath:@"contentText" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:_inputTextCell forKeyPath:@"attachment" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _inputTextCell;
}

- (ASByrAttachment*)attachmentApi {
    if (_attachmentApi == nil) {
        _attachmentApi = [[ASByrAttachment alloc] initWithAccessToken:[ASByrToken shareInstance].accessToken];
    }
    return _attachmentApi;
}

- (XQByrAttachment*)attachment {
    if (_attachment == nil) {
        _attachment = [XQByrAttachment new];
    }
    return _attachment;
}


- (void)dealloc {
    [self removeObserver:self.inputTextCell forKeyPath:@"contentText"];
    [self removeObserver:self.inputTextCell forKeyPath:@"attachment"];
}
@end
