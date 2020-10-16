//
//  HBFlowLayout.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 14/10/2020.
//

#import "HBFlowLayout.h"

@implementation HBFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.minimumLineSpacing = 0.1f;
    self.minimumInteritemSpacing = 0.1f;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

@end
