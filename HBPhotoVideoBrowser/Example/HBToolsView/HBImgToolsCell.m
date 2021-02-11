//
//  HBImgToolsCell.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 20/11/2020.
//

#import "HBImgToolsCell.h"

@interface HBImgToolsCell ()

@property (nonatomic , strong) UIImageView * imageView;

@end

@implementation HBImgToolsCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
    }
    return self;
}

- (void) setImage:(UIImage *) img {
    self.imageView.image = img;
}

#pragma mark - getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}

@end
