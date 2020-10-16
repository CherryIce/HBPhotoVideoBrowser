//
//  UIViewController+HBTransition.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 14/10/2020.
//

#import "UIViewController+HBTransition.h"

#import "HBPresentTransition.h"
#import "HBDismissTransition.h"

@implementation UIViewController (HBTransition)

- (void)presentHBViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^__nullable)(void))completion{
    viewControllerToPresent.transitioningDelegate = self;
    viewControllerToPresent.modalPresentationStyle =  UIModalPresentationOverCurrentContext;
    viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = YES;//隐藏statusbar
    [self presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)dismissHBViewControllerAnimated:(BOOL)flag completion:(void (^__nullable)(void))completion{
    [self dismissViewControllerAnimated:flag completion:completion];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    HBPresentTransition * animates = [HBPresentTransition new];
    return animates;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    HBDismissTransition * animates = [HBDismissTransition new];
    return animates;
}

@end
