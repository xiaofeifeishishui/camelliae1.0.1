//
//  CommentObj.h
//  camelliae1.0.1
//
//  Created by 张越 on 16/4/27.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "BaseResultObj.h"

@interface CommentObj : BaseResultObj

@property (nonatomic,copy) NSString *comment;

@property (nonatomic,copy) NSString *postTimeStr;

@property (nonatomic,copy) NSString *userHeadImg;

@property (nonatomic,copy) NSString *userNickName;

@end
