//
//  HBPlayerToolsView.m
//  MediaPlayer
//
//  Created by hubin on 11/11/2020.
//

#import "HBPlayerToolsView.h"

// sapce between superview to childview
static CGFloat SUPPER_SAPCE = 16.f;

// sapce between superviewA to childviewB
static CGFloat CHILD_SAPCE = 10.f;

// time label maxlength
static CGFloat TIME_LABEL_WIDTH = 60.f;

// play button size
static CGFloat PLAYSIZE = 36.f;

// show time
static CGFloat SHOW_TIME = 3.f;

@interface HBPlayerToolsView ()

//button for play or pause
@property (nonatomic, strong) UIButton * playBtn;

//show current play time label
@property (nonatomic, strong) UILabel * currentTimeLab;

//media total time label
@property (nonatomic, strong) UILabel * totalTimeLab;

@end

@implementation HBPlayerToolsView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self createUI];
        [self addSliderEvent];
    }
    return self;
}

- (void) addSliderEvent {
    [self.progSlider addTarget:self action:@selector(sliderTouchBegin:) forControlEvents:UIControlEventTouchDown];
    [self.progSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.progSlider addTarget:self action:@selector(sliderTouchEnd:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - UI
- (void)createUI{
    _currTime = _totalTime = @"00:00";
    [self addSubview:self.playBtn];
    [self addSubview:self.currentTimeLab];
    [self addSubview:self.progSlider];
    [self addSubview:self.totalTimeLab];
    
    //hidden after show 3s
    [self performSelector:@selector(hideSelf) withObject:nil afterDelay:SHOW_TIME];
}

- (void) hideSelf {
    [self dismiss];
}

#pragma mark - public
- (void) show {
    //interrupt last hide
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideSelf) object:nil];
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
        self.hidden = NO;
        //hidden after show 3s
        [self performSelector:@selector(hideSelf) withObject:nil afterDelay:SHOW_TIME];
    }];
}

- (void) dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void) cancelAutoHide {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideSelf) object:nil];
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
        self.hidden = NO;
    }];
}

#pragma mark - setter
- (void)setCurrTime:(NSString *)currTime {
    _currTime = currTime;
    self.currentTimeLab.text = _currTime;
}

- (void)setTotalTime:(NSString *)totalTime {
    _totalTime = totalTime;
    self.totalTimeLab.text = _totalTime;
}

- (void)setIsPlay:(BOOL)isPlay {
    _isPlay = isPlay;
    self.playBtn.selected = isPlay;
}

- (void)setPlayValue:(float)playValue {
    _playValue = playValue;
    self.progSlider.value = playValue;
}

#pragma mark - event

- (void)buttonSelected:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    if ([self.delegate respondsToSelector:@selector(playOrPause:)]) {
        [self.delegate playOrPause:sender.selected];
    }
}

//slider
- (void)sliderTouchBegin:(UISlider *)sender {
    self.isPlay = YES;
    //滑动slider自动取消隐藏 move slider don't hide tools
    [self cancelAutoHide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderMoveBegin)]) {
        [self.delegate sliderMoveBegin];
    }
}

- (void)sliderValueChanged:(UISlider *)sender {
    _playValue = sender.value;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderMoveValueChanged)]) {
        [self.delegate sliderMoveValueChanged];
    }
}

- (void)sliderTouchEnd:(UISlider *)sender {
    //滑动完毕再次开启隐藏计时 open auto hide after move end
    [self show];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderStopMove)]) {
        [self.delegate sliderStopMove];
    }
}

#pragma mark - updateUI
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.playBtn.frame = CGRectMake(SUPPER_SAPCE,
                                    (CGRectGetHeight(self.bounds)- PLAYSIZE)/2,
                                    PLAYSIZE,
                                    PLAYSIZE);
    
    self.currentTimeLab.frame = CGRectMake(CGRectGetMaxX(self.playBtn.frame) + CHILD_SAPCE,
                                           CGRectGetMinY(self.playBtn.frame),
                                           TIME_LABEL_WIDTH,
                                           PLAYSIZE);
    
    self.totalTimeLab.frame = CGRectMake(self.bounds.size.width - TIME_LABEL_WIDTH - SUPPER_SAPCE,
                                         CGRectGetMinY(self.playBtn.frame),
                                         TIME_LABEL_WIDTH,
                                         PLAYSIZE);
    
    self.progSlider.frame = CGRectMake(CGRectGetMaxX(self.currentTimeLab.frame) + CHILD_SAPCE,
                                       (CGRectGetHeight(self.bounds)- CHILD_SAPCE)/2,
                                       CGRectGetMinX(self.totalTimeLab.frame) - (CGRectGetMaxX(self.currentTimeLab.frame) + CHILD_SAPCE) - CHILD_SAPCE,
                                       CHILD_SAPCE);
}

#pragma mark - getter
- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"pause"] forState:0];
        [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UILabel *)currentTimeLab {
    if (!_currentTimeLab) {
        _currentTimeLab = [[UILabel alloc] init];
        _currentTimeLab.textColor = [UIColor whiteColor];
        _currentTimeLab.font = [UIFont systemFontOfSize:12];
        _currentTimeLab.textAlignment = NSTextAlignmentCenter;
        _currentTimeLab.text = _currTime;
        _currentTimeLab.adjustsFontSizeToFitWidth = YES;
    }
    return _currentTimeLab;
}

- (UILabel *)totalTimeLab {
    if (!_totalTimeLab) {
        _totalTimeLab = [[UILabel alloc] init];
        _totalTimeLab.textColor = [UIColor whiteColor];
        _totalTimeLab.font = [UIFont systemFontOfSize:12];
        _totalTimeLab.textAlignment = NSTextAlignmentCenter;
        _totalTimeLab.text = _totalTime;
        _totalTimeLab.adjustsFontSizeToFitWidth = YES;
    }
    return _totalTimeLab;
}

- (UISlider *)progSlider{
    if (!_progSlider) {
        _progSlider = [UISlider new];
        _progSlider.maximumTrackTintColor = [UIColor grayColor];
        _progSlider.minimumTrackTintColor = [UIColor whiteColor];
        [_progSlider setThumbImage:[UIImage imageNamed:@"point"] forState:0];
    }
    return _progSlider;
}

@end
