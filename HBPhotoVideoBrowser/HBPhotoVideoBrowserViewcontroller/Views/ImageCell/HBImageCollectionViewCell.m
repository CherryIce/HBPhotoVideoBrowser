//
//  HBImageCollectionViewCell.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 09/10/2020.
//

#import "HBImageCollectionViewCell.h"
#import <SDWebImage.h>
#import "HBScrollView.h"
#import "HBHelper.h"

@interface HBImageCollectionViewCell()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic , strong) HBScrollView * imageScrollView;

//拖拽手势使用
@property (nonatomic, assign) CGPoint   startLocation;

@property (nonatomic, assign) CGRect    startFrame;

@property (nonatomic, assign) ImageType imgType;

@end

@implementation HBImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:CGRectMake(frame.origin.x,
                                                frame.origin.y,
                                                [UIScreen mainScreen].bounds.size.width,
                                                [UIScreen mainScreen].bounds.size.height)]) {
        [self.contentView addSubview:self.imageScrollView];
        self.layer.masksToBounds = YES;
        [self addGestures];
    }
    return self;
}

//重置scale
- (void)resetUI {
    self.imageScrollView.zoomScale = 1;
}

#pragma mark - Gestures
- (void) addGestures {
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapClick:)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer * doubleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick:)];
    doubleClick.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleClick];
    
    [singleTap requireGestureRecognizerToFail:doubleClick];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToPan:)];
    pan.maximumNumberOfTouches = 1;
    pan.delegate = self;
    [self addGestureRecognizer:pan];
    [singleTap requireGestureRecognizerToFail:pan];
    [doubleClick requireGestureRecognizerToFail:pan];
    
    UILongPressGestureRecognizer * lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lpRespond:)];
    [self addGestureRecognizer:lp];
    
    [singleTap requireGestureRecognizerToFail:lp];
    [doubleClick requireGestureRecognizerToFail:lp];
}

#pragma mark - gesture
//单击
- (void) singleTapClick:(UITapGestureRecognizer *) gesture {
    [self hideBrowser];
}

//双击
- (void) doubleClick:(UITapGestureRecognizer *) gesture {
    UIScrollView *scrollView = self.imageScrollView;
    if(!self.imageScrollView.imageView.image) return;
    
    if(scrollView.zoomScale <= 1){
        // 1.catch the postion of the gesture
        // 2.contentOffset.x of scrollView  + location x of gesture
        CGFloat x = [gesture locationInView:self].x + scrollView.contentOffset.x;
        
        // 3.contentOffset.y + location y of gesture
        CGFloat y = [gesture locationInView:self].y + scrollView.contentOffset.y;
        [scrollView zoomToRect:(CGRect){{x,y},CGSizeZero} animated:true];
    }else{
        // set scrollView zoom to original
        [scrollView setZoomScale:1.f animated:true];
    }
}

//拖拽
- (void) respondsToPan:(UIPanGestureRecognizer *) gesture {
    if(!self.imageScrollView.imageView.image) return;
    CGPoint point       = CGPointZero;
    CGPoint location    = CGPointZero;
    CGPoint velocity    = CGPointZero;
    point       = [gesture translationInView:self.contentView];
    location    = [gesture locationInView:self.imageScrollView];
    velocity    = [gesture velocityInView:gesture.view];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            //NSLog(@"start");
            _startLocation  = location;
            _startFrame     = self.imageScrollView.imageView.frame;
            if (self.delegate && [self.delegate respondsToSelector:@selector(gestureToolsViewShouldHide:)]) {
                [self.delegate gestureToolsViewShouldHide:YES];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:{
            //NSLog(@"changed");
            double percent = 1 - fabs(point.y) / self.frame.size.height;
            double s = MAX(percent, 0.3);
            
            CGFloat width = self.startFrame.size.width * s;
            CGFloat height = self.startFrame.size.height * s;
            
            CGFloat rateX = (self.startLocation.x - self.startFrame.origin.x) / self.startFrame.size.width;
            CGFloat x = location.x - width * rateX;
            
            CGFloat rateY = (self.startLocation.y - self.startFrame.origin.y) / self.startFrame.size.height;
            CGFloat y = location.y - height * rateY;
            
            self.imageScrollView.imageView.frame = CGRectMake(x, y, width, height);
            
            self.superview.superview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:percent];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            //NSLog(@"cancel or end");
            if(fabs(point.y) > 200 || fabs(velocity.y) > 600){
                // dismiss
                self.startFrame = self.imageScrollView.imageView.frame;
                [self hideBrowser];
            }else{
                //cancel
                [UIView animateWithDuration:0.25 animations:^{
                    self.superview.superview.backgroundColor = [UIColor blackColor];
                    self.imageScrollView.imageView.frame = self.startFrame;
                }];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(gestureToolsViewShouldHide:)]) {
                    [self.delegate gestureToolsViewShouldHide:NO];
                }
            }
        }
            break;
        case UIGestureRecognizerStateFailed:{
            NSLog(@"failed");
        }
            break;
        default:{
            NSLog(@"other");
        }
            break;
    }
}

