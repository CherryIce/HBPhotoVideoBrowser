//
//  HBPhotoVideoBrowserControllerProtocol.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 12/10/2020.
//

#ifndef HBPhotoVideoBrowserControllerProtocol_h
#define HBPhotoVideoBrowserControllerProtocol_h

#import "HBDataItem.h"

@protocol HBPhotoVideoBrowserViewControllerDelegate <NSObject>

//- (NSArray <HBDataItem *> *) numberOfItemInViewcontroller:(UIViewController *)viewcontroller;

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

//显示数据 不需要调用...
- (void) prepareLoad;

@end


#endif /* HBPhotoVideoBrowserControllerProtocol_h */
