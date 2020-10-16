//
//  UIView+HBRectCorner.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 14/10/2020.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, HBRectCorner) {
    /**单个角度**/
    HBRectCornerTopLeft = UIRectCornerTopLeft,//上左
    HBRectCornerTopRight = UIRectCornerTopRight,//上右
    HBRectCornerBottomLeft = UIRectCornerBottomLeft,//下左
    HBRectCornerBottomRight = UIRectCornerBottomRight,//下右
    /**两个角度*/
    HBRectCornerLeft = HBRectCornerTopLeft | HBRectCornerBottomLeft,//左
    HBRectCornerTop = HBRectCornerTopLeft | HBRectCornerTopRight,//上
    HBRectCornerBottom = HBRectCornerBottomLeft | HBRectCornerBottomRight,//下
    HBRectCornerRight = HBRectCornerTopRight | HBRectCornerBottomRight,//右
    /**三个角度*/
    HBRectCornerNoneBottomRight = HBRectCornerTopLeft | HBRectCornerTopRight | HBRectCornerBottomLeft,//左2右上1
    HBRectCornerNoneTopLeft = HBRectCornerBottomRight | HBRectCornerTopRight | HBRectCornerBottomLeft,//左下1右2
    HBRectCornerNoneBottomLeft = HBRectCornerTopLeft | HBRectCornerTopRight | HBRectCornerBottomRight,//左上1右2
    HBRectCornerNoneTopRight = HBRectCornerTopLeft | HBRectCornerBottomRight | HBRectCornerBottomLeft,//左2右下1
    /**四个角度*/
    HBRectCornerAllCorners = UIRectCornerAllCorners,//全部
};

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HBRectCorner)

- (void) setCornerRadius:(CGFloat) cornerRadius HBRectCorner:(HBRectCorner)rectCorner;

@end

NS_ASSUME_NONNULL_END
