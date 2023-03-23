//
//  HBExampleCell.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 12/10/2020.
//

#import "HBExampleCell.h"

#import <SDWebImage.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

@implementation HBExampleCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor brownColor];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.largeImageView];
    }
    return self;
}

- (void) refreshCell:(HBDataItem *) data {
    [self.imageView setHidden:data.isLargeImage];
    [self.largeImageView setHidden:!data.isLargeImage];
    if (data.dataType == HBDataTypeIMAGE) {
        if (data.image) {
            if (data.isLargeImage) {
                [self.largeImageView hb_setImage:data.image tiledCount:16];
            }else{
                [self.imageView setImage:data.image];
            }
        }else{
            NSURL * url = data.thumbnailURL ? data.thumbnailURL : data.dataURL;
            if (data.isLargeImage) {
                [self.largeImageView hb_setImageWithUrl:url];
            }else{
                [self.imageView sd_setImageWithURL:url placeholderImage:nil options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

                }];
            }
        }
    }else{
        self.imageView.image = [self getVideoPreViewImage:data.dataURL];
    }
}

// 获取视频第一帧  这里是耗时操作 建议缓存
- (UIImage*) getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

#pragma mark - getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

//要实现UIImageView那种图片适配模式 需要提前计算图片的宽高比来创建largeImageView
- (HBLargeImageView *)largeImageView {
    if(!_largeImageView) {
        _largeImageView = [[HBLargeImageView alloc] initWithFrame:self.bounds];
    }
    return _largeImageView;
}

@end
