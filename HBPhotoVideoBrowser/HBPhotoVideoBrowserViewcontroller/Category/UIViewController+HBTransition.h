//
//  UIViewController+HBTransition.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 14/10/2020.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HBTransition)<UIViewControllerTransitioningDelegate>

- (void)presentHBViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^__nullable)(void))completion;

- (void)dismissHBViewControllerAnimated:(BOOL)flag completion:(void (^__nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
