//
//  BaseResultObj.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/24.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RetDataObj.h"
@class RetDataObj;

@interface BaseResultObj : NSObject

@property (nonatomic,strong) NSNumber *retCode;

@property (nonatomic,copy) NSString *retMsg;

@property (nonatomic,copy) NSString *retHtml;

@property (nonatomic,strong) RetDataObj *retData;


+ (instancetype) getBaseObjFrom:(id)json;

@end
