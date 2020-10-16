//
//  AppDelegate.m
//  HBPhotoVideoBrowser
//
//  Created by hubin on 2020/10/6.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <SDWebImageWebPCoder/SDWebImageWebPCoder.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //https://www.jianshu.com/p/9e3eec3d8fe0
    [[SDImageCodersManager sharedManager] addCoder:[SDImageWebPCoder sharedCoder]];
    //[[SDImageCodersManager sharedManager] addCoder:[SDImageGIFCoder sharedCoder]];
    [[SDWebImageDownloader sharedDownloader] setValue:@"image/webp,image/apng,image/*,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyWindow];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
