//
//  AppDelegate.m
//  ListeningStory
//
//  Created by 丁伟 on 15/11/19.
//  Copyright (c) 2015年 丁伟. All rights reserved.
//ll

#import "AppDelegate.h"

#import "UMSocial.h"
//#import "UMSocialWechatHandler.h"

#import "MMDrawerController.h"
#import "HomePageViewController.h"
#import "OtherUsefulItemsViewController.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HIGHT [UIScreen mainScreen].bounds.size.height

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //抽屉效果
    //初始化中心视图
    HomePageViewController *homePageviewController = [[HomePageViewController alloc]init];
    UINavigationController * boutiqueNC = [[UINavigationController alloc] initWithRootViewController:homePageviewController];
    
    //初始化左视图
    OtherUsefulItemsViewController * leftVC = [[OtherUsefulItemsViewController alloc] init];
    
    //Block回调，传入数据模型
    leftVC.getDataListBlock(homePageviewController.modelList);
    
    UINavigationController * leftNC = [[UINavigationController alloc] initWithRootViewController:leftVC];

    
    //初始化抽屉视图控制器
    MMDrawerController * drawerController = [[MMDrawerController alloc] initWithCenterViewController:boutiqueNC leftDrawerViewController:leftNC];
    
    //设置抽屉抽出的宽度
    drawerController.maximumLeftDrawerWidth = WIDTH -50;
    
    //滑动手势快关抽屉
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    self.window.rootViewController = drawerController;
    self.window.backgroundColor = [UIColor whiteColor];
    
//    //友盟分享
    [UMSocialData setAppKey:@"56584ab1e0f55a13dd003651"];
//    //设置微信AppId、appSecret，分享url
//    [UMSocialWechatHandler setWXAppId:@"" appSecret:@"" url:@"http://www.umeng.com/social"];

    
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    [session setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    NSError *activationError = nil;
    [session setActive:YES error:&activationError];
    
    
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    BOOL result = [UMSocialSnsService handleOpenURL:url];
//    if (result == FALSE) {
//        //调用其他SDK，例如支付宝SDK等
//    }
//    return result;
//}
@end
