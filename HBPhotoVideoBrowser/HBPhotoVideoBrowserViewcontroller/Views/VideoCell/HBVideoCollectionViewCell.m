//
//  HBVideoCollectionViewCell.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 09/10/2020.
//

#import "HBVideoCollectionViewCell.h"

@implementation HBVideoCollectionViewCell

- (void)setData:(HBDataItem *)data atItem:(NSInteger)item {
    [super setData:data atItem:item];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addGesture];
    }
    return self;
}

- (void) addGesture {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tttest)];
    [self addGestureRecognizer:tap];
}

- (void) tttest {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(doTT)]) {
//        [self.delegate doTT];
//    }
}

//重置播放状态
- (void)resetUI {
    [super resetUI];
    //code...
}

@end
