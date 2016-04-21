//
//  UserInitialInfoObj.h
//  CAMELLIAE
//
//  Created by 张越 on 16/4/5.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"
#import "UserDetailInfoObj.h"

@interface UserInitialInfoObj : BaseResultObj

@property (nonatomic,copy) NSString *skey;

@property (nonatomic,strong) UserDetailInfoObj *user;

@end
