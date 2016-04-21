//
//  HomeVC.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/24.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLServeVC.h"
#import "CMLActivityAndInfoVC.h"
#import "CMLInformationVC.h"

typedef enum {

    homeserveTag,
    homeexerciseTag,
    homeinfomationTag

} HomeTag;

@interface HomeVC : UITabBarController

@property (nonatomic,strong) UIView *tabBarView;
@property (nonatomic,assign) BOOL tabBarHidden;

@property (nonatomic,strong) CMLServeVC *serveVC;
@property (nonatomic,strong) CMLActivityAndInfoVC *exerciseVC;
@property (nonatomic,strong) CMLInformationVC *infomationVC;


- (void) showCurrentViewController:(HomeTag) tag;

- (void) refreshController;

/**隐藏地底部tabbar*/
- (void) hideTabBarView;

/**显现底部tabbar*/
- (void) appearTabBarView;
@end
