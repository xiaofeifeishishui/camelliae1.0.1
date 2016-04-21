//
//  CMLSysNoticeObj.h
//  CAMELLIAE
//
//  Created by 张越 on 16/4/10.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface CMLSysNoticeObj : BaseResultObj

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,strong) NSNumber *currentID;

@property (nonatomic,strong) NSNumber *publishDate;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *content;

@end
