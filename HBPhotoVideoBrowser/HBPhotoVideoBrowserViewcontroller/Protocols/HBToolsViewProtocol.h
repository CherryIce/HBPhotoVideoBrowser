//
//  HBToolsViewProtocol.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 20/11/2020.
//

#ifndef HBToolsViewProtocol_h
#define HBToolsViewProtocol_h

@protocol HBToolsViewDelegate <NSObject>

@optional

- (void) hbImageToolsSubViewsClickEvent:(NSInteger) itemIndex;

- (void) clickEventForDownloadOrignalImage;

@end



#endif /* HBToolsViewProtocol_h */
