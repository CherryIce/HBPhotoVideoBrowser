//
//  HBCellEventProtocol.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 09/10/2020.
//

#ifndef HBCellEventProtocol_h
#define HBCellEventProtocol_h

@protocol HBCellEventDelegate <NSObject>

@optional

//退出图片视频浏览
- (void) pan_hideBrowser:(CGRect)dimissRect;

//长按手势
- (void) longProgressGestureCallBack;

//手势时隐藏工具栏
- (void) gestureToolsViewShouldHide:(BOOL)hide;

//原图下载进度
- (void) loadOrignalImageProgress:(CGFloat)progressValue;

//原图是否下载成功
- (void) loadOrignalImageIsScucess:(BOOL)sucess;

@end


#endif /* HBCellEventProtocol_h */
