//
//  BaseResultObj.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/24.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"
#import "MJExtension.h"

@implementation BaseResultObj

+ (instancetype) getBaseObjFrom:(id)json{
    NSDictionary *jsonDic = (NSDictionary *)json;
    return [self objectWithKeyValues:jsonDic];
}
@end
