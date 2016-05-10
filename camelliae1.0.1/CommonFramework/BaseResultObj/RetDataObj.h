//
//  RetDataObj.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/27.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@class UserDetailInfoObj;

@interface RetDataObj : NSObject

@property (nonatomic,strong) NSNumber *isLogin;

@property (nonatomic,copy) NSString *sKey;

@property (nonatomic,copy) NSString *skey;

@property (nonatomic,strong) UserDetailInfoObj *userInfo;

@property (nonatomic,strong) UserDetailInfoObj *user;

@property (nonatomic,strong) NSArray *objList;

@property (nonatomic,copy) NSString *objTitle;

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,strong) NSArray *dataList;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *typeId;

@property (nonatomic,strong) NSNumber *typeName;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *memberLevelId;

@property (nonatomic,strong) NSNumber *freeJoin;

@property (nonatomic,strong) NSNumber *memberLimit;

@property (nonatomic,strong) NSNumber *joinNum;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,strong) NSNumber *actBeginTime;

@property (nonatomic,strong) NSNumber *actEndTime;

@property (nonatomic,strong) NSNumber *hitNum;

@property (nonatomic,strong) NSNumber *favNum;

@property (nonatomic,strong) NSNumber *shareNum;

@property (nonatomic,strong) NSNumber *publishDate;

@property (nonatomic,strong) NSNumber *isUserSubscribe;

@property (nonatomic,strong) NSNumber *isUserFav;

@property (nonatomic,strong) NSNumber *mobile;

@property (nonatomic,copy) NSString *telephone;

@property (nonatomic,strong) NSNumber *awardPoints;

@property (nonatomic,strong) NSNumber *isHasTimeZone;

@property (nonatomic,strong) NSNumber *payMode;

@property (nonatomic,copy) NSString *projectAddress;

@property (nonatomic,strong) NSNumber *projectBeginTime;

@property (nonatomic,strong) NSNumber *projectEndTime;

@property (nonatomic,copy) NSString *projectContact;

@property (nonatomic,strong) NSNumber *projectMemberLimit;

@property (nonatomic,strong) NSNumber *projectThemeObjId;

@property (nonatomic,strong) NSNumber *projectThemeTypeId;

@property (nonatomic,copy) NSString *projectThemeTypeName;

@property (nonatomic,strong) NSNumber *projectTypeId;

@property (nonatomic,copy) NSString *projectTypeName;

@property (nonatomic,strong) NSNumber *subscription;

@property (nonatomic,strong) NSNumber *totalAmount;

@property (nonatomic,copy) NSString *shareLink;

@property (nonatomic,copy) NSString *uploadBucket;

@property (nonatomic,copy) NSString *uploadKeyName;

@property (nonatomic,copy) NSString *upToken;

@property (nonatomic,strong) NSNumber *isAllowApply;

@property (nonatomic,copy) NSString *shortTitle;

@property (nonatomic,strong) NSNumber *sysOrderStatus;

@property (nonatomic,copy) NSString *sysOrderStatusName;

@property (nonatomic,copy) NSString *orderViewLink;

@property (nonatomic,strong) NSNumber *sysApplyStatus;

@property (nonatomic,copy) NSString *sysApplyStatusName;

@property (nonatomic,copy) NSString *actionViewLink;


@end