//长按
- (void) lpRespond : (UILongPressGestureRecognizer *) gesture {
    if (!self.imageScrollView.imageView.image) {
          return;
    }
    if (gesture.state == UIGestureRecognizerStateBegan && [gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
       if (self.delegate && [self.delegate respondsToSelector:@selector(longProgressGestureCallBack)]) {
           [self.delegate longProgressGestureCallBack];
       }
    }
}

//hide
- (void) hideBrowser {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pan_hideBrowser:)]) {
        CGRect frame =  [self.imageScrollView convertRect:self.imageScrollView.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
//        CGRect frame = self.imageScrollView.imageView.frame;
        [self.delegate pan_hideBrowser:frame];
    }
}

#pragma mark - data
- (void)setData:(HBDataItem *)data atItem:(NSInteger)item{
    [super setData:data atItem:item];
    /**
     优先级： 大图链接 >  小图链接 > image
     */
    if (self.dataItem.dataType == HBDataTypeIMAGE) {
        //判断加载方式
        NSURL * url ;
        UIImage * img ;
        //判断加载方式
        if (self.dataItem.dataURL) {
            if (self.dataItem.orignalImage) {
                img = self.dataItem.orignalImage;
            }
            else {
                if (self.dataItem.thumbnailURL) {
                    if (self.dataItem.smallImage) {
                        img = self.dataItem.smallImage;
                    }else{
                        url = self.dataItem.thumbnailURL;
                    }
                }
                else{
                    url = self.dataItem.dataURL;
                }
            }
        }
        else if (self.dataItem.thumbnailURL){
            if (self.dataItem.smallImage) {
                img = self.dataItem.smallImage;
            }
            else{
                url = self.dataItem.thumbnailURL;
            }
        }
        else if (self.dataItem.image){
            img = self.dataItem.image;
        }
        
        
        if (img) {
            self.imageScrollView.imageView.image = img;
            [self resetlayoutWithImage:img];
        }
        else{
            if (url) {
                [self downLoadImageFromURL:url];
            }else{
                NSLog(@"error for HBDataItem class");
            }
        }
    }
}

