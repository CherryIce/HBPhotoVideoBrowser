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

/**
 
 */
+ (UIColor*)colorWithRGB:(NSUInteger)hex
                  alpha:(CGFloat)alpha {
    float r, g, b, a;
    a = alpha;
    b = hex & 0x0000FF;
    hex = hex >> 8;
    g = hex & 0x0000FF;
    hex = hex >> 8;
    r = hex;

    return [UIColor colorWithRed:r/255.0f
                           green:g/255.0f
                           blue:b/255.0f
                           alpha:a];
}

/**
 16进制颜色转换为UIColor
 @param hexColor 16进制字符串（可以以0x开头，可以以#开头，也可以就是6位的16进制）
 @param opacity 透明度
 @return 16进制字符串对应的颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity {
    NSString * cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];

    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];

    if ([cString length] != 6) return [UIColor blackColor];

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rString = [cString substringWithRange:range];

    range.location = 2;
    NSString * gString = [cString substringWithRange:range];

    range.location = 4;
    NSString * bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:opacity];
}

/**
 */
+ (NSString *)getBytesFromDataLength:(long)dataLength {
    NSString *bytes;
    if (dataLength >= 1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%.1fM",dataLength/1024/1024.0];
    } else if (dataLength >= 1024 && dataLength < (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%ldB",dataLength];
    }
    return bytes;
}

/**
 */
+ (BOOL) isPhoneX {
    BOOL isPhoneX = NO;
    CGSize size = [UIScreen mainScreen].bounds.size;
    NSInteger notchValue = size.width / size.height * 100;
    if (216 == notchValue || 46 == notchValue) {
        isPhoneX = YES;
    }
    return isPhoneX;
}

/**
 */
+ (CGFloat) hbToolsHeight {
    return 40;
}

/**
 */
+ (CGFloat) hbSafeBottom {
    return 20;
}

@end
