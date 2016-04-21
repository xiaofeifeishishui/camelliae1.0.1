//
//  AppGroup.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "AppGroup.h"
#import "NSDate+CMLExspand.h"

@implementation AppGroup

+ (NSString*)deviceUUID{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString*)deviceSystemVersion{
    return [[UIDevice currentDevice] systemVersion]; 
}

+ (NSString*)deviceSystem{
    return [[UIDevice currentDevice] systemName] ;
}

+ (NSString*)deviceName{
    return [[[UIDevice currentDevice] model] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (NSNumber*)appType{
    return [NSNumber numberWithInt:1];
}

+ (NSString*)appVersion{
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
}

+ (NSString*)appName{
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleDisplayName"];
}

+ (NSString*)appBuildVersion{
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
}


/**获取ios时间戳*/
+ (int) getCurrentDate{
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    double reqTime = timeInterval;
    
    int time = reqTime;
    return time;
}
@end
