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

NS_ASSUME_NONNULL_BEGIN

@interface HBPhotoVideoBrowserViewController : UIViewController

//数据源
@property (nonatomic , strong , nullable) NSArray <HBDataItem *> * dataSourceArray;

//当前所在下标
@property (nonatomic , assign ) NSUInteger currentIndex;

//当前数据
@property (nonatomic , readonly , nullable) HBDataItem *  currentDataItem;

//入场动画视图
@property (nonatomic , strong , nullable) UIView * presentingView;

//消失前的frame
@property (nonatomic , assign) CGRect dissMissRect;

//对应消失到的视图
@property (nonatomic , strong , nullable) UIView * dismissView;

//delegate
@property (nonatomic , weak) id <HBPhotoVideoBrowserViewControllerDelegate> delegate;

//是否允许长按手势 default is NO
@property (nonatomic , assign) BOOL isAllowLpGesture;

//显示数据 不需要调用...
- (void) prepareLoad;

@end

NS_ASSUME_NONNULL_END
