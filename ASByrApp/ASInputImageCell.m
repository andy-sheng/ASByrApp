//
//  ASInputImageCell.m
//  ASByrApp
//
//  Created by Andy on 2017/3/8.
//  Copyright © 2017年 andy. All rights reserved.
//

#import "ASInputImageCell.h"
#import <Masonry/Masonry.h>

static NSString * const kImagesChangeNotification = @"imagesChangeNotification";
static NSString * const kImageCellReuseId = @"imagecell";

@interface ASImageCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation ASImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        NSLog(@"init asimagecell");
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_topMargin);
            make.right.equalTo(self.contentView.mas_rightMargin);
            make.bottom.equalTo(self.contentView.mas_bottomMargin);
            make.left.equalTo(self.contentView.mas_leftMargin);
        }];
        [self setNeedsLayout];
    }
    return self;
}

- (UIImageView*)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fire"]];
    }
    return _imageView;
}
@end

@interface ASInputImageCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ASInputImageCell

- (instancetype)init {
    self = [self initWithImages:[NSMutableArray array]];
    return self;
}

- (instancetype)initWithImages:(NSArray*)images {
    self = [super init];
    if (self != nil) {
        [self.contentView addSubview:self.collectionView];
        [self setNeedsLayout];
        self.images = images;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImages) name:kImagesChangeNotification object:nil];
    }
    return self;
}

- (void)updateConstraints {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_rightMargin);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_leftMargin);
    }];
    [super updateConstraints];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;//[self.images count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:kImageCellReuseId forIndexPath:indexPath];
}

# pragma mark - Getters and Setters
- (UICollectionView*)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(100, 100);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, XQSCREEN_W, 0.) collectionViewLayout:layout];

        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ASImageCell class] forCellWithReuseIdentifier:kImageCellReuseId];
        [_collectionView layoutIfNeeded];
        
    }
    return _collectionView;
}

@end
