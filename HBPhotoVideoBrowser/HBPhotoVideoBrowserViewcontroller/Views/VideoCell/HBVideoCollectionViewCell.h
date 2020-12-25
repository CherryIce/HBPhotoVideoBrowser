//
//  HBVideoCollectionViewCell.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 09/10/2020.
//

#import <UIKit/UIKit.h>
#import "HBCellDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBVideoCollectionViewCell : UICollectionViewCell<HBCellDataDelegate>

@property (nonatomic , weak) id<HBCellEventDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
