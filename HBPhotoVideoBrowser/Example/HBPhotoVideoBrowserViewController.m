//
//  HBPhotoVideoBrowserViewController.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 09/10/2020.
//

#import "HBPhotoVideoBrowserViewController.h"
#import "HBHelper.h"
#import "HBCollectionView.h"
#import "HBBrowserDataSource.h"

@interface HBPhotoVideoBrowserViewController ()<HBBrowserDataSourceDelegate,HBToolsViewDelegate>

//卡片视图
@property (nonatomic , strong) HBCollectionView * collectView;

//数据代理操作
@property (nonatomic , strong) HBBrowserDataSource * dataSource;

//当前是否禁止操作
@property (nonatomic , assign) BOOL isForbiddenHandle;

@end

@implementation HBPhotoVideoBrowserViewController

@synthesize currentIndex;

@synthesize dataSourceArray;

@synthesize dismissView;

@synthesize dissMissRect;

@synthesize presentingView;

- (instancetype)init {
    self = [super init];
    if (self) {
        _isAllowLpGesture = NO;
        _isForbiddenHandle = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //横竖屏切换监听
    [self addObservers];
}

/**
 等待动画完成后
 */
- (void) prepareLoad {
    if (!self.isViewLoaded) {
        return;
    }
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    if (@available(iOS 14.0, *)) {
        UICollectionViewLayoutAttributes * attributes = [self.collectView layoutAttributesForItemAtIndexPath:scrollIndexPath];
        [self.collectView setContentOffset:CGPointMake(attributes.frame.origin.x, attributes.frame.origin.y) animated:NO];
    }else{
        [self.collectView scrollToItemAtIndexPath:scrollIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.collectView.hidden = NO;//显示动画所需
    }];
    [self updateToolsSize];
}

#pragma mark - observer
- (void) addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangedStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillChangedStatusBarOrientationNotification:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}

- (void)applicationWillChangedStatusBarOrientationNotification:(NSNotification *) noti {
    //之前的布局失效
//    [self.collectView safeLayoutInvalidateLayout];
}

- (void)applicationDidChangedStatusBarOrientationNotification:(NSNotification *) noti {
    //之前的布局失效
    [self.collectView safeLayoutInvalidateLayout];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    //这种方案总感觉不太行的样子 - -！
    [UIView animateWithDuration:0.2 animations:^{
        [self.collectView performBatchUpdates:^{
            if (@available(iOS 14.0, *)) {
                UICollectionViewLayoutAttributes * attributes = [self.collectView layoutAttributesForItemAtIndexPath:indexPath];
                [self.collectView setContentOffset:CGPointMake(attributes.frame.origin.x, attributes.frame.origin.y) animated:NO];
            }else{
                [self.collectView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            }
      } completion:nil];
    }];
}

#pragma mark - <HBBrowserDataSourceDelegate>
//滚动中禁止工具栏操作
- (void) forbiddenToolsWhileScrolling {
    _isForbiddenHandle = YES;
}

//滚动到了哪一个index
- (void) collectionViewDidEndScrollToIndex:(NSInteger) index {
    _isForbiddenHandle = NO;
    bool isScroll = self.currentIndex != index;
    if (isScroll) {
        self.currentIndex = index;
    }
    [self adjustFromCtl];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UICollectionViewCell * cell = [self.collectView cellForItemAtIndexPath:indexPath];
    [(id<HBCellDataDelegate>)cell adjustUI];
    [self.browserToolsView show];
}

//退出图片视频浏览
- (void) hideBrowser:(CGRect)dimissRect {
    UICollectionViewCell * currentCell = self.collectView.centerCell;
    self.dissMissRect = dimissRect;
    HBDataItem * item = self.dataSourceArray[self.currentIndex];
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        //不需要传 横屏执行渐隐动画就行了 想花里胡哨的可以再加一个新动画
    }else{
        self.dismissView = item.translationView;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideBrowserControllerAtIndex:item:)]) {
        [self.delegate hideBrowserControllerAtIndex:self.currentIndex item:item];
    }
    [self dismissHBViewControllerAnimated:YES completion:nil];
    [UIView animateWithDuration:0.1 animations:^{
        currentCell.hidden = item.translationView ? YES : NO;
    }];
}

