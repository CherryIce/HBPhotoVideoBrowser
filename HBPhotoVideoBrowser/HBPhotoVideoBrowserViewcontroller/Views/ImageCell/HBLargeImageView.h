//
//  HBLargeImageVIew.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 2023/3/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBLargeImageView : UIView

- (void)hb_setImageWithUrl:(NSURL *)url;

- (void)hb_setImage:(UIImage *)image;

// tiledCount 表示需要放大多少遍才能达到原始图片尺寸 default 81 = 9 * 9
- (void)hb_setImageWithUrl:(NSURL *)url tiledCount:(int)tiledCount ;

- (void)hb_setImage:(UIImage *)imageName tiledCount:(int)tiledCount ;

@end

NS_ASSUME_NONNULL_END
