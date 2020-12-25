//
//  HBBrowserDataSource.h
//  HBPhotoVideoBrowser
//
//  Created by hubin on 12/10/2020.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HBBrowserDataSourceProtocol.h"
#import "HBCellDataProtocol.h"
#import "HBDataItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBBrowserDataSource : NSObject<UICollectionViewDelegate,UICollectionViewDataSource,HBCellEventDelegate>

@property (nonatomic , strong) NSArray <HBDataItem *> * dataSourceArray;

@property (nonatomic , weak) id<HBBrowserDataSourceDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
