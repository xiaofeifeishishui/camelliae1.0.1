//
//  VCManger.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCController.h"
#import "HomeVC.h"
#import "LoginMangerVC.h"
#import "CMLLoginInterfaceVC.h"

@interface VCManger : NSObject

/**全局导航控制器*/
+ (VCController *) mainVC;

/**主界面*/
+ (HomeVC *) homeVC;

/**控制器管理器*/

+ (LoginMangerVC *) loginMangerVC;

/**登录界面*/
+ (CMLLoginInterfaceVC *) loginVC;
@end
