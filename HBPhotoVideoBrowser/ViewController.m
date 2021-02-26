//
//  ViewController.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 2020/10/6.
//

#import "ViewController.h"
#import "HBExampleCell.h"
#import "HBPhotoVideoBrowserViewController.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , strong) UICollectionView * collectionView;

@property (nonatomic , strong) NSMutableArray * dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNav];
    [self loadData];
}

- (void) setNav {
    self.title = @"HBBrowserViewController";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"clear cache" style:UIBarButtonItemStyleDone target:self action:@selector(clearCache:)];
}

- (void) loadData {
    [self.collectionView registerClass:[HBExampleCell class] forCellWithReuseIdentifier:NSStringFromClass([HBExampleCell class])];
    
//    HBDataItem * item = [[HBDataItem alloc] initWithImage:[UIImage imageNamed:@"strawberry"]];
//    [self.dataArray addObject:item];

    HBDataItem * item1 = [[HBDataItem alloc] initWithURL:[NSURL URLWithString:@"https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.mp4"] dataType:HBDataTypeVIDEO];
    [self.dataArray addObject:item1];
    
    NSArray * bdstr = @[
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1599113659804&di=36f802a0bc214ced844aa1cf5a6d3cfd&imgtype=0&src=http%3A%2F%2Fimg.ewebweb.com%2Fuploads%2F20190909%2F21%2F1568034829-UwYfWBSKcC.png",
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1597140769418&di=eafbc7332809c3cc7b27f4334a61f2b2&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201605%2F19%2F20160519001344_UNsLS.jpeg",
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1599113659803&di=8ff3a7746988a6843d24671b81235f4d&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201706%2F17%2F20170617163009_38wLV.jpeg",
        @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1527184543,927914212&fm=26&gp=0.jpg",
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1599113659803&di=2ab3feb617f21917338013758d7bb54a&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F2%2F58782d5f5b3d8.jpg",
        @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1918039322,4201999924&fm=26&gp=0.jpg",
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1599113659802&di=14f5966e66a5c8f3a4204629074cb436&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fpic%2Fa%2F29%2F3e37752375.jpg",
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1599113659802&di=dc7e3491ff1a5e3965e8369026ecfe81&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201707%2F07%2F20170707151853_Xr2UP.jpeg",
        @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2800401875,125020289&fm=26&gp=0.jpg",
        @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2723596487,26167808&fm=26&gp=0.jpg",
        @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1138426114,2407713788&fm=26&gp=0.jpg",
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1599113659795&di=5d72ba85a2571231f814e8d183f54023&imgtype=0&src=http%3A%2F%2Fimage.biaobaiju.com%2Fuploads%2F20180802%2F00%2F1533140210-voaArpNuhm.png",
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1599113948888&di=3013cb38a7eac96799671f00871e59ca&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2Fd%2F537c09f8dbf82.jpg",
        @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2189728697,1720975443&fm=26&gp=0.jpg",
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1599113948888&di=9f3a7e9a8037fbd761744d66c36c5afb&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fmobile%2F3%2F57c10471a39d5.jpg",
        @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1734913275,3830009060&fm=26&gp=0.jpg",
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1599113948887&di=3b1acb9a7ca09e1ee06150a101ffa77d&imgtype=0&src=http%3A%2F%2Fpic.616pic.com%2Fys_bnew_img%2F00%2F72%2F06%2FnSnUB7s7PF.jpg",
    ];
    
    for (int i = 0; i < bdstr.count; i++) {
        HBDataItem * item2 = [[HBDataItem alloc] initWithURL:[NSURL URLWithString:bdstr[i]] dataType:HBDataTypeIMAGE];
        [self.dataArray addObject:item2];
    }
    
    NSArray * urlStr = @[
        @"https://nim-nosdn.netease.im/MTY2Nzk0NTU=/bmltYV8xMzgzOTQ1OTEyM18xNTk3OTkwOTE0NjU2X2U5ZThjNjU0LWU5YmYtNDU0Zi1hZWM1LWQ1YTlhYWIyOTYxMg==",
        @"https://nim-nosdn.netease.im/MTY2Nzk0NTU=/bmltYV8xMzgzOTQ1OTEyM18xNTk3OTkwOTE0NjU4XzNlYTcwYjRiLWJiZjAtNDExOS1hOTBkLTAxYTgyNGJjYTVmOA==",
        @"https://nim-nosdn.netease.im/MTY2Nzk0NTU=/bmltYV8xMzgzOTQ1OTEyM18xNTk3OTkwOTE0NjU1X2I5NjRiYTMzLTQzMWYtNGNkOC1iNGU5LWIxNDEyN2RhYjRlYQ=="];
    
    for (int i = 0; i < urlStr.count; i++) {
        HBDataItem * item3 = [[HBDataItem alloc] initWithURL:[NSURL URLWithString:urlStr[i]] dataType:HBDataTypeIMAGE];
        item3.dataURL = [NSURL URLWithString:urlStr[i]];
        item3.orignalSize = 2048 + arc4random() % 3000;//随便写的
        item3.thumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView&thumbnail=150z150",urlStr[i]]];
        [self.dataArray addObject:item3];
    }
    
    [self.collectionView reloadData];
}

- (void) clearCache:(id) sender {
    //清除缓存
//    [KTVHTTPCache cacheDeleteAllCaches];
//    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
//      //
//    }];
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HBExampleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HBExampleCell class]) forIndexPath:indexPath];
    HBDataItem * item = self.dataArray[indexPath.item];
    [cell refreshCell:item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray * tempArr = [NSMutableArray array];

    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        NSIndexPath * indexP = [NSIndexPath indexPathForRow:idx inSection:0];
        HBExampleCell * cell = (HBExampleCell *)[collectionView cellForItemAtIndexPath:indexP];

        HBDataItem * item = (HBDataItem *) obj;
        //有dimiss动画 不传没有dismiss动画
        item.translationView = cell.imageView;
        
        //just do it 
        if (idx == indexPath.item && item.dataType == HBDataTypeVIDEO) {
            item.isJustCurrentIndexNeedAutoPlay = YES;
        }

        [tempArr addObject:item];
    }];

    HBPhotoVideoBrowserViewController * browserCtl = [HBPhotoVideoBrowserViewController new];
    browserCtl.dataSourceArray = tempArr;
    browserCtl.currentIndex = indexPath.item;
    [self presentHBViewController:browserCtl animated:YES completion:nil];
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(100, 100);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
