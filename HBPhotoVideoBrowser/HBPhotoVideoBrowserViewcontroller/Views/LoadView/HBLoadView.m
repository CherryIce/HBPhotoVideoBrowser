//
//  HBLoadView.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 14/10/2020.
//

#import "HBLoadView.h"

@interface HBLoadView()

@property (nonatomic , strong) CAShapeLayer * loadingLayer;

@end

@implementation HBLoadView

- (CAShapeLayer *)loadingLayer {
    if (!_loadingLayer) {
        _loadingLayer = CAShapeLayer.new;
        CGRect rect = self.bounds;
        _loadingLayer.frame = rect;
        _loadingLayer.position = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
        _loadingLayer.fillColor = UIColor.clearColor.CGColor;
        _loadingLayer.lineWidth = 2.5f;
        _loadingLayer.strokeColor = UIColor.whiteColor.CGColor;
        UIBezierPath * bezier = [UIBezierPath bezierPathWithOvalInRect:rect];
        _loadingLayer.path = bezier.CGPath;
        [self.layer addSublayer:_loadingLayer];
    }
    return _loadingLayer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 40, 40);
        [self setup];
    }
    return self;
}

//不想写单例
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, 40, 40)];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    self.loadingLayer.strokeStart = 0.0;
    self.loadingLayer.strokeEnd = 0.75;
    
    CABasicAnimation * basicAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAni.fromValue = 0;
    basicAni.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    basicAni.duration = 1.0;
    basicAni.repeatCount = MAXFLOAT;
    basicAni.autoreverses = false;
    basicAni.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:basicAni forKey:nil];
}

- (void) showInView:(UIView *) superView {
    if (!superView) {
        return;
    }
    self.center = superView.center;
    [UIView animateWithDuration:0.25 animations:^{
        [superView addSubview:self];
        [superView bringSubviewToFront:self];
    }];
}

- (void) dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        [self removeFromSuperview];
    }];
}

@end
