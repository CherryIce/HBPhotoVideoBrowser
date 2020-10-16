//
//  HBDataItem.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 12/10/2020.
//

#import "HBDataItem.h"
#import "HBImageCollectionViewCell.h"
#import "HBVideoCollectionViewCell.h"
#import <SDWebImage.h>

@interface HBDataItem ()

//临时属性
@property (nonatomic,strong) UIImage * org_f;

@property (nonatomic,strong) UIImage * org_s;

@end

@implementation HBDataItem

- (instancetype)init {
    self = [super init];
    if (self) {
        //默认图片类型
        self.dataType = HBDataTypeIMAGE;
    }
    return self;
}

- (instancetype) initWithImage:(UIImage *) image {
    self = [super init];
    if (self) {
        self.dataType = HBDataTypeIMAGE;
        self.image = image;
    }
    return self;
}

- (instancetype) initWithURL:(NSURL *)url dataType:(HBDataType)dataType {
    self = [super init];
    if (self) {
        self.dataType = dataType;
        self.dataURL = url;
    }
    return self;
}
    
- (Class)cellClass {
    if (!_cellClass) {
        _cellClass = (_dataType == HBDataTypeVIDEO) ? HBVideoCollectionViewCell.class : HBImageCollectionViewCell.class;
    }
    return _cellClass;
}
    
- (UIImage *)orignalImage {
    if (_dataType == HBDataTypeVIDEO) return nil;
    //防止重复解压读取数据造成滑动卡顿
    if (!_org_f) _org_f = [[SDImageCache sharedImageCache] imageFromCacheForKey:_dataURL.absoluteString];
    return _org_f;
}

- (UIImage *)smallImage {
     if (_dataType == HBDataTypeVIDEO) return nil;
    //防止重复解压读取数据造成滑动卡顿
    if (!_org_s) _org_s = [[SDImageCache sharedImageCache] imageFromCacheForKey:_thumbnailURL.absoluteString];
    return _org_s;
}

@end
