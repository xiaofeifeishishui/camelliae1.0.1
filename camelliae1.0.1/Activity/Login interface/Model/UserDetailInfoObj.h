//
//  UserDetailInfoObj.h
//  CAMELLIAE
//
//  Created by 张越 on 16/4/5.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface UserDetailInfoObj : BaseResultObj

@property (nonatomic,strong) NSNumber *emailVerified;

@property (nonatomic,strong) NSNumber *gender;

@property (nonatomic,copy) NSString *gravatar;

@property (nonatomic,strong) NSNumber *isAdmin;

@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,copy) NSString *openId;

@property (nonatomic,strong) NSNumber *openIdType;

@property (nonatomic,strong) NSNumber *uid;

@property (nonatomic,copy) NSString *userRealName;

@property (nonatomic,strong) NSNumber *userStatus;

@property (nonatomic,strong) NSNumber *memberLevel;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,strong) NSNumber *birthday;

@property (nonatomic,strong) NSNumber *userPoints;

@end
