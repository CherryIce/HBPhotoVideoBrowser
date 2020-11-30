//
//  HBMediaPlayerView.m
//  MediaPlayer
//
//  Created by hubin on 11/11/2020.
//

#import "HBMediaPlayerView.h"
#import <AVKit/AVKit.h>
#import "HBPlayerToolsView.h"
#import "HBHelper.h"

static NSString * const MediaErrorDomain    =  @"HBMediaPlayerError";
static NSString * const MediaURLFailed      =  @"loading media url failed";
static NSString * const MediaURLInvalid     =  @"media url is invalid";
static NSInteger  const MediaURLFailCode    =  -1;
static NSInteger  const MediaURLInvalidCode =  404;

@interface HBMediaPlayerView()<HBPlayerToolsDelegate>

@property (nonatomic, strong) AVPlayer * player;

@property (nonatomic, strong) AVPlayerItem * item;

@property (nonatomic, strong) AVPlayerLayer * playerLayer;

@property (nonatomic, strong) HBPlayerToolsView * playerToolsView;

@property (nonatomic, strong) id playbackObserver;

@property (nonatomic, strong) UIButton * playButton;

@property (nonatomic, strong) AVPlayerItemVideoOutput * videoOutPut;

@property (nonatomic, assign) BOOL isDraging;

@end

@implementation HBMediaPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isNeedAutoPlay = NO;
        _playerStatus = HBMediaPlayerBuffer;
        [self.layer addSublayer:self.playerLayer];
        [self addSubview:self.playButton];
        [self addSubview:self.playerToolsView];
    }
    return self;
}

#pragma mark - setter
- (void)setMediaURL:(NSURL *)mediaURL {
    _mediaURL = mediaURL;
    
    //初始化输出流
    _videoOutPut = [[AVPlayerItemVideoOutput alloc] init];
    //初始化视频
    self.item = [AVPlayerItem playerItemWithURL:mediaURL];
    //添加输出流
    [self.item addOutput:_videoOutPut];
    
    [self addObserverToPlayerItem:self.item];
    
    [self.player  replaceCurrentItemWithPlayerItem:self.item];
    [self.player seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self playerItemAddNotification];
    });
}

- (void)setIsNeedAutoPlay:(BOOL)isNeedAutoPlay {
    _isNeedAutoPlay = isNeedAutoPlay;
}

#pragma mark - readonly
- (UIImage *)currPlayerImage {
    CMTime itemTime = self.player.currentItem.currentTime;
    CVPixelBufferRef pixelBuffer = [_videoOutPut copyPixelBufferForItemTime:itemTime itemTimeForDisplay:nil];
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(pixelBuffer),
                                                 CVPixelBufferGetHeight(pixelBuffer))];
    
    //当前帧的画面
    UIImage *currentImage = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    return currentImage;
}

#pragma mark - public
//start play media
- (void) play {
    switch (_playerStatus) {
        case HBMediaPlayerBuffer:{
            NSLog(@"are you ready?");
        }
            break;
        case HBMediaPlayerReadyPlay:
        case HBMediaPlayerPause:{
            [self.player play];
            [self.playButton setHidden:YES];
            self.playerToolsView.isPlay = YES;
            _playerStatus = HBMediaPlayerPlaying;
        }
            break;
        case HBMediaPlayerPlaying:
        default:
//            NSLog(@"what are you doing?");
            break;
    }
    if (self.playerToolsView.hidden) {
        [self.playerToolsView show];
    }
}

//pause media
- (void) pause {
    switch (_playerStatus) {
        case HBMediaPlayerBuffer:{
            NSLog(@"buffering...");
        }
            break;
        case HBMediaPlayerReadyPlay:
        case HBMediaPlayerPlaying:{
            [self.player pause];
            [self.playButton setHidden:NO];
            self.playerToolsView.isPlay = NO;
            _playerStatus = HBMediaPlayerPause;
        }
            break;
        case HBMediaPlayerPause:
        default:
//            NSLog(@"what are you doing?");
            break;
    }
    if (self.playerToolsView.hidden) {
        [self.playerToolsView show];
    }
}

//hide player tools
- (void) changPlayerToolsStatus:(BOOL)hide{
    if (hide) {
        if (!self.playerToolsView.hidden) {
            [self.playerToolsView dismiss];
        }
        self.playButton.hidden = YES;
    } else {
        if (self.playerToolsView.hidden) {
            [self.playerToolsView show];
        }
        if (self.playerStatus != HBMediaPlayerPlaying) {
            self.playButton.hidden = NO;
        }
    }
}

- (void) transfromAniLayout:(CGRect) frame drag:(BOOL)drag {
    _isDraging = drag;
    self.playerLayer.frame = frame;
}

#pragma mark - HBPlayerToolsDelegate
- (void) playOrPause:(BOOL)play {
    if (play) {
        [self play];
    }else{
        [self pause];
    }
}

- (void)sliderMoveBegin {
    [self pause];
    self.playButton.hidden = YES;
}

- (void)sliderMoveValueChanged {
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.playerToolsView.playValue;
    NSInteger currentMin = currentTime / 60;
    NSInteger currentSec = (NSInteger)currentTime % 60;
    self.playerToolsView.currTime = [NSString stringWithFormat:@"%02ld:%02ld",currentMin,currentSec];
}

