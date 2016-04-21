//
//  VCController.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "VCController.h"
@implementation VCController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.toolbarHidden = YES;
    self.navigationBar.hidden = YES;
}

//清除根视图之后的视图
- (void)clearControllerArray
{
    NSMutableArray *arrayTemp = [NSMutableArray arrayWithArray:self.viewControllers];
    NSMutableArray *deleteDataArray = [NSMutableArray array];
    for (NSInteger i = 1; i < self.viewControllers.count - 1; i++) {
        [deleteDataArray addObject:self.viewControllers[i]];
    }
    [arrayTemp removeObjectsInArray:deleteDataArray];
    [self setViewControllers:arrayTemp ];
}


- (void)pushVC:(UIViewController *)controller animate:(BOOL)flag
{
    self.style = pushStyle;
    [self pushViewController:controller animated:flag];
    
}

- (void)presentVC:(UIViewController *)controller animated:(BOOL)flag
{
    self.style = presentStyle;
    [self presentViewController:controller animated:flag completion:nil];
}


- (void)dismissCurrentVC
{
    
    switch (self.style) {
        case presentStyle:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case pushStyle:
            [self popViewControllerAnimated:YES];
        default:
            break;
    }
    
}
- (void) dismissCurrentVCWithAnimate:(BOOL)flag
{
    switch (self.style) {
        case presentStyle:
            [self dismissViewControllerAnimated:flag completion:nil];
            break;
        case pushStyle:
            [self popViewControllerAnimated:flag];
        default:
            break;
    }
}
//跳转到某一个视图
- (void)popToVC:(UIViewController *)controller animated:(BOOL)flag
{
    [self popToViewController:controller animated:flag];
}

//回到根视图
- (void)popToRootVC
{
    [self popToRootViewControllerAnimated:NO];
}

- (UIViewController *)topVC
{
    return [self topViewController];
}

@end
