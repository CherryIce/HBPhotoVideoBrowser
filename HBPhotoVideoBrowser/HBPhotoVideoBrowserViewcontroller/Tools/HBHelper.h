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

/**
 */
+ (UIImage *) snapshotView:(UIView *) view ;

/**
 */
+ (CGSize) scaleAspectFitImageViewWithImage:(UIImage *) image;

/**
 */
+ (UIColor*)colorWithRGB:(NSUInteger)hex
                   alpha:(CGFloat)alpha;

/**
 */
+ (UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity;

/**
 */
+ (NSString *)getBytesFromDataLength:(long)dataLength ;

/**
 */
+ (CGFloat) hbToolsHeight;

/**
 */
+ (CGFloat) hbSafeBottom;

@end

NS_ASSUME_NONNULL_END
