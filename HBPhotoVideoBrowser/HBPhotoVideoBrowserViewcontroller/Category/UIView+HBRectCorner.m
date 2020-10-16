//
//  UIView+HBRectCorner.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 14/10/2020.
//

#import "UIView+HBRectCorner.h"

@implementation UIView (HBRectCorner)

- (void) setCornerRadius:(CGFloat) cornerRadius HBRectCorner:(HBRectCorner)rectCorner {
    UIRectCorner rectcors = (UIRectCorner)rectCorner;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectcors cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
