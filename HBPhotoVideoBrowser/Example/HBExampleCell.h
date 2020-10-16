//
//  HBExampleCell.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 12/10/2020.
//

#import <UIKit/UIKit.h>

#import "HBDataItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBExampleCell : UICollectionViewCell

@property (nonatomic , strong) UIImageView * imageView;

- (void) refreshCell:(HBDataItem *) data;

@end

NS_ASSUME_NONNULL_END
