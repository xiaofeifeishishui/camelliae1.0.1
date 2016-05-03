//
//  PushTransition.m
//  camelliae1.0.1
//
//  Created by 张越 on 16/5/1.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "PushTransition.h"

@implementation PushTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    //返回动画的执行时间
    return 0.5f;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //不添加的话，屏幕什么都没有
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];

    
//    CGRect originRect = CGRectMake(0, 0, 50, 50);
//    
//    UIBezierPath *maskStartPath = [UIBezierPath bezierPathWithOvalInRect:originRect];
//    UIBezierPath *maskEndPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(originRect, -2000, -2000)];
//    
//    //创建一个CAShapeLayer来负责展示圆形遮盖
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    //    maskLayer.path = maskEndPath.CGPath;//将他的path指定为最终的path，来避免在动画完成后回弹
//    toVC.view.layer.mask = maskLayer;
//    
//    CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
//    maskAnimation.fromValue = (id)maskStartPath.CGPath;
//    maskAnimation.toValue = (id)maskEndPath.CGPath;
//    maskAnimation.duration = [self     transitionDuration:transitionContext];
//    maskAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    maskAnimation.fillMode = kCAFillModeForwards;
//    maskAnimation.removedOnCompletion = NO;
//    maskAnimation.delegate = self;
//    [maskLayer addAnimation:maskAnimation forKey:@"Path"];
    
//    NSTimeInterval duration = [self transitionDuration:transitionContext];
//    CGRect screenBounds = [[UIScreen mainScreen]bounds];
//    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
//    toVC.view.frame = CGRectOffset(finalFrame, 0, screenBounds.size.height);
//    
//    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        toVC.view.frame = finalFrame;
//    } completion:^(BOOL finished) {
//        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//    }];
    
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"cube";
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;

       [fromVC.navigationController.view.layer addAnimation:transition forKey:nil];
    
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
}

@end
