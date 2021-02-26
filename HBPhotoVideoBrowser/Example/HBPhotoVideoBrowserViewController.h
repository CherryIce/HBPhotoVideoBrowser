//
//  HBPhotoVideoBrowserViewController.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 09/10/2020.
//

#import <UIKit/UIKit.h>

#import "HBDataItem.h"
#import "UIViewController+HBTransition.h"
#import "HBPhotoVideoBrowserControllerProtocol.h"
#import "HBToolsView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HBBrowserViewControllerDelegate <NSObject>

@optional
- (void) hideBrowserControllerAtIndex:(NSInteger) index item:(HBDataItem *) item;

- (void) longPanBrowserViewAtIndex:(NSInteger) index item:(HBDataItem *) item;

@end

@interface HBPhotoVideoBrowserViewController : UIViewController<HBPhotoVideoBrowserViewControllerDelegate>

//底部工具栏
@property (nonatomic , strong) HBToolsView * browserToolsView;

//delegate
@property (nonatomic , weak) id <HBBrowserViewControllerDelegate> delegate;

//是否允许长按手势 default is NO
@property (nonatomic , assign) BOOL isAllowLpGesture;

//长按手势操作
- (void) browserLpGesture;

@end

NS_ASSUME_NONNULL_END
