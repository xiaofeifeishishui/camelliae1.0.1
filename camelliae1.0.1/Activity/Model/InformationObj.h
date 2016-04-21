//
//  InformationObj.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/27.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface InformationObj : BaseResultObj

@property (nonatomic,strong) NSNumber *typeId;

@property (nonatomic,copy) NSString *typeName;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,copy) NSString *briefIntro;

@end
