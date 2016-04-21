//
//  CMLVIPDetailVC.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/30.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLBaseVC.h"

typedef enum {

    VIPRankOfPink,
    VIPRankOfPurple,
    VIPRankGold,
    VIPRankLnk

} VIPRank;

@interface CMLVIPDetailVC : CMLBaseVC

@property (nonatomic,assign) VIPRank currentRank;

@end
