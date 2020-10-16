//
//  HBBaseCollectionViewCell.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 09/10/2020.
//

#import <UIKit/UIKit.h>
#import "HBCellDataProtocol.h"
#import "HBCellEventProtocol.h"
#import "HBLoadView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBBaseCollectionViewCell : UICollectionViewCell<HBCellDataDelegate>

@property (nonatomic , weak) id<HBCellEventDelegate>delegate;

@property (nonatomic , assign) NSInteger currentIndex;

@property (nonatomic , strong) HBLoadView * loading;

@property (nonatomic , strong) HBDataItem * dataItem;

- (void) resetUI;

@end

NS_ASSUME_NONNULL_END
