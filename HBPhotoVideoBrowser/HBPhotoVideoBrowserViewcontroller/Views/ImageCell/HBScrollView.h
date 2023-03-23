//
//  HBScrollView.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 14/10/2020.
//

#import <UIKit/UIKit.h>

#import "HBImageView.h"
#import "HBLargeImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBScrollView : UIScrollView

@property (nonatomic , strong) HBImageView * imageView;

@property (nonatomic , strong) HBLargeImageView * largeImageView;

@end

NS_ASSUME_NONNULL_END
