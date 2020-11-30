//
//  HBToolsView.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 20/11/2020.
//

#import <UIKit/UIKit.h>

#import "HBDataItem.h"
#import "HBToolsViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBToolsView : UIView
/**
 */
@property (nonatomic , weak) id<HBToolsViewDelegate>delegate;
/**
 */
@property (nonatomic , copy) NSArray <UIImage *>* imgDataArray;
/**
 */
@property (nonatomic , copy) HBDataItem * currItem;
/**
 */
@property (nonatomic , assign) CGFloat progressValue;
/**
 */
@property (nonatomic , assign) BOOL isDownLoadFinish;
/**
 */
@property (nonatomic , assign) BOOL isNeedAutoHide;
/**
 */
- (void) show;
/**
 */
- (void) hide;
/**
 */
- (void) cancelAutoHide;

@end

NS_ASSUME_NONNULL_END
