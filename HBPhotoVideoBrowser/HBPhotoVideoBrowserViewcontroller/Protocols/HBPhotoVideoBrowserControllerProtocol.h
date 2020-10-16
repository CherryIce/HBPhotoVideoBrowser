//
//  HBPhotoVideoBrowserControllerProtocol.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 12/10/2020.
//

#ifndef HBPhotoVideoBrowserControllerProtocol_h
#define HBPhotoVideoBrowserControllerProtocol_h

@protocol HBPhotoVideoBrowserViewControllerDelegate <NSObject>

@optional
- (void) hideBrowserControllerAtIndex:(NSInteger) index item:(HBDataItem *) item;

- (void) showMoreCUrrentMessageAtIndex:(NSInteger) index item:(HBDataItem *) item;

- (void) sendCurrentMessageAtIndex:(NSInteger) index item:(HBDataItem *) item;

@end


#endif /* HBPhotoVideoBrowserControllerProtocol_h */
