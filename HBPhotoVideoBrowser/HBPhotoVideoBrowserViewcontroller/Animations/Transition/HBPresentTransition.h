//
//  HBPresentTransition.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 14/10/2020.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBPresentTransition : UIPercentDrivenInteractiveTransition<UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong)id<UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic,strong)    UIImageView *presentingImageView;

@end

NS_ASSUME_NONNULL_END
