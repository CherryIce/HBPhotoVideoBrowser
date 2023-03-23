//
//  HBLargeImageView.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 2023/3/23.
//

#import "HBLargeImageView.h"
#import <SDWebImage.h>

@interface HBLargeImageView(){
    long long tiledCount;
    UIImage *originImage;
    CGRect imageRect;
    CGFloat imageScale_w;
    CGFloat imageScale_h;
}

@end

@implementation HBLargeImageView

- (void)hb_setImageWithUrl:(NSURL *)url tiledCount:(int)tiledCount {
    tiledCount = tiledCount;
    [self hb_setImageWithUrl:url];
}

- (void)hb_setImage:(UIImage *)imageName tiledCount:(int)tiledCount {
    tiledCount = tiledCount;
    [self hb_setImage:imageName];
}

- (void)hb_setImageWithUrl:(NSURL *)url {
    [self hb_setLargeImageWithUrl:url completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (finished && !error && image) {
            [self hb_setImage:image];
        }
        else {
            //no image , use placeholder
        }
    }];
}


- (void)hb_setImage:(UIImage *)image {
    if (tiledCount == 0) tiledCount = 81;
    originImage = image;
//    [self setBackgroundColor:[UIColor lightGrayColor]];
    imageRect = CGRectMake(0.0f,
                           0.0f,
                           CGImageGetWidth(originImage.CGImage),
                           CGImageGetHeight(originImage.CGImage));
    imageScale_w = self.frame.size.width/imageRect.size.width;
    imageScale_h = self.frame.size.height/imageRect.size.height;
    CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
    
    int scale = (int)MAX(1/imageScale_w, 1/imageScale_h);
    
    int lev = ceil(scale);
    tiledLayer.levelsOfDetail = 1;
    tiledLayer.levelsOfDetailBias = lev;
    
    if(tiledCount > 0){
        NSInteger tileSizeScale = sqrt(tiledCount)/2;
        CGSize tileSize = self.bounds.size;
        tileSize.width /= tileSizeScale;
        tileSize.height /= tileSizeScale;
        tiledLayer.tileSize = tileSize;
    }
}

- (void)hb_setLargeImageWithUrl:(NSURL *)url completed:(SDWebImageDownloaderCompletedBlock)completedBlock {
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url
                                                          options:SDWebImageDownloaderAvoidDecodeImage | SDWebImageDownloaderScaleDownLargeImages | SDWebImageDownloaderHighPriority
                                                         progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        //下载进度查看
//        NSLog(@" receivedSize:%zd ,\n expectedSize:%zd",receivedSize,expectedSize);
    }
                                                        completed:completedBlock];
}

+ (Class)layerClass {
    return [CATiledLayer class];
}

- (void)drawRect:(CGRect)rect {
    @autoreleasepool{
        CGRect imageCutRect = CGRectMake(rect.origin.x / imageScale_w,
                                         rect.origin.y / imageScale_h,
                                         rect.size.width / imageScale_w,
                                         rect.size.height / imageScale_h);
        CGImageRef imageRef = CGImageCreateWithImageInRect(originImage.CGImage, imageCutRect);
        UIImage *tileImage = [UIImage imageWithCGImage:imageRef];
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(context);
        [tileImage drawInRect:rect];
        CGImageRelease(imageRef);
        UIGraphicsPopContext();
    }
}

@end
