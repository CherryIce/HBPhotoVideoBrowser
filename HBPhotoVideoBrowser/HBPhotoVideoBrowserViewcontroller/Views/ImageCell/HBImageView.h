//
//  HBImageView.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 14/10/2020.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBImageView : UIImageView

- (void) loadImageWithURL:(NSURL *) imageURL
         placeholderImage:(nullable UIImage *)placeholder
                 progress:(void (^) (CGFloat progress))progressBlock
                completed:(void (^) (bool isSucess ,UIImage * image))completedBlock ;

@end

NS_ASSUME_NONNULL_END
