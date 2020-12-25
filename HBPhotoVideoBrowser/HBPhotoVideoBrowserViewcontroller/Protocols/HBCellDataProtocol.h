//
//  HBCellDataProtocol.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 09/10/2020.
//

#ifndef HBCellDataProtocol_h
#define HBCellDataProtocol_h

#import "HBCellEventProtocol.h"
#import "HBDataItem.h"

@protocol HBCellDataDelegate <NSObject>

@required
- (void) setData:(HBDataItem *)data delegate:(id<HBCellEventDelegate>)delegate;

@optional
- (void) loadOrignalImage;

- (void) adjustUI;

@end


#endif /* HBCellDataProtocol_h */