//根据图片大小设置frame
- (void)resetlayoutWithImage:(UIImage *)image {
    if (!image) {
        return;
    }
    if (self.imageScrollView.zoomScale > self.imageScrollView.minimumZoomScale){
        return;
    }
    
    CGSize  imageSize = image.size;
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat w_rate = imageSize.width/w;
    CGFloat h_rate = imageSize.height/h;
    
    bool isLandscape = w > h;
    self.imgType = ImageNormal;
    
    self.imageScrollView.minimumZoomScale = 1;
    self.imageScrollView.maximumZoomScale = 2.5;
    
    // 计算短边对齐还是长边对齐
    if (w_rate > h_rate) {
        // 横边顶齐
        imageSize.width = w ;
        imageSize.height /= w_rate;
        
        CGFloat ratio = isLandscape ? h/w : w/h; //w>h是横屏的情况
        if (imageSize.width/imageSize.height > ratio * 4) {
            // 全景图 调整放大比率
            self.imgType = ImagePanoramic;
            if (!isLandscape) {
                self.imageScrollView.maximumZoomScale = h / imageSize.height;
            }
        }
    }
    else if (w_rate < h_rate) {
        // 长边顶齐
        CGFloat ratio = isLandscape ? w / h : h / w;
        if (imageSize.height/imageSize.width >ratio * 3) {
            // 特长图 原图两边顶齐屏幕 不居中
            if (self.dataItem.orignalImage) {
                self.imgType = ImageLonglong;
                imageSize.height = imageSize.height * (w / imageSize.width);
                imageSize.width = w;
            }
            else{
                imageSize.width  /= h_rate;
                imageSize.height = h;
            }
        }
        else{
            imageSize.width  /= h_rate;
            imageSize.height = h;
        }
    }
    else {
        // 刚好手机屏幕比例
        imageSize.width = w;
        imageSize.height = h;
    }
    
    CGSize size = imageSize;
    
    CGRect frame = self.imageScrollView.imageView.frame;
    frame.origin = CGPointMake(0, 0);
    frame.size = size;
    
    self.imageScrollView.imageView.frame = frame;
    self.imageScrollView.contentSize = imageSize;
    
    if (self.imgType != ImageLonglong) {
        self.imageScrollView.imageView.center = CGPointMake(self.imageScrollView.bounds.size.width / 2, self.imageScrollView.bounds.size.height / 2);
    }
}

//没缓存才下载
- (void) downLoadImageFromURL:(NSURL *) url {
    UIImage * placeholderImage = nil;
    if ([self.dataItem.translationView isKindOfClass:[UIImageView class]]) {
        UIImageView * imageV = (UIImageView *)self.dataItem.translationView;
        placeholderImage = imageV.image;
    }
    [self.imageScrollView.imageView loadImageWithURL:url placeholderImage:placeholderImage progress:^(CGFloat progress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (!placeholderImage) {
                [self.loading showInView:self.contentView];
            }
        });
    } completed:^(bool isSucess, UIImage * _Nullable image) {
        [self.loading dismiss];
        if (image) {
            [self resetlayoutWithImage:image];
        }
    }];
}

//下载原图完成之后 更新UI
- (void) updateUI {
    if (!self.imageScrollView.imageView.image) {
        return;
    }
    [self.imageScrollView.imageView loadImageWithURL:self.dataItem.dataURL placeholderImage:self.dataItem.smallImage progress:^(CGFloat progress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadOrignalImageProgress:)]) {
                [self.delegate loadOrignalImageProgress:progress];
            }
        });
    } completed:^(bool isSucess, UIImage * _Nullable image) {
        if (image) {
            [self resetlayoutWithImage:image];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(loadOrignalImageIsScucess:)]) {
            [self.delegate loadOrignalImageIsScucess:isSucess];
        }
    }];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
     if (!self.imageScrollView.imageView.image) {
           return;
     }
    CGRect imageViewFrame = self.imageScrollView.imageView.frame;
    CGFloat width = imageViewFrame.size.width,
    height = imageViewFrame.size.height,
    sHeight = scrollView.bounds.size.height,
    sWidth = scrollView.bounds.size.width;
    if (height > sHeight) {
        imageViewFrame.origin.y = 0;
    } else {
        imageViewFrame.origin.y = (sHeight - height) / 2.0;
    }
    if (width > sWidth) {
        imageViewFrame.origin.x = 0;
    } else {
        imageViewFrame.origin.x = (sWidth - width) / 2.0;
    }
    self.imageScrollView.imageView.frame = imageViewFrame;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageScrollView.imageView;
}

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint transP = [(UIPanGestureRecognizer *)otherGestureRecognizer translationInView:otherGestureRecognizer.view];
        if (fabs(transP.y) > fabs(transP.x)) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - getter
- (HBScrollView *)imageScrollView {
    if (!_imageScrollView) {
        _imageScrollView = [[HBScrollView alloc] initWithFrame:CGRectZero];
        _imageScrollView.delegate = self;
    }
    return _imageScrollView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect fitSize = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.imageScrollView.frame = fitSize;
    if (self.imageScrollView.imageView.image) {
        [self resetlayoutWithImage:self.imageScrollView.imageView.image];
    }
}

- (void)dealloc {
    [[SDWebImageManager sharedManager] cancelAll];
}


@end
