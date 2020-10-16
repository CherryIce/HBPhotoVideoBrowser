//
//  HBHelper.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 14/10/2020.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ImageType) {
    ImageNormal,
    ImageLonglong,
    ImagePanoramic,
};

@interface HBHelper : NSObject

+ (UIImage *) snapshotView:(UIView *) view ;

+ (CGSize) scaleAspectFitImageViewWithImage:(UIImage *) image;

@end

NS_ASSUME_NONNULL_END
