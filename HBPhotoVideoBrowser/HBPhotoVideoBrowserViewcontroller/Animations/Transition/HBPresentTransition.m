//
//  HBPresentTransition.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 14/10/2020.
//

#import "HBPresentTransition.h"
#import "HBHelper.h"
#import "HBPhotoVideoBrowserViewController.h"

@implementation HBPresentTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    self.transitionContext = transitionContext;
    
    HBPhotoVideoBrowserViewController *toViewController = (HBPhotoVideoBrowserViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIView * view = toViewController.presentingView;
    UIImage * transImg;
    if (!view) {
        HBDataItem * item = [toViewController currentDataItem];
        view = item.translationView;
        transImg = item.orignalImage ? item.orignalImage : item.smallImage;
    }

    self.presentingImageView = [[UIImageView alloc] initWithFrame:[containerView convertRect:view.frame fromView:view.superview]];
    if ([view isKindOfClass:[UIImageView class]]) {
        UIImageView * imageV = (UIImageView *)view;
        if (!transImg) {
            transImg = imageV.image;
            if (!transImg) {
               transImg = [HBHelper snapshotView:view];
            }
        }
    }else{
        if (view && !transImg) {
           transImg = [HBHelper snapshotView:view];
        }
    }
    self.presentingImageView.image = transImg;
    self.presentingImageView.contentMode = view.contentMode;
    self.presentingImageView.clipsToBounds = view.clipsToBounds;
    self.presentingImageView.layer.cornerRadius = view.layer.cornerRadius;
    
    [containerView addSubview:self.presentingImageView];
    [containerView addSubview:toViewController.view];
    
    view.hidden = YES;
    //添加目标控制器view
    toViewController.view.alpha = 0;
    [containerView addSubview:toViewController.view];
    
    //添加imageView
    [containerView addSubview:self.presentingImageView];
    
    if (!view) {
        [UIView animateWithDuration:duration animations:^{
            toViewController.view.alpha = 1;
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            self.presentingImageView.alpha = 0;
            self.presentingImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        } completion:^(BOOL finished) {
            self.presentingImageView.hidden = NO;
            [self.presentingImageView removeFromSuperview];
            [toViewController prepareLoad];
            [transitionContext completeTransition:YES];
        }];
    }else{
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            toViewController.view.alpha = 1;
            CGSize imgSize = [HBHelper scaleAspectFitImageViewWithImage:self.presentingImageView.image];
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            self.presentingImageView.frame =  CGRectMake((screenSize.width - imgSize.width) /2, (screenSize.height - imgSize.height)/2, imgSize.width, imgSize.height);
        } completion:^(BOOL finished) {
            self.presentingImageView.hidden = YES;
            [self.presentingImageView removeFromSuperview];
            [toViewController prepareLoad];
            [transitionContext completeTransition:YES];
        }];
    }
}

- (void)finishInteractiveTransition {
    
}

- (void)cancelInteractiveTransition {
    
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    
}

- (void)animationEnded:(BOOL)transitionCompleted {
    //动画结束
}


@end
