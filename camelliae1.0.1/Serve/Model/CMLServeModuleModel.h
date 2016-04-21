//
//  CMLServeModuleModel.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/22.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMLServeModuleModel : NSObject

/**服务旅游名称*/
@property (nonatomic,copy) NSString *serveTourName;

/**服务旅游时间*/
@property (nonatomic,copy) NSString *serveTourTime;

/**服务ID*/
@property (nonatomic,strong) NSNumber *serveID;

@property (nonatomic,copy) NSString *imageUrl;

@end
