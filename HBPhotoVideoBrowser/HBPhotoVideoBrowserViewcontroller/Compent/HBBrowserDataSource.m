//
//  HBBrowserDataSource.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 12/10/2020.
//

#import "HBBrowserDataSource.h"

@interface HBBrowserDataSource()

@property (nonatomic , strong) NSMutableSet * reuseSet;

@end

@implementation HBBrowserDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        _reuseSet = [NSMutableSet set];
    }
    return self;
}

- (NSString *)reuseIdentifierForCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView{
    NSString *identifier = NSStringFromClass(cellClass);
    if (!identifier) {
        NSLog(@"cell or nib not existed");
        identifier = @"ttidentifier";
    }
    if (![_reuseSet containsObject:identifier]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:identifier ofType:@"nib"];
        if (path) {
            [collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
        } else {
            [collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
        }
        [_reuseSet addObject:identifier];
    }
    return identifier;
}

#pragma mark - <UIScrollViewDelegate>
//UICollection移动时禁止cell上的所有手势
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView * collectV = (UICollectionView *)scrollView;
        [collectV.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (UIGestureRecognizer * ges  in obj.gestureRecognizers) {
                ges.state = UIGestureRecognizerStateFailed;
            }
        }];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(forbiddenToolsWhileScrolling)]) {
        [self.delegate forbiddenToolsWhileScrolling];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止类型1、停止类型2
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self scrollViewDidEndScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        // 停止类型3
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            [self scrollViewDidEndScroll:scrollView];
        }
    }
}

#pragma mark - 滚动停止了
- (void)scrollViewDidEndScroll:(UIScrollView *)scrollView {
    CGFloat index = roundf(scrollView.contentOffset.x / scrollView.bounds.size.width);
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewDidEndScrollToIndex:)]) {
        [self.delegate collectionViewDidEndScrollToIndex:index];
    }
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HBDataItem * item = self.dataSourceArray[indexPath.item];
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self reuseIdentifierForCellClass:item.cellClass collectionView:collectionView] forIndexPath:indexPath];
    [(id<HBCellDataDelegate>)cell setData:item delegate:self];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionViewLayout.collectionView.bounds.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

/*
 */
- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(id<HBCellDataDelegate>)cell adjustUI];
}

#pragma mark - <HBCellEventDelegate>
- (void) pan_hideBrowser:(CGRect)dimissRect {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideBrowser:)]) {
        [self.delegate hideBrowser:dimissRect];
    }
}
- (void)longProgressGestureCallBack {
    if (self.delegate && [self.delegate respondsToSelector:@selector(browserLpGesture)]) {
        [self.delegate browserLpGesture];
    }
}

- (void)gestureToolsViewShouldHide:(BOOL)hide {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideToolsWhileGestures:)]) {
        [self.delegate hideToolsWhileGestures:hide];
    }
}

- (void)loadOrignalImageProgress:(CGFloat)progressValue {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orignalImageDownLoadProgress:)]) {
        [self.delegate orignalImageDownLoadProgress:progressValue];
    }
}

- (void)loadOrignalImageIsScucess:(BOOL)sucess {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orignalImageDownLoadSucess:)]) {
        [self.delegate orignalImageDownLoadSucess:sucess];
    }
}

@end
