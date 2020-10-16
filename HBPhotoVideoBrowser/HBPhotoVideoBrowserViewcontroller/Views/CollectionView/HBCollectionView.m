//
//  HBCollectionView.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 14/10/2020.
//

#import "HBCollectionView.h"

#import "HBFlowLayout.h"

@interface HBCollectionView()

@property (nonatomic , strong) HBFlowLayout * flowLayout;

@end

@implementation HBCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    HBFlowLayout * layout = [[HBFlowLayout alloc] init];
    self.flowLayout = layout;
    return [self initWithFrame:frame collectionViewLayout:layout];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.alwaysBounceVertical = NO;
        self.alwaysBounceHorizontal = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

- (UICollectionViewCell *)centerCell {
    NSArray<UICollectionViewCell *> *cells = [self visibleCells];
    if (cells.count == 0) return nil;
    
    UICollectionViewCell *res = cells[0];
    CGFloat centerX = self.contentOffset.x + (self.bounds.size.width / 2.0);
    for (int i = 1; i < cells.count; ++i) {
        if (ABS(cells[i].center.x - centerX) < ABS(res.center.x - centerX)) {
            res = cells[i];
        }
    }
    return res;
}

- (void) safeLayoutInvalidateLayout {
    [self.flowLayout invalidateLayout];
}

@end
