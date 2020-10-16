//
//  HBCollectionView.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 14/10/2020.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBCollectionView : UICollectionView

//获取屏幕中央显示cell
- (UICollectionViewCell *)centerCell;

//失效原来布局 保障新布局可以实现
- (void) safeLayoutInvalidateLayout;

@end

NS_ASSUME_NONNULL_END
