//
//  ActivityObj.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/27.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface ActivityObj : BaseResultObj

@property (nonatomic,strong) NSNumber *actBeginTime;

@property (nonatomic,strong) NSNumber *actEndTime;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *favNum;

@property (nonatomic,strong) NSNumber *freeJoin;

@property (nonatomic,strong) NSNumber *hitNum;

@property (nonatomic,strong) NSNumber *activityID;

@property (nonatomic,strong) NSNumber *joinNum;

@property (nonatomic,strong) NSNumber *memberLevelId;

@property (nonatomic,strong) NSNumber *memberLimit;

@property (nonatomic,strong) NSNumber *publishDate;

@property (nonatomic,strong) NSNumber *shareNum;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSNumber *typeId;

@property (nonatomic,copy) NSString *typeName;

@property (nonatomic,strong) NSNumber *isWebView;

@property (nonatomic,copy) NSString *webViewLink;

@property (nonatomic,copy) NSString *shortTitle;

@end
