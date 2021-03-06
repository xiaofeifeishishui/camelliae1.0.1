//
//  AppDelegate.m
//  camelliae1.0.1
//
//  Created by 张越 on 16/4/20.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "VCManger.h"
#import "DataManager.h"
#import "NetConfig.h"
#import "AppGroup.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "NSString+CMLExspand.h"
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
     [NSThread sleepForTimeInterval:1.0];
    [[VCManger mainVC] pushVC:[VCManger homeVC] animate:NO];

    [UMSocialData setAppKey:UMAppKey];
    [UMSocialWechatHandler setWXAppId:WeiXinAppID appSecret:WeiXinAppSecret url:@"http://www.camelliae.com"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaAppID
                                              secret:SinaAppSecret
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
     [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatTimeline,UMShareToWechatSession]];
    
    /**图片修改时间存储位置*/
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSLog(@"%@",[NSString getImagePlistPath]);
    if (![fileManager fileExistsAtPath:[NSString getImagePlistPath]]) {
        [[NSFileManager defaultManager] createFileAtPath:[NSString getImagePlistPath] contents:nil attributes:nil];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:@"values" forKey:@"keys"];
            [dic writeToFile:[NSString getImagePlistPath] atomically:YES];
    }
    
    
    return YES;
}

/**这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来*/
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用*/
- (void)applicationDidBecomeActive:(UIApplication *)application{
    [UMSocialSnsService  applicationDidBecomeActive];
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

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
