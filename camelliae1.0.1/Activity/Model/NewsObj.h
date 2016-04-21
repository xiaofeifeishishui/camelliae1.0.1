//
//  NewsObj.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/27.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface NewsObj : BaseResultObj

@property (nonatomic,copy) NSString *briefIntro;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *coverPic;

@property (nonatomic,strong) NSNumber *favNum;

@property (nonatomic,strong) NSNumber *hitNum;

@property (nonatomic,strong) NSNumber *newsID;

@property (nonatomic,strong) NSNumber *publishDate;

@property (nonatomic,strong) NSNumber *shareNum;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSNumber *typeId;

@property (nonatomic,copy) NSString *typeName;

@end
