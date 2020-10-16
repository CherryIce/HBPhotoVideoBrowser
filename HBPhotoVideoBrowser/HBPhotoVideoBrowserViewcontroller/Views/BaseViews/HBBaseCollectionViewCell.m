//
//  HBBaseCollectionViewCell.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 09/10/2020.
//

#import "HBBaseCollectionViewCell.h"

@implementation HBBaseCollectionViewCell

- (void)setData:(HBDataItem *)data atItem:(NSInteger)item {
    // set datas
    _dataItem = data;
    _currentIndex = item;
}

- (void)resetUI {
    // to do something
}

#pragma mark - getter
- (HBLoadView *)loading {
    if (!_loading) {
        _loading = [[HBLoadView alloc] initWithFrame:CGRectZero];
    }
    return _loading;
}

@end