//长按手势
- (void) browserLpGesture {
    
}

//手势时隐藏工具栏
- (void) hideToolsWhileGestures:(BOOL)hide {
    if (hide) {
        if (!self.browserToolsView.hidden) {
            [self.browserToolsView hide];
        }
    }else{
        if (self.browserToolsView.hidden) {
            [self.browserToolsView show];
        }
    }
}

//原图下载进度
- (void) orignalImageDownLoadProgress:(CGFloat)progressValue {
    self.browserToolsView.progressValue = progressValue;
}

//原图是否下载成功
- (void) orignalImageDownLoadSucess:(BOOL)sucess {
    self.browserToolsView.isDownLoadFinish = sucess;
}

- (void)clickEventForDownloadOrignalImage {
    if (!_isForbiddenHandle) {
        UICollectionViewCell * currentCell = self.collectView.centerCell;
        [(id<HBCellDataDelegate>)currentCell loadOrignalImage];
    }
}

//工具栏点击事件
- (void)hbImageToolsSubViewsClickEvent:(NSInteger)itemIndex {
    
}

//适配上一页面视图
- (void) adjustFromCtl {
    for (HBDataItem * item in self.dataSourceArray) {
        item.translationView.hidden = item == [self currentDataItem];
    }
}

#pragma mark - update size
- (void) updateToolsSize {
    NSInteger safeBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeBottom = self.view.safeAreaInsets.bottom;
    }
    self.browserToolsView.frame = CGRectMake(0,
                                             CGRectGetHeight(self.view.bounds) - [HBHelper hbToolsHeight] - [HBHelper hbSafeBottom] - safeBottom,
                                             self.view.bounds.size.width,
                                             [HBHelper hbToolsHeight]);
    if (![self.view.subviews.lastObject isEqual:[self.browserToolsView class]]) {
        [UIView animateWithDuration:0.25 animations:^{
            [self.view bringSubviewToFront:self.browserToolsView];
        }];
    }
}

#pragma mark - readonly
- (HBDataItem *)currentDataItem {
    return self.dataSourceArray[self.currentIndex];
}

#pragma mark - setter
//- (void)setCurrentIndex:(NSUInteger)currentIndex {
//    _currentIndex = currentIndex;
//    NSInteger maxIndex = self.dataSourceArray.count - 1;
//    if (_currentIndex > maxIndex) {
//        _currentIndex = maxIndex;
//    }
//}

- (void)setIsAllowLpGesture:(BOOL)isAllowLpGesture {
    _isAllowLpGesture = isAllowLpGesture;
}

#pragma mark - getter
- (HBCollectionView *)collectView {
    if (!_collectView) {
        _collectView = [[HBCollectionView alloc] initWithFrame:CGRectMake(-10, 0, [UIScreen mainScreen].bounds.size.width + 20, [UIScreen mainScreen].bounds.size.height)];
        _collectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectView.dataSource = self.dataSource;
        _collectView.delegate = self.dataSource;
        _collectView.hidden = YES;//显示动画所需
        [self.view addSubview:_collectView];
    }
    return _collectView;
}

- (HBBrowserDataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [[HBBrowserDataSource alloc] init];
        _dataSource.dataSourceArray = self.dataSourceArray;
        _dataSource.delegate = self;
    }
    return _dataSource;
}

- (HBToolsView *)browserToolsView {
    if (!_browserToolsView) {
        _browserToolsView = [[HBToolsView alloc] initWithFrame:CGRectZero];
        _browserToolsView.delegate = self;
        _browserToolsView.isNeedAutoHide = YES;
        _browserToolsView.imgDataArray = @[[UIImage imageNamed:@"download"],[UIImage imageNamed:@"menu"],[UIImage imageNamed:@"more"]];
        [self.view addSubview:_browserToolsView];
    }
    return _browserToolsView;
}

@end
