//
//  AppointmentServeObj.h
//  CAMELLIAE
//
//  Created by 张越 on 16/4/11.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface AppointmentServeObj : BaseResultObj

@property (nonatomic,strong) NSNumber *awardPoints;

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *favNum;

@property (nonatomic,strong) NSNumber *hitNum;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *isDeleted;

@property (nonatomic,copy) NSString *projectAddress;

@property (nonatomic,strong) NSNumber *isHasTimeZone;

@property (nonatomic,strong) NSNumber *orderStatus;

@property (nonatomic,strong) NSNumber *payMode;

@property (nonatomic,strong) NSNumber *projectBeginTime;

@property (nonatomic,strong) NSNumber *projectEndTime;

@property (nonatomic,strong) NSNumber *projectMemberLimit;

@property (nonatomic,copy) NSString *projectContact;

@property (nonatomic,strong) NSNumber *projectThemeObjId;

@property (nonatomic,strong) NSNumber *projectThemeTypeId;

@property (nonatomic,copy) NSString *projectThemeTypeName;

@property (nonatomic,strong) NSNumber *projectTypeId;

@property (nonatomic,copy) NSString *projectTypeName;

@property (nonatomic,strong) NSNumber *publishDate;

@property (nonatomic,strong) NSNumber *shareNum;

@property (nonatomic,strong) NSNumber *subscription;

@property (nonatomic,strong) NSNumber *totalAmount;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *typeName;

@property (nonatomic,strong) NSNumber *typeId;

@end
