//
//  HBDataItem.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 12/10/2020.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HBDataType) {
    HBDataTypeIMAGE,//图片
    HBDataTypeVIDEO,//视频
};

NS_ASSUME_NONNULL_BEGIN

@interface HBDataItem : NSObject

/**
 当前数据模型对应cell 外部自定义cell需设置此属性<需继承自basecell>
 */
@property (nonatomic , strong) Class cellClass;

/**
 数据类型
 */
@property (nonatomic , assign) HBDataType dataType;

/**
 大图链接 - 清晰图
 */
@property (nonatomic , strong) NSURL * dataURL;

/**
 小图链接 - 缩略图
 */
@property (nonatomic , strong) NSURL * thumbnailURL;

/**
 消失动画对应的视图--进入对应的视图
*/
@property (nonatomic,strong) UIView  *translationView;

/**
 图片 - 传的啥就显示啥
*/
@property (nonatomic , strong) UIImage * image;

/**
 原图 - 仅可读 - 针对链接下载的原图
*/
@property (nonatomic,readonly) UIImage *orignalImage;

/**
 小图 - 仅可读 - 针对链接下载的
*/
@property (nonatomic,readonly) UIImage *smallImage;

/**
 原图大小 - 有原图需传
*/
@property (nonatomic,assign) long long orignalSize;

/**
 预留扩展属性
*/
@property (nonatomic , strong) id extraData;

/**
 由于collectionview复用机制问题 不建议设置每个视频都需要自动播放 此属性建议只针对当前点击打开的第一视图是视频的情况
 */
@property (nonatomic,assign) BOOL isJustCurrentIndexNeedAutoPlay;

/**
 是否是大图
 */
@property (nonatomic,assign) BOOL isLargeImage;

/** ------------- 快速创建方法 ------------- **/
- (instancetype) initWithImage:(UIImage *) image;

/**
 url - dataURL
 dataURL - 类型
 */
- (instancetype) initWithURL:(NSURL *)url dataType:(HBDataType)dataType;

@end

NS_ASSUME_NONNULL_END
