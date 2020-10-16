//
//  HBCellDataProtocol.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 09/10/2020.
//

#ifndef HBCellDataProtocol_h
#define HBCellDataProtocol_h

#import "HBDataItem.h"

@protocol HBCellDataDelegate <NSObject>

- (void) setData:(HBDataItem *)data atItem:(NSInteger)item;

@end


#endif /* HBCellDataProtocol_h */
