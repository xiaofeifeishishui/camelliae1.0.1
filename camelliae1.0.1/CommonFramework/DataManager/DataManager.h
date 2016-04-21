//
//  DataManager.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/18.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LightDataController.h"

@interface DataManager : NSObject
/**轻量级存储*/
+ (LightDataController *) lightData;
@end
