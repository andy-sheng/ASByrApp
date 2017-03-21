//
//  ASEmotionInput.m
//  ASByrApp
//
//  Created by Andy on 2017/3/15.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "ASEmotionInput.h"
#import "YYImage.h"
#import "Masonry.h"

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

- (void)layoutSubviews {
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    [super layoutSubviews];
}
- (void)setEmotion:(NSString *)imgName {
    [self.imgView setImage:[YYImage imageNamed:imgName]];
}

- (YYAnimatedImageView*)imgView {
    if (_imgView == nil) {
        _imgView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
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

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
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
    
    [self.flowLayout setMinimumLineSpacing:0];
    [self.flowLayout setMinimumInteritemSpacing:0];
    CGFloat itemWidth = XQSCREEN_W / kASEmotionCellPerRow;
    
    self.flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    
    [self.classic addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.youxihou addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.tusiji addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.yangcongtou addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    
    [self action:self.classic];
}

- (void)action:(id)sender {
    float emotionCount;
    if (sender == self.classic) {
        emotionCount = [self.emotionConfig[kClassic][@"count"] floatValue];
        self.selectedSection = kClassic;
    } else if (sender == self.youxihou) {
        emotionCount = [self.emotionConfig[kYouxihou][@"count"] floatValue];
        self.selectedSection = kYouxihou;
    } else if (sender == self.tusiji) {
        emotionCount = [self.emotionConfig[kTusiji][@"count"] floatValue];
        self.selectedSection = kTusiji;
    } else if (sender == self.yangcongtou) {
        emotionCount = [self.emotionConfig[kYangcongtou][@"count"] floatValue];
        self.selectedSection = kYangcongtou;
    }
    NSLog(@"%lf", ceil(emotionCount / (kASEmotionCellPerCol * kASEmotionCellPerRow)));
    [self.pageControl setNumberOfPages:ceil(emotionCount / (kASEmotionCellPerCol * kASEmotionCellPerRow))];
    [self.pageControl setCurrentPage:0];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = ceil(scrollView.contentOffset.x / XQSCREEN_W);
    
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
