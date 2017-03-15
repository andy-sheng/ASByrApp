//
//  ASEmotionInput.m
//  ASByrApp
//
//  Created by Andy on 2017/3/15.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "ASEmotionInput.h"
#import <YYImage.h>

@interface ASEmotionCell ()

@property (nonatomic, strong) YYAnimatedImageView *imgView;
@end

@implementation ASEmotionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self != nil) {
        [self addSubview:self.imgView];
        
    }
    return self;
}

- (void)setEmotion:(NSString *)imgName {
    [self.imgView setImage:[YYImage imageNamed:imgName]];
}

- (YYAnimatedImageView*)imgView {
    if (_imgView == nil) {
        _imgView = [[YYAnimatedImageView alloc] initWithFrame:self.bounds];
    }
    return _imgView;
}

@end


const NSInteger kASEmotionCellPerRow = 7;
const NSInteger kASEmotionCellPerCol = 3;
const NSInteger kClassic = 0;
const NSInteger kYouxihou = 1;
const NSInteger kTusiji = 2;
const NSInteger kYangcongtou = 3;

@interface ASEmotionInput () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *classic;
@property (weak, nonatomic) IBOutlet UIButton *youxihou;
@property (weak, nonatomic) IBOutlet UIButton *tusiji;
@property (weak, nonatomic) IBOutlet UIButton *yangcongtou;
@property (nonatomic, strong) NSArray *emotionConfig;
@property (nonatomic, assign) NSInteger selectedSection;

@end

@implementation ASEmotionInput

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.collectionView registerClass:[ASEmotionCell class] forCellWithReuseIdentifier:@"ASEmotionCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.classic addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.youxihou addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.tusiji addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.yangcongtou addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    
    [self action:self.classic];
}

- (void)action:(id)sender {
    if (sender == self.classic) {
        self.selectedSection = kClassic;
    } else if (sender == self.youxihou) {
        self.selectedSection = kYouxihou;
    } else if (sender == self.tusiji) {
        self.selectedSection = kTusiji;
    } else if (sender == self.yangcongtou) {
        self.selectedSection = kYangcongtou;
    }
    UIColor *backgroundColor = [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1.00];
    self.classic.backgroundColor = backgroundColor;
    [self.classic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.youxihou.backgroundColor = backgroundColor;
    [self.youxihou setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.tusiji.backgroundColor = backgroundColor;
    [self.tusiji setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.yangcongtou.backgroundColor = backgroundColor;
    [self.yangcongtou setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btn = sender;
    [btn setTitleColor:backgroundColor forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView reloadData];
}

# pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.addEmotionBlock) {
        self.addEmotionBlock([NSString stringWithFormat:@"[%@%ld]", self.emotionConfig[self.selectedSection][@"prefix"], indexPath.item + 1]);
    }
}

# pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.emotionConfig[self.selectedSection][@"count"] integerValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASEmotionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ASEmotionCell" forIndexPath:indexPath];
    [cell setEmotion:[NSString stringWithFormat:@"%@%ld", self.emotionConfig[self.selectedSection][@"prefix"], indexPath.row + 1]];
    return cell;
}

- (NSArray*)emotionConfig {
    if (_emotionConfig == nil) {
        _emotionConfig = @[@{@"count":@73, @"prefix":@"em"},@{@"count":@41,@"prefix":@"ema"},@{@"count":@24,@"prefix":@"emb"},@{@"count":@58,@"prefix":@"emc"}];
    }
    return _emotionConfig;
}

@end
