//
//  HBToolsView.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 20/11/2020.
//

#import "HBToolsView.h"

#import "HBImgToolsCell.h"
#import "HBHelper.h"

@interface HBToolsView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , strong) UICollectionView * collectionView;

@property (nonatomic , strong) UIButton * orignalBtn;

@end

@implementation HBToolsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self addSubview:self.orignalBtn];
    }
    return self;
}

#pragma mark - public
- (void) show {
    //interrupt last hide
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
        self.hidden = NO;
        //hidden after show 3s
        [self performSelector:@selector(hide) withObject:nil afterDelay:3.f];
    }];
}

- (void) hide {
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void) cancelAutoHide {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
        self.hidden = NO;
    }];
}

#pragma mark - setter
- (void)setIsNeedAutoHide:(BOOL)isNeedAutoHide {
    _isNeedAutoHide = isNeedAutoHide;
    if (isNeedAutoHide) {
        [self performSelector:@selector(hide) withObject:nil afterDelay:3.f];
    }else{
        [self cancelAutoHide];
    }
}

- (void)setImgDataArray:(NSArray<UIImage *> *)imgDataArray {
    _imgDataArray = imgDataArray;
    [self.collectionView reloadData];
}

//显示查看原图按钮
- (void)setCurrItem:(HBDataItem *)currItem {
    _currItem = currItem;
    //原图没缓存 有大小 才显示 查看原图
    if (currItem.orignalSize > 0 && currItem.dataType == HBDataTypeIMAGE && !currItem.orignalImage) {
        self.orignalBtn.hidden = NO;
        [self.orignalBtn setTitle:[NSString stringWithFormat:@"%@(%@)",@"查看原图",[HBHelper getBytesFromDataLength:currItem.orignalSize]] forState:UIControlStateNormal];
    }else{
        self.orignalBtn.hidden = YES;
    }
}

- (void)setProgressValue:(CGFloat)progressValue {
    _progressValue = progressValue;
    [self.orignalBtn setTitle:[NSString stringWithFormat:@"%.2f%@",progressValue*100,@"%"] forState:UIControlStateNormal];
}

- (void)setIsDownLoadFinish:(BOOL)isDownLoadFinish {
    _isDownLoadFinish = isDownLoadFinish;
    if (isDownLoadFinish) {
        [self.orignalBtn setTitle:@"已完成" forState:UIControlStateNormal];
        self.orignalBtn.hidden = YES;
    }else{
        self.orignalBtn.hidden = NO;
        [self.orignalBtn setTitle:[NSString stringWithFormat:@"%@(%@)",@"查看原图",[HBHelper getBytesFromDataLength:_currItem.orignalSize]] forState:UIControlStateNormal];
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HBImgToolsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HBImgToolsCell class]) forIndexPath:indexPath];
    [cell setImage:self.imgDataArray[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
    return CGSizeMake(25,25);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hbImageToolsSubViewsClickEvent:)]) {
        [self.delegate hbImageToolsSubViewsClickEvent:indexPath.item];
    }
}

#pragma mark -event
- (void) buttonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickEventForDownloadOrignalImage)]) {
        [self.delegate clickEventForDownloadOrignalImage];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.orignalBtn.frame = CGRectMake(20, 10, 120, CGRectGetHeight(self.bounds) - 2 * 10);
    
    self.collectionView.frame = CGRectMake(CGRectGetMaxX(self.orignalBtn.frame) + 20,
                                           5,
                                           CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.orignalBtn.frame) - 2 * 20,
                                           CGRectGetHeight(self.bounds) - 10);
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10.f;
        flowLayout.minimumInteritemSpacing = 0.1f;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [_collectionView registerClass:[HBImgToolsCell class] forCellWithReuseIdentifier:NSStringFromClass([HBImgToolsCell class])];
    }
    return _collectionView;
}

- (UIButton *)orignalBtn {
    if (!_orignalBtn) {
        _orignalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _orignalBtn.frame = CGRectZero;
        [_orignalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_orignalBtn setBackgroundColor:[HBHelper colorWithRGB:0x707070 alpha:0.6]];
        _orignalBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _orignalBtn.layer.cornerRadius = 2;
        _orignalBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_orignalBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        _orignalBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _orignalBtn.hidden = YES;//默认不显示
    }
    return _orignalBtn;
}


@end
