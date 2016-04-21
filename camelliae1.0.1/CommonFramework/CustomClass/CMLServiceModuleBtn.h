//
//  CMLServiceModuleBtn.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/21.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMLServeModuleModel;
@interface CMLServiceModuleBtn : UIView


@property (nonatomic,strong) CMLServeModuleModel *serveModuleModel;

/**刷新控件*/
- (void) refreshBtn;
@end
