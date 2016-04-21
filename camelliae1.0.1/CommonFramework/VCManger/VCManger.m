//
//  VCManger.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "VCManger.h"
#import <UIKit/UIKit.h>


@implementation VCManger

static VCManger *manger          = nil;
static VCController *controller  = nil;
static HomeVC *homeVC            = nil;
static LoginMangerVC *loginManagerVC = nil;
static CMLLoginInterfaceVC *loginVC = nil;

+ (instancetype) shareMangaer{

    if (manger == nil) {
        static dispatch_once_t oneToken;
        dispatch_once(&oneToken, ^{
            manger = [[VCManger alloc] init];
        });
    }
    return manger;
}

/**全局导航控制器*/
+ (VCController *) mainVC{

    if (controller == nil) {
        static dispatch_once_t oneToken;
        dispatch_once(&oneToken, ^{
            UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [window makeKeyAndVisible];
            [[UIApplication sharedApplication].delegate setWindow:window];
            controller = [[VCController alloc] init];
            controller.view.frame = window.bounds;
            window.rootViewController = controller;
            [window makeKeyAndVisible];
        
        });
    }
    return controller;
}

/**主页面*/
+ (HomeVC *) homeVC{

    if (homeVC == nil) {
        static dispatch_once_t oneToken;
        dispatch_once(&oneToken, ^{
            homeVC = [[HomeVC alloc] init];
        });
    }
    return homeVC;
}

/**控制器管理器*/

+ (LoginMangerVC *) loginMangerVC{

    if (loginManagerVC == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            loginManagerVC = [[LoginMangerVC alloc] init];
            loginVC = [[CMLLoginInterfaceVC alloc] init];
            [loginManagerVC pushVC:loginVC animate:NO];
            
        });
    }
    
    return loginManagerVC;

}

/**登录界面*/
+ (CMLLoginInterfaceVC *) loginVC{

    if (loginVC == nil) {
        static dispatch_once_t oneToken;
        dispatch_once(&oneToken, ^{
            loginVC = [[CMLLoginInterfaceVC alloc] init];
        });
    }
    return loginVC;
}
@end
