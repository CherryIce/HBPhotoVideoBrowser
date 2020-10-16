//
//  HBImageView.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 14/10/2020.
//

#import "HBImageView.h"
#import <SDWebImage.h>

@implementation HBImageView

- (void) loadImageWithURL:(NSURL *) imageURL
         placeholderImage:(nullable UIImage *)placeholder
                 progress:(void (^) (CGFloat progress))progressBlock
                completed:(void (^) (bool isSucess ,UIImage * image))completedBlock {
     [self sd_setImageWithURL:imageURL
               placeholderImage:placeholder
                        options:SDWebImageRetryFailed
                       progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
           progressBlock(receivedSize/expectedSize);
       }
                      completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
           completedBlock(!error,image);
    }];
}

@end
