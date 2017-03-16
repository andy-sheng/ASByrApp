//
//  NewInputVC.m
//  ASByrApp
//
//  Created by Andy on 2017/3/10.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "ASInputVC.h"
#import "ASAccessoryView.h"
#import "ASEmotionInput.h"
#import "ASUtil.h"
#import "ASUbbParser.h"
#import <XQByrArticle.h>
#import <XQByrUser.h>
#import <XQByrAttachment.h>
#import <ASByrAttachment.h>
#import <ASByrArticle.h>
#import <Masonry.h>
#import <YYText.h>

@interface ASInputVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, YYTextViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIBarButtonItem *sendBtn;

@property (nonatomic, strong) ASUbbParser *ubbParser;

@property (nonatomic, strong) YYTextView *textView;

@property (nonatomic, strong) YYTextView *preshowView;

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) ASByrAttachment *attachmentApi;

@property (nonatomic, strong) ASByrArticle *articleApi;

@property (nonatomic, strong) XQByrAttachment *attachment;

@property (nonatomic, strong) XQByrArticle *replyTo;

@property (nonatomic, strong) ASEmotionInput *emotionInputView;

@end

@implementation ASInputVC

- (instancetype)initWithReplyArticle:(XQByrArticle *)article {
    return [self initWithReplyArticle:article input:@""];
}

- (instancetype)initWithReplyArticle:(XQByrArticle *)article input:(NSString *)input {
    self = [self init];
    if (self != nil) {
        self.replyTo = article;
        [self.textView insertText:[NSString stringWithFormat:@"【 在 %@ 的大作中提到: 】\n%@", self.replyTo.user.user_name, self.replyTo.content]];
        [self.textView insertText:input];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.sendBtn;
    //self.inputView
    [self.scrollView addSubview:self.textView];
    [self.scrollView addSubview:self.preshowView];
    [self.view addSubview:self.scrollView];
    [self.view setNeedsUpdateConstraints];
    // Do any additional setup after loading the view.
}

- (void)updateViewConstraints {
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self.scrollView);
        make.size.equalTo(self.scrollView);
    }];
    [self.preshowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView.mas_right);
        make.top.right.bottom.equalTo(self.scrollView);
        make.size.equalTo(self.scrollView);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(self.view);
        make.height.equalTo(@(self.view.frame.size.height - 64));
    }];
    [super updateViewConstraints];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
# pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
    if (textView == self.textView) {
        [self.preshowView setText:self.textView.text];
    }
}
# pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];

    
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *imageName = [[info objectForKey:UIImagePickerControllerReferenceURL] lastPathComponent];
    
    NSURL *fileUrl = saveImage(img, imageName);
    
    __weak typeof(self)wself = self;
    [self.attachmentApi addAttachmentWithBoard:self.replyTo.board_name aid:self.replyTo.aid file:fileUrl successBlock:^(NSInteger statusCode, id response) {
        __strong typeof(wself)sself = wself;
        if (sself) {
            sself.attachment = response;
            sself.ubbParser.attachment = response;
            sself.textView.text = [NSString stringWithFormat:@"%@[upload=%ld][/upload]\n", sself.textView.text, sself.attachment.file.count];
        }
    } failureBlock:^(NSInteger statusCode, id response) {
        NSLog(@"%@", response);
    }];
    

}


# pragma mark - Private methods

- (void)send {
    [self.articleApi postArticleWithBoard:self.replyTo.board_name title:@"" content:self.textView.text reid:self.replyTo.aid successBlock:^(NSInteger statusCode, id response) {
        NSLog(@"done");
    } failureBlock:^(NSInteger statusCode, id response) {
        NSLog(@"fail:%@", response);
    }];
}

- (void)addPhoto {
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)addEmotion {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.35];
    
    [self.textView resignFirstResponder];
    self.textView.inputView = self.textView.inputView ? nil : self.emotionInputView;
    [self.textView becomeFirstResponder];
    
    [UIView commitAnimations];
}

# pragma makr - Setters and Getters

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


- (UIScrollView*)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(375 * 2, 667 - 64);
    }
    return _scrollView;
}

- (YYTextView*)textView {
    if (_textView == nil) {
        _textView = [[YYTextView alloc] init];
        _textView.textAlignment = NSTextAlignmentNatural;
        _textView.placeholderText = @"输入帖子内容";
        ASAccessoryView *accessoryView = (ASAccessoryView*)[[NSBundle mainBundle] loadNibNamed:@"ASAccessoryView" owner:nil options:nil][0];
        
        __weak typeof(self)wself = self;
        accessoryView.addPhotoBlock = ^(id context){
            __strong typeof(wself)sself = wself;
            if (sself) {
                [sself addPhoto];
            }
        };
        
        accessoryView.addEmotionBlock = ^(id context){
            __strong typeof(wself) sself = wself;
            if (sself) {
                [sself addEmotion];
            }
        };
        
        accessoryView.dismissBlock = ^(id context){
            __strong typeof(wself)sself = wself;
            if (sself) {
                [sself.textView resignFirstResponder];
            }
        };
        _textView.delegate = self;
        _textView.inputAccessoryView = accessoryView;
        [_textView setFont:[UIFont systemFontOfSize:17]];
    }
    return _textView;
}

- (ASEmotionInput*)emotionInputView {
    if (_emotionInputView == nil) {
        _emotionInputView = [[NSBundle mainBundle] loadNibNamed:@"ASEmotionInput" owner:nil options:nil][0];
        
        __weak typeof(self)wself = self;
        _emotionInputView.addEmotionBlock = ^(id context){
            __strong typeof(wself) sself = wself;
            if (sself) {
                [sself.textView insertText:context];
            }
        };
    }
    return _emotionInputView;
}

- (YYTextView*)preshowView {
    if (_preshowView == nil) {
        _preshowView = [[YYTextView alloc] init];
        _preshowView.placeholderText = @"预览";
        _preshowView.editable = NO;
        _preshowView.textParser = self.ubbParser;
    }
    return _preshowView;
}

- (ASByrAttachment*)attachmentApi {
    if (_attachmentApi == nil) {
        _attachmentApi = [[ASByrAttachment alloc] initWithAccessToken:[ASByrToken shareInstance].accessToken];
    }
    return _attachmentApi;
}

- (ASByrArticle*)articleApi {
    if (_articleApi == nil) {
        _articleApi = [[ASByrArticle alloc] initWithAccessToken:[ASByrToken shareInstance].accessToken];
    }
    return _articleApi;
}

- (XQByrAttachment*)attachment {
    if (_attachment == nil) {
        _attachment = [XQByrAttachment new];
    }
    return _attachment;
}

- (ASUbbParser*)ubbParser {
    if (_ubbParser == nil) {
        _ubbParser = [[ASUbbParser alloc] init];
    }
    return _ubbParser;
}
@end
