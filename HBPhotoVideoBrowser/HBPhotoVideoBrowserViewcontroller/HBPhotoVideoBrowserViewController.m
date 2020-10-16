//
//  HBPhotoVideoBrowserViewController.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 09/10/2020.
//

#import "HBPhotoVideoBrowserViewController.h"

#import "HBCollectionView.h"
#import "HBBrowserDataSource.h"

@interface HBPhotoVideoBrowserViewController ()<HBBrowserDataSourceDelegate>

@property (nonatomic , strong) HBCollectionView * cv;

@property (nonatomic , strong) HBBrowserDataSource * dataSource;

@end

@implementation HBPhotoVideoBrowserViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _isAllowLpGesture = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
}

/**
 等待动画完成后
 */
- (void) prepareLoad {
    if (!self.isViewLoaded) {
        return;
    }
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
    if (@available(iOS 14.0, *)) {
        UICollectionViewLayoutAttributes * attributes = [self.cv layoutAttributesForItemAtIndexPath:scrollIndexPath];
        [self.cv setContentOffset:CGPointMake(attributes.frame.origin.x, attributes.frame.origin.y) animated:NO];
    }else{
        [self.cv scrollToItemAtIndexPath:scrollIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.cv.hidden = NO;//显示动画所需
    }];
}

#pragma mark - <HBBrowserDataSourceDelegate>
//滚动中禁止工具栏操作
- (void) forbiddenToolsWhileScrolling {
    
}

//滚动到了哪一个index
- (void) collectionViewDidEndScrollToIndex:(NSInteger) index {
    //_isForbiddenHandle = NO;
    bool isScroll = _currentIndex != index;
    if (isScroll) {
        self.currentIndex = index;
        //[self changedStatedToImageToolsAtIndex:index];
    }
    [self adjustFromCtl];
}

//退出图片视频浏览
- (void) hideBrowser:(CGRect)dimissRect {
    UICollectionViewCell * currentCell = self.cv.centerCell;
    HBBaseCollectionViewCell * cell = (HBBaseCollectionViewCell *)currentCell;
    self.dissMissRect = dimissRect;
    HBDataItem * item = self.dataSourceArray[cell.currentIndex];
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        //不需要传 横屏执行渐隐动画就行了 想花里胡哨的可以再加一个新动画
    }else{
        self.dismissView = item.translationView;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideBrowserControllerAtIndex:item:)]) {
        [self.delegate hideBrowserControllerAtIndex:cell.currentIndex item:item];
    }
    [self dismissHBViewControllerAnimated:YES completion:nil];
    [UIView animateWithDuration:0.1 animations:^{
        cell.hidden = item.translationView ? YES : NO;
    }];
}

//长按手势
- (void) browserLpGesture {
    
}

//手势时隐藏工具栏
- (void) hideToolsWhileGestures:(BOOL)hide {
    
}

//原图下载进度
- (void) orignalImageDownLoadProgress:(CGFloat)progressValue {
    
}

//原图是否下载成功
- (void) orignalImageDownLoadSucess:(BOOL)sucess {
    
}

//适配上一页面视图
- (void) adjustFromCtl {
    for (HBDataItem * item in self.dataSourceArray) {
        item.translationView.hidden = item == [self currentDataItem];
    }
}

#pragma mark - update size
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    self.browserToolsView.frame = CGRectMake(0, self.view.bounds.size.height - [CCHelper imageToolsHeight] - [CCHelper safeAreaInsets], self.view.bounds.size.width, [CCHelper imageToolsHeight]);
//    self.browserTopView.frame = CGRectMake(0, [CCHelper safeAreaInsets] + [CCHelper topToolsInsets], self.view.bounds.size.width, [CCHelper imageToolsHeight]);
}

#pragma mark - readonly
- (HBDataItem *)currentDataItem {
    return self.dataSourceArray[_currentIndex];
}

#pragma mark - setter
- (void)setCurrentIndex:(NSUInteger)currentIndex {
    _currentIndex = currentIndex;
    NSInteger maxIndex = self.dataSourceArray.count - 1;
    if (_currentIndex > maxIndex) {
        _currentIndex = maxIndex;
    }
}

- (void)setIsAllowLpGesture:(BOOL)isAllowLpGesture {
    _isAllowLpGesture = isAllowLpGesture;
}

#pragma mark - getter
- (HBCollectionView *)cv {
    if (!_cv) {
        _cv = [[HBCollectionView alloc] initWithFrame:CGRectMake(-10, 0, [UIScreen mainScreen].bounds.size.width + 20, [UIScreen mainScreen].bounds.size.height)];
        _cv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _cv.dataSource = self.dataSource;
        _cv.delegate = self.dataSource;
        _cv.hidden = YES;//显示动画所需
        [self.view addSubview:_cv];
    }
    return _cv;
}

- (HBBrowserDataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [[HBBrowserDataSource alloc] init];
        _dataSource.dataSourceArray = self.dataSourceArray;
        _dataSource.delegate = self;
    }
    return _dataSource;
}

@end