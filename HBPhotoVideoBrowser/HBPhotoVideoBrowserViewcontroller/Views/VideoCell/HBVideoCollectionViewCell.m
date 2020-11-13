//
//  HBVideoCollectionViewCell.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 09/10/2020.
//

#import "HBVideoCollectionViewCell.h"
#import "HBHelper.h"
#import "HBMediaPlayerView.h"

@interface HBVideoCollectionViewCell ()<UIGestureRecognizerDelegate,HBMediaPlayerDelegate>

@property (nonatomic, strong) HBMediaPlayerView * playerView;

//拖拽手势使用
@property (nonatomic, assign) CGPoint   startLocation;

@property (nonatomic, assign) CGRect    startFrame;

//动画使用
@property (nonatomic, strong) UIImageView * transtionImgV;

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

//滑动时暂停播放状态
- (void) resetUI {
    [super resetUI];
    [self.playerView pause];
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
}

- (void) pan:(UIPanGestureRecognizer *) gesture {
    CGPoint point       = CGPointZero;
    CGPoint location    = CGPointZero;
    CGPoint velocity    = CGPointZero;
    point       = [gesture translationInView:self.contentView];
    location    = [gesture locationInView:self.playerView];
    velocity    = [gesture velocityInView:gesture.view];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            //NSLog(@"start");
            _startLocation  = location;
            _startFrame     = self.playerView.frame;
            if (self.delegate && [self.delegate respondsToSelector:@selector(gestureToolsViewShouldHide:)]) {
                [self.delegate gestureToolsViewShouldHide:YES];
            }
            [self.playerView changPlayerToolsStatus:YES];
            
            self.transtionImgV.image = self.playerView.currPlayerImage;
            self.playerView.hidden = YES;
            self.transtionImgV.hidden = NO;
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
            
//            self.playerView.playerLayer.frame = CGRectMake(x, y, width, height);
//            self.transtionImgV.frame = CGRectMake(x+(width/2 - self.transtionImgV.frame.size.width * s/2),
//                                                  y+(height/2 - self.transtionImgV.frame.size.height * s/2),
//                                                  self.transtionImgV.frame.size.width * s,
//                                                  self.transtionImgV.frame.size.height * s);
            self.transtionImgV.frame = CGRectMake(x, y, width, height);
            

            self.superview.superview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:percent];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            //NSLog(@"cancel or end");
            self.playerView.hidden = NO;
            self.transtionImgV.hidden = YES;
            if(fabs(point.y) > 200 || fabs(velocity.y) > 600){
                // dismiss
                _startFrame = self.transtionImgV.frame;
                [self hideBrowser];
            }else{
                // cancel
                [self.playerView changPlayerToolsStatus:NO];
                [UIView animateWithDuration:0.25 animations:^{
                    self.superview.superview.backgroundColor = [UIColor blackColor];
//                    self.playerView.playerLayer.frame = self.playerView.bounds;
                }];
                if (self.delegate && [self.delegate respondsToSelector:@selector(gestureToolsViewShouldHide:)]) {
                    [self.delegate gestureToolsViewShouldHide:NO];
                }
            }
        }
            break;
        case UIGestureRecognizerStateFailed:{
            NSLog(@"failed");
            self.playerView.hidden = NO;
            self.transtionImgV.hidden = YES;
        }
            break;
        default:{
            NSLog(@"other");
            self.playerView.hidden = NO;
            self.transtionImgV.hidden = YES;
        }
            break;
    }
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

#pragma mark - setter
- (void)setData:(HBDataItem *)data atItem:(NSInteger)item {
    [super setData:data atItem:item];
    if (data.dataType == HBDataTypeVIDEO) {
        self.playerView.mediaURL = data.dataURL;
    }
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
        [UIView animateWithDuration:1.f animations:^{
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
        _transtionImgV = [[UIImageView alloc] initWithFrame:[self.contentView convertRect:self.dataItem.translationView.frame fromView:self.dataItem.translationView.superview]];
        if ([self.dataItem.translationView isKindOfClass:[UIImageView class]]) {
            UIImageView * imageV = (UIImageView *)self.dataItem.translationView;
            _transtionImgV.image = imageV.image;
        }else{
            if (self.dataItem.translationView) {
               _transtionImgV.image = [HBHelper snapshotView:self.dataItem.translationView];
            }
        }
        CGSize dismissSize = [HBHelper scaleAspectFitImageViewWithImage:_transtionImgV.image];
        CGRect frame = CGRectMake(CGRectGetWidth(self.contentView.frame)/2 - dismissSize.width/2, CGRectGetHeight(self.contentView.frame)/2 - dismissSize.height/2, dismissSize.width, dismissSize.height);
        _transtionImgV.frame = frame;
        [self.contentView addSubview:_transtionImgV];
    }
    return _transtionImgV;
}

- (void)dealloc {
    
}

@end
