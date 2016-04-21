//
//  VCController.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    pushStyle,
    presentStyle
}navStyle;

@interface VCController :UINavigationController

@property (nonatomic,assign)  navStyle style;

//清除根视图之后的视图
- (void)clearControllerArray;

//控制器进入
- (void)pushVC:(UIViewController *)controller animate:(BOOL)flag;

- (void)presentVC:(UIViewController *)controller animated:(BOOL)flag;

//控制器推出
- (void)dismissCurrentVC;

//
- (void) dismissCurrentVCWithAnimate:(BOOL)flag;
//跳转到某一个视图
- (void)popToVC:(UIViewController *)controller animated:(BOOL)flag;

//回到根视图
- (void)popToRootVC;

//当前的控制前
- (UIViewController *)topVC;
@end
