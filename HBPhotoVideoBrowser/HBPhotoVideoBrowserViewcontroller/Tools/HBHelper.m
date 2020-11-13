//
//  HBHelper.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 14/10/2020.
//

#import "HBHelper.h"

@implementation HBHelper

/**
 */
+ (UIImage *) snapshotView:(UIView *) view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 */
+ (CGSize) scaleAspectFitImageViewWithImage:(UIImage *) image {
    CGSize  imageSize = image.size;

    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;

    CGFloat w_rate = imageSize.width/w;
    CGFloat h_rate = imageSize.height/h;

    if (w_rate > h_rate) {
        imageSize.width = w ;
        imageSize.height /= w_rate;
    }

    if (w_rate < h_rate) {
        imageSize.width  /= h_rate;
        imageSize.height = h;
    }

    if (w_rate == h_rate) {
        imageSize.width = w;
        imageSize.height = h;
    }

    return imageSize;
}

@end
