//
//  ExerciseVC.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/24.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLBaseVC.h"
#import "UserDetailInfoObj.h"
typedef enum {

    NewsListRequest,
    ActivityListRequest

} RequestType;


@interface CMLActivityAndInfoVC : CMLBaseVC

@property (nonatomic,strong) UserDetailInfoObj *userInfo;

@end
