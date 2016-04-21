//
//  CMLServeModuleModel.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/22.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLServeModuleModel.h"

@implementation CMLServeModuleModel

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        [self getServeModuleModelFromInternet];
    }
    return self;
}

/**加网络请求*/
- (void)getServeModuleModelFromInternet{
    
    self.serveTourName = nil;
    self.serveTourTime = nil;
    self.serveID   = nil;
    
}

@end
