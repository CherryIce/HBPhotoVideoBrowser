//
//  UICollectionViewCell+HBAnimation.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 31/12/2020.
//

#import "UICollectionViewCell+HBAnimation.h"
#import <objc/runtime.h>
#import "HBLoadView.h"

@interface UICollectionViewCell()

@property (nonatomic , strong) HBLoadView * loading;

@end

@implementation UICollectionViewCell (HBAnimation)

static void * loadingViewKey = &loadingViewKey;

- (HBLoadView *)loading {
    return objc_getAssociatedObject(self, &loadingViewKey);
}

- (void)setLoading:(HBLoadView *)loading {
    objc_setAssociatedObject(self, &loadingViewKey, loading, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) startAnimation {
    if (self.loading) {
        [self.loading dismiss];
    }
    self.loading = [[HBLoadView alloc] init];
    self.loading.center = self.center;
    [self addSubview:self.loading];
    [self bringSubviewToFront:self.loading];
    [self.loading show];
}

- (void) stopAnimation {
    if (self.loading) {
        [self.loading dismiss];
    }
}

@end
