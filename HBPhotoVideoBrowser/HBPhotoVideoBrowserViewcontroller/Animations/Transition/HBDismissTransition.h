//
//  HBDismissTransition.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 14/10/2020.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBDismissTransition : UIPercentDrivenInteractiveTransition<UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong)id<UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic,strong)    UIImageView * dimssImageView;

@end

NS_ASSUME_NONNULL_END
