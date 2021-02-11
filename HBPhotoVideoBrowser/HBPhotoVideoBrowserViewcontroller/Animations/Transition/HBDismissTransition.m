//
//  HBDismissTransition.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 14/10/2020.
//

#import "HBDismissTransition.h"
#import "HBHelper.h"
#import "HBPhotoVideoBrowserControllerProtocol.h"

@implementation HBDismissTransition

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    
    //获取源控制器 注意不要写成 UITransitionContextFromViewKey
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    self.dimssImageView = [[UIImageView alloc] initWithFrame:[(id <HBPhotoVideoBrowserViewControllerDelegate>)fromVc dissMissRect]];
    //[containerView convertRect:fromVc.dismissImageView.frame fromView:fromVc.dismissImageView.superview]
    
    if ([[(id <HBPhotoVideoBrowserViewControllerDelegate>)fromVc dismissView] isKindOfClass:[UIImageView class]]) {
        UIImageView * imageView = (UIImageView *)[(id <HBPhotoVideoBrowserViewControllerDelegate>)fromVc dismissView];
        self.dimssImageView.image = imageView.image;
    }else{
        self.dimssImageView.image = [HBHelper snapshotView:[(id <HBPhotoVideoBrowserViewControllerDelegate>)fromVc dismissView]];
    }
    self.dimssImageView.contentMode = [(id <HBPhotoVideoBrowserViewControllerDelegate>)fromVc dismissView].contentMode;
    self.dimssImageView.clipsToBounds = [(id <HBPhotoVideoBrowserViewControllerDelegate>)fromVc dismissView].clipsToBounds;
    self.dimssImageView.layer.cornerRadius = [(id <HBPhotoVideoBrowserViewControllerDelegate>)fromVc dismissView].layer.cornerRadius;
    
    [containerView addSubview:self.dimssImageView];
    
    //要消失的vc
    fromVc.view.alpha = 1;
    [containerView addSubview:fromVc.view];
    
    //显示和移动图片
    [containerView bringSubviewToFront:self.dimssImageView];
    self.dimssImageView.hidden = NO;
    
    if (![(id <HBPhotoVideoBrowserViewControllerDelegate>)fromVc dismissView]) {
        [UIView animateWithDuration:duration animations:^{
            fromVc.view.alpha = 0;
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            self.dimssImageView.alpha = 0;
            self.dimssImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        } completion:^(BOOL finished) {
            self.dimssImageView.hidden = NO;
            [self.dimssImageView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }else{
        
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            fromVc.view.alpha = 0;
            //计算返回原控制器中image的位置
            CGRect rect = [containerView convertRect:[(id <HBPhotoVideoBrowserViewControllerDelegate>)fromVc dismissView].frame fromView:[(id <HBPhotoVideoBrowserViewControllerDelegate>)fromVc dismissView].superview];
            self.dimssImageView.frame = rect;
        } completion:^(BOOL finished) {
            [(id <HBPhotoVideoBrowserViewControllerDelegate>)fromVc dismissView].hidden = NO;
            self.dimssImageView.hidden = NO;
            [self.dimssImageView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)startInteractiveTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
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
