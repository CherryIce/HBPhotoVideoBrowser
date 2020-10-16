//
//  HBBrowserDataSourceProtocol.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 12/10/2020.
//

#ifndef HBBrowserDataSourceProtocol_h
#define HBBrowserDataSourceProtocol_h

@protocol HBBrowserDataSourceDelegate <NSObject>

//滚动中禁止工具栏操作
- (void) forbiddenToolsWhileScrolling;

//滚动到了哪一个index
- (void) collectionViewDidEndScrollToIndex:(NSInteger) index;

@optional

//退出图片视频浏览
- (void) hideBrowser:(CGRect)dimissRect;

//长按手势
- (void) browserLpGesture;

//手势时隐藏工具栏
- (void) hideToolsWhileGestures:(BOOL)hide;

//原图下载进度
- (void) orignalImageDownLoadProgress:(CGFloat)progressValue;

//原图是否下载成功
- (void) orignalImageDownLoadSucess:(BOOL)sucess;

@end


#endif /* HBBrowserDataSourceProtocol_h */
