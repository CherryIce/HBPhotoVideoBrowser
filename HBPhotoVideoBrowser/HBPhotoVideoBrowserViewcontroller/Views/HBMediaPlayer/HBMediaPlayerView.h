//
//  HBMediaPlayerView.h
//  MediaPlayer
//
//  Created by hubin on 11/11/2020.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSUInteger, HBMediaPlayerStatus) {
    HBMediaPlayerBuffer,//缓冲状态
    HBMediaPlayerReadyPlay,//准备播放
    HBMediaPlayerPlaying,//正在播放
    HBMediaPlayerPause,//已暂停
};

NS_ASSUME_NONNULL_BEGIN

@protocol HBMediaPlayerDelegate <NSObject>

@optional

- (void) exceptionAboutMediaLoadingError:(NSError *)error;

- (void) calculateBufferProgress:(CGFloat)progress;

@end

@interface HBMediaPlayerView : UIView

@property (nonatomic , weak) id<HBMediaPlayerDelegate>delegate;

//media player stauts
@property (nonatomic , assign) HBMediaPlayerStatus playerStatus;

//media addres
@property (nonatomic, strong) NSURL * mediaURL;

//default is NO
@property (nonatomic, assign) BOOL isNeedAutoPlay;

//player current image
@property (nonatomic, readonly) UIImage * currPlayerImage;

//start play media
- (void) play;

//pause media
- (void) pause;

//player tools show and hide
- (void) changPlayerToolsStatus:(BOOL)hide;

// animation frame and drag
- (void) transfromAniLayout:(CGRect) frame drag:(BOOL)drag;

@end

NS_ASSUME_NONNULL_END
