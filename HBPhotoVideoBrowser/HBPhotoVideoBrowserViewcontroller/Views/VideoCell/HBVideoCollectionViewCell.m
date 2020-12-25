//
//  HBVideoCollectionViewCell.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 09/10/2020.
//

#import "HBVideoCollectionViewCell.h"
#import "HBHelper.h"
#import "HBMediaPlayerView.h"
#import "HBLoadView.h"

@interface HBVideoCollectionViewCell ()<UIGestureRecognizerDelegate,HBMediaPlayerDelegate>

@property (nonatomic, strong) HBMediaPlayerView * playerView;

//拖拽手势使用
@property (nonatomic, assign) CGPoint   startLocation;

@property (nonatomic, assign) CGRect    startFrame;

//动画使用
@property (nonatomic, strong) UIImageView * transtionImgV;

@property (nonatomic , strong) HBDataItem * dataItem;

@property (nonatomic , strong) HBLoadView * loading;

@end

@implementation HBVideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.playerView];
        [self addGestures];
    }
    return self;
}

#pragma mark -  HBCellDataDelegate
//滑动时暂停播放状态
- (void) adjustUI {
    [self.playerView pause];
    [self.playerView changPlayerToolsStatus:NO];
}

- (void)setData:(HBDataItem *)data delegate:(id<HBCellEventDelegate>)delegate{
    _delegate = delegate;
    self.dataItem = data;
    if (data.dataType == HBDataTypeVIDEO) {
        self.playerView.mediaURL = data.dataURL;
    }
}

#pragma mark - Gestures
- (void) addGestures {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.cancelsTouchesInView = NO;
    pan.maximumNumberOfTouches = 1;
    pan.delegate = self;
    [self addGestureRecognizer:pan];
    
    [tap requireGestureRecognizerToFail:pan];
    
    UILongPressGestureRecognizer * lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lpRespond:)];
    [self.playerView addGestureRecognizer:lp];
    
    [tap requireGestureRecognizerToFail:lp];
    //[lp requireGestureRecognizerToFail:pan];
}

#pragma mark - gesture
- (void) tapClick:(UIGestureRecognizer *) gesture {
    [self.playerView changPlayerToolsStatus:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(gestureToolsViewShouldHide:)]) {
        [self.delegate gestureToolsViewShouldHide:NO];
    }
}

- (void) pan:(UIPanGestureRecognizer *) gesture {
    if (self.playerView.playerStatus == HBMediaPlayerBuffer) {
        return;
    }
    CGPoint point       = CGPointZero;
    CGPoint location    = CGPointZero;
    CGPoint velocity    = CGPointZero;
    point       = [gesture translationInView:self.contentView];
    location    = [gesture locationInView:self.playerView];
    velocity    = [gesture velocityInView:gesture.view];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            //NSLog(@"start");
            [self panStartWithLocation:location];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            //NSLog(@"changed");
            if (_startFrame.size.width == 0 || _startFrame.size.height == 0) [self panStartWithLocation:location];
            
            double percent = 1 - fabs(point.y) / self.frame.size.height;
            double s = MAX(percent, 0.3);
            
            CGFloat width = self.startFrame.size.width * s;
            CGFloat height = self.startFrame.size.height * s;
            
            CGFloat rateX = (self.startLocation.x - self.startFrame.origin.x) / self.startFrame.size.width;
            CGFloat x = location.x - width * rateX;
            
            CGFloat rateY = (self.startLocation.y - self.startFrame.origin.y) / self.startFrame.size.height;
            CGFloat y = location.y - height * rateY;
            
            self.transtionImgV.frame = CGRectMake(x, y, width, height);
            [self.playerView transfromAniLayout:self.transtionImgV.frame drag:YES];
            self.superview.superview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:percent];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            //NSLog(@"cancel or end");
            if(fabs(point.y) > 200 || fabs(velocity.y) > 600){
                // dismiss
                _startFrame = self.transtionImgV.frame;
                [self hideBrowser];
            }else{
                // cancel
                [self.playerView changPlayerToolsStatus:NO];
                [UIView animateWithDuration:0.25 animations:^{
                    self.superview.superview.backgroundColor = [UIColor blackColor];
                    self.transtionImgV.frame = self.bounds;
                    [self.playerView transfromAniLayout:self.transtionImgV.frame drag:YES];
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

//拖拽开始
- (void) panStartWithLocation:(CGPoint)location {
    _startLocation  = location;
    _startFrame     = self.playerView.frame;
    if (self.delegate && [self.delegate respondsToSelector:@selector(gestureToolsViewShouldHide:)]) {
        [self.delegate gestureToolsViewShouldHide:YES];
    }
    [self.playerView changPlayerToolsStatus:YES];
}

//长按
- (void) lpRespond : (UILongPressGestureRecognizer *) gesture {
    if (self.playerView.playerStatus == HBMediaPlayerBuffer) {
        return;
    }
    if (gesture.state == UIGestureRecognizerStateBegan && [gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(longProgressGestureCallBack)]) {
            [self.delegate longProgressGestureCallBack];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //如果手势是触摸的UISlider滑块触发的,手势就不响应
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint transP = [(UIPanGestureRecognizer *)otherGestureRecognizer translationInView:otherGestureRecognizer.view];
        if (fabs(transP.y) > fabs(transP.x)) {
            return NO;
        }
    }
    return YES;
}

- (void) hideBrowser {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pan_hideBrowser:)]) {
        [self.delegate pan_hideBrowser:self.transtionImgV.frame];
    }
}

#pragma mark - HBMediaPlayerDelegate
- (void) exceptionAboutMediaLoadingError:(NSError *)error {
    NSLog(@">>>>>%@",error);
}

- (void) calculateBufferProgress:(CGFloat)progress {
    if (progress < 1) {
        [self.loading showInView:self.contentView];
    }else{
        [self.loading dismiss];
        [UIView animateWithDuration:0.1f animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            self.transtionImgV.hidden = YES;
        }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerView.frame = self.bounds;
}

#pragma mark - getter
- (HBMediaPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[HBMediaPlayerView alloc] initWithFrame:self.bounds];
        _playerView.delegate = self;
        _playerView.isNeedAutoPlay = YES;
    }
    return _playerView;
}

- (UIImageView *)transtionImgV {
    if (!_transtionImgV) {
        _transtionImgV = [[UIImageView alloc] initWithFrame:self.bounds];
        _transtionImgV.contentMode = UIViewContentModeScaleAspectFit;
        if ([self.dataItem.translationView isKindOfClass:[UIImageView class]]) {
            UIImageView * imageV = (UIImageView *)self.dataItem.translationView;
            _transtionImgV.image = imageV.image;
        }else{
            if (self.dataItem.translationView) {
               _transtionImgV.image = [HBHelper snapshotView:self.dataItem.translationView];
            }
        }
        [self.contentView addSubview:_transtionImgV];
    }
    return _transtionImgV;
}

- (HBLoadView *)loading {
    if (!_loading) {
        _loading = [[HBLoadView alloc] initWithFrame:CGRectZero];
    }
    return _loading;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    //code..
}

- (void)dealloc {
    
}

@end