- (void)sliderStopMove {
    NSTimeInterval slideTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.playerToolsView.playValue;
    if (slideTime == CMTimeGetSeconds(self.player.currentItem.duration)) {
        slideTime -= 0.5;
    }
    [self.player seekToTime:CMTimeMakeWithSeconds(slideTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self play];
}

#pragma mark - Time
- (void)setTimeLabel {
    
    NSTimeInterval totalTime = CMTimeGetSeconds(self.player.currentItem.duration);//总时长
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);//当前时间进度
    
    // 切换视频源时totalTime/currentTime的值会出现NAN导致时间错乱
    if (!(totalTime >= 0) || !(currentTime >= 0)) {
        totalTime = 0;
        currentTime = 0;
    }
    
    NSInteger totalMin = totalTime / 60;
    NSInteger totalSec = (NSInteger)totalTime % 60;
    NSString *totalTimeStr = [NSString stringWithFormat:@"%02ld:%02ld",totalMin,totalSec];
    
    NSInteger currentMin = currentTime / 60;
    NSInteger currentSec = (NSInteger)currentTime % 60;
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02ld:%02ld",currentMin,currentSec];
    
    self.playerToolsView.currTime = currentTimeStr;
    self.playerToolsView.totalTime = totalTimeStr;
}

#pragma mark - observe
- (void)playerItemAddNotification {
    // 播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.playerToolsView.isPlay = NO;
    });
}

- (void)playbackFinished:(NSNotification *)noti{
    //播放结束
    [self pause];
    self.playerToolsView.playValue = 0;
    self.playerToolsView.currTime = @"00:00";
    self.mediaURL = _mediaURL;
    self.playButton.hidden = NO;
}

- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem {
    // 监听播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监听缓冲进度
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)playerItemRemoveNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)playerItemRemoveObserver {
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            [self setTimeLabel];
        }else{
            // error call back
            NSInteger errorCode = status == 2 ? MediaURLFailCode : MediaURLInvalidCode;
            NSString *errorMsg  = status == 2 ? MediaURLFailed   : MediaURLInvalid;
            NSError * error = [[NSError alloc] initWithDomain:MediaErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey : errorMsg}];
            if (self.delegate && [self.delegate respondsToSelector:@selector(exceptionAboutMediaLoadingError:)]) {
                [self.delegate exceptionAboutMediaLoadingError:error];
            }
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = self.player.currentItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);//本次缓冲起始时间
        NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);//缓冲时间
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        float totalTime = CMTimeGetSeconds(self.player.currentItem.duration);//视频总长度
        float progress = totalBuffer/totalTime;//缓冲进度

        //如果缓冲完了，拖动进度条不需要重新显示缓冲条
        if (_playerStatus == HBMediaPlayerBuffer) {
            if (progress == 1) {
                _playerStatus = HBMediaPlayerReadyPlay;
                self.playButton.hidden = NO;
                //开启自动播放
                if (_isNeedAutoPlay) {
                    [self play];
                }
            }
            //缓冲期间才需要传
            if (self.delegate && [self.delegate respondsToSelector:@selector(calculateBufferProgress:)]) {
                [self.delegate calculateBufferProgress:progress];
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //拖拽情况 不去布局
    if (_isDraging) {
        return;
    }
    
    self.playerLayer.frame = self.bounds;
    self.playButton.frame = CGRectMake(0, 0, 50, 50);
    self.playButton.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    
    CGFloat left = 16;
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        left += self.safeAreaInsets.left;
        bottom = self.safeAreaInsets.bottom;
    }
    self.playerToolsView.frame = CGRectMake(left, CGRectGetHeight(self.frame) - bottom - [HBHelper hbSafeBottom] - [HBHelper hbToolsHeight] * 2, CGRectGetWidth(self.frame) - 2*left, [HBHelper hbToolsHeight]);
}

#pragma mark - getter
- (AVPlayer *)player{
    if (!_player) {
        _player = [[AVPlayer alloc] init];
        if (@available(iOS 10.0, *)) {
            /**边下边播需要设置的属性*/
            _player.automaticallyWaitsToMinimizeStalling = NO;
        }
        __weak typeof(self) weakSelf = self;
        // 每秒回调一次
        self.playbackObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
            [weakSelf setTimeLabel];
            NSTimeInterval totalTime = CMTimeGetSeconds(weakSelf.player.currentItem.duration);//总时长
            NSTimeInterval currentTime = time.value / time.timescale;//当前时间进度
            weakSelf.playerToolsView.playValue = currentTime / totalTime;
        }];
    }
    return _player;
}

- (AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = self.bounds;
    }
    return _playerLayer;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake(0, 0, 50, 50);
        _playButton.center = self.center;
        [_playButton setBackgroundImage:[UIImage imageNamed:@"meidaPlay"] forState:0];
        [_playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
        _playButton.hidden = YES;
    }
    return _playButton;
}

- (HBPlayerToolsView *)playerToolsView {
    if (!_playerToolsView) {
        _playerToolsView = [[HBPlayerToolsView alloc]initWithFrame:CGRectZero];
        _playerToolsView.delegate = self;
        _playerToolsView.layer.cornerRadius = 5;
        _playerToolsView.layer.masksToBounds = YES;
    }
    return _playerToolsView;
}

- (void)dealloc {
    [self playerItemRemoveNotification];
    [self.player removeTimeObserver:self.playbackObserver];
    [self playerItemRemoveObserver];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
