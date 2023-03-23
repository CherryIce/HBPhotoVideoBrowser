//
//  HBScrollView.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 14/10/2020.
//

#import "HBScrollView.h"

@implementation HBScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.alwaysBounceHorizontal = NO;
        self.alwaysBounceVertical = NO;
        self.layer.masksToBounds = YES;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:self.imageView];
        [self addSubview:self.largeImageView];
    }
    return self;
}

#pragma mark - getter
- (HBImageView *)imageView {
    if (!_imageView) {
        _imageView = [[HBImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (HBLargeImageView *)largeImageView {
    if(!_largeImageView) {
        _largeImageView = [[HBLargeImageView alloc] init]; 
        _largeImageView.backgroundColor = [UIColor redColor];
    }
    return _largeImageView;
}

@end
