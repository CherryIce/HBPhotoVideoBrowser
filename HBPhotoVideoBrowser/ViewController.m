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
    
    
    HBDataItem * item = [[HBDataItem alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"0" ofType:@"jpg"]]];//[UIImage imageNamed:@"0.jpg"]
//    item.isLargeImage = true;
    [self.dataArray addObject:item];

    HBDataItem * item1 = [[HBDataItem alloc] initWithURL:[NSURL URLWithString:@"https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.mp4"] dataType:HBDataTypeVIDEO];
    [self.dataArray addObject:item1];
    
    NSArray * bdstr = @[
        @"https://t7.baidu.com/it/u=3930750564,2979238085&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=3522949495,3570538969&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=2878377037,2986969897&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=475796824,1397609323&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=3038817810,32670274&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=434014116,2108959724&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=3599814040,3941996722&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=1228769104,2124205022&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=7250731,2558867768&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=3095438862,2748439939&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=2697203538,2641245625&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=547145230,1874976249&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=2077212613,1695106851&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=186197108,3794526213&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=3439093793,987421329&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=2503552009,125094670&fm=193&f=GIF",
        @"https://t7.baidu.com/it/u=2252345745,242858644&fm=193&f=GIF",
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
        item.translationView = item.isLargeImage ? cell.largeImageView : cell.imageView;
        
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
