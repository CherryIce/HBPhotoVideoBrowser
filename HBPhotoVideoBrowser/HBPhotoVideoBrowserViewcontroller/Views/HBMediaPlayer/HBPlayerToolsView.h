//
//  HBPlayerToolsView.h
//  MediaPlayer
//
//  Created by hubin on 11/11/2020.
//

#import <UIKit/UIKit.h>

@protocol HBPlayerToolsDelegate <NSObject>

@optional

- (void) playOrPause:(BOOL)play;

- (void) sliderMoveBegin;

- (void) sliderMoveValueChanged;

- (void) sliderStopMove;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HBPlayerToolsView : UIView

//just do sth
@property (nonatomic , weak) id<HBPlayerToolsDelegate>delegate;

//progress  slider
@property (nonatomic, strong) UISlider * progSlider;

//current play time
@property (nonatomic , copy) NSString * currTime;

//media total time
@property (nonatomic , copy) NSString * totalTime;

//play status
@property (nonatomic , assign) BOOL isPlay;

//play value
@property (nonatomic , assign) float playValue;

//show
- (void) show;

//hidden
- (void) dismiss;

//cancel auto hidden
- (void) cancelAutoHide;

@end

NS_ASSUME_NONNULL_END
