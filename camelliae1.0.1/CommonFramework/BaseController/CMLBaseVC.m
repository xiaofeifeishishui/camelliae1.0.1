//
//  CMLBaseVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLBaseVC.h"
#import "CMLNavigationBar.h"
#import "CommonNumber.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "CMLCustomAlterView.h"
#import "CMLShareModel.h"
#import "PushTransition.h"
#import "PopTransition.h"

#define NoDataImageHeightAndWidth  147
#define StateBarHeight             20
#define TitleTopMargin             20

#define LoadingViewHeightAndWidth  80

#define AlterViewTitleTopMargin    30
#define AlterViewTextLeftAndRightMargin  100
#define AlterViewTitleAndTextSpace       30
#define AlterViewTextBottomMargin        30


@interface CMLBaseVC ()<CMLALterViewDelegate,UINavigationControllerDelegate>

/**移动方向*/
@property (nonatomic,assign) MovementDirection direction;

@property (nonatomic,strong) UIView *coverView;

@property (nonatomic,strong) UIImageView *notDataImage;

@property (nonatomic,strong) UILabel *noDataLabel;

@property (nonatomic,strong) UIView *loadingView;

@property (nonatomic,strong) UIImageView *loadingImage;


@end

@implementation CMLBaseVC

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    self.navigationController.delegate = self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    /**底层图*/
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                StateBarHeight,
                                                                self.view.frame.size.width,
                                                                self.view.frame.size.height - StateBarHeight)];
    self.contentView.backgroundColor = [UIColor CMLVIPGrayColor];

    [self.view bringSubviewToFront:self.contentView];
    [self.view addSubview:self.contentView];
    
    /**navBar*/
    self.navBar = [[CMLNavigationBar alloc] init];
    self.navBar.navigationBarDelegate = self;
    [self.contentView addSubview:self.navBar];
    
    /**no data*/
    self.notDataImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:KNotDataBackgroundImg]];
    self.notDataImage.frame = CGRectMake(0,
                                         0,
                                         NoDataImageHeightAndWidth*Proportion,
                                         NoDataImageHeightAndWidth*Proportion);
    self.notDataImage.center = self.contentView.center;
    self.notDataImage.hidden = YES;
    [self.contentView addSubview:self.notDataImage];
    
    self.noDataLabel = [[UILabel alloc] init];
    self.noDataLabel.textColor = [UIColor grayColor];
    self.noDataLabel.text = @"暂无数据";
    self.noDataLabel.font = KSystemFontSize12;
    [self.noDataLabel sizeToFit];
    self.noDataLabel.frame = CGRectMake(0, 0, self.noDataLabel.frame.size.width, self.noDataLabel.frame.size.height);
    self.noDataLabel.center = CGPointMake(self.view.frame.size.width/2.0, self.notDataImage.center.y + self.noDataLabel.frame.size.height/2.0 + self.notDataImage.frame.size.height/2.0 + TitleTopMargin*Proportion);
    self.noDataLabel.hidden = YES;
    [self.contentView addSubview:self.noDataLabel];
    
    
    /**loading*/
    
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                LoadingViewHeightAndWidth*Proportion,
                                                                LoadingViewHeightAndWidth*Proportion)];
    self.loadingView.center = self.contentView.center;
    self.loadingView.backgroundColor = [UIColor clearColor];
    self.loadingView.hidden = YES;
    [self.contentView addSubview:self.loadingView];
    
    
    self.loadingImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      LoadingViewHeightAndWidth*Proportion,
                                                                      LoadingViewHeightAndWidth*Proportion)];
    self.loadingImage.image = [UIImage imageNamed:KLoginTwoBGImg];
    [self.loadingView addSubview:self.loadingImage];
    [[UIApplication sharedApplication].keyWindow addSubview:self.loadingView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.loadingView];
    
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated ];
    
    [self stopLoading];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -

- (void) moveContentViewWith:(MovementDirection) direction{

    if (self.direction ==LeftMovementDirection) {
        [UIView animateWithDuration:AnimateWithDuration animations:^{
            
            self.contentView.frame =CGRectMake(-(MovingDistance*4),
                                               StateBarHeight,
                                               self.view.frame.size.width,
                                               self.view.frame.size.height - StateBarHeight);
            
            
        } completion:^(BOOL finished) {
            
            self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MovingDistance, self.view.frame.size.height)];
            self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
            [self.view addSubview:self.coverView];
            [self.view bringSubviewToFront:self.coverView];

        }];
    }else{
    
        [UIView animateWithDuration:AnimateWithDuration animations:^{
            
            self.contentView.frame =CGRectMake(self.view.frame.size.width/3*2,
                                               StateBarHeight,
                                               self.view.frame.size.width,
                                               self.view.frame.size.height - StateBarHeight);
            
        } completion:^(BOOL finished) {
         
        }];
    }
}


- (void) reductionContentPlace{

    
    [self.coverView removeFromSuperview];
    
    [UIView animateWithDuration:AnimateWithDuration animations:^{
     
        self.contentView.frame =CGRectMake(0,
                                           StateBarHeight,
                                           self.view.frame.size.width,
                                           self.view.frame.size.height - StateBarHeight);

    } completion:^(BOOL finished) {
       
    }];
    
}

- (void) showNotData{

    self.noDataLabel.hidden = NO;
    self.notDataImage.hidden = NO;

}

- (void) hiddenNotData{

    self.noDataLabel.hidden = YES;
    self.notDataImage.hidden = YES;

}

- (void)startLoading{

    self.loadingView.hidden = NO;
    [self.loadingImage.layer removeAllAnimations];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [self.loadingImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    

}
- (void)stopLoading{

    [UIView animateWithDuration:1 delay:3 options:UIViewAnimationOptionAllowUserInteraction animations:^{
    
        
        
    } completion:^(BOOL finished) {
        self.loadingView.hidden = YES;
       [self.loadingImage.layer removeAllAnimations];

    }];
}

- (void) showAlterViewWithText:(NSString *) text{

    CMLCustomAlterView *alterView = [[CMLCustomAlterView alloc] init];
    [alterView setButtonTitles:@[@"确定"]];
    alterView.delegate = self;
    alterView.containerView = [self setShowInfoViewWithText:text];
    [alterView setUseMotionEffects:true];
    [alterView show];

}

- (void)customDialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    [alertView close];
}

- (UIView *) setShowInfoViewWithText:(NSString *) text{

    UIView *view = [[UIView alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"提示信息";
    titleLabel.font = KSystemFontSize15;
    titleLabel.textColor = [UIColor blackColor];
    [titleLabel sizeToFit];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = text;
    textLabel.font = KSystemFontSize13;
    [textLabel sizeToFit];
    
    if (textLabel.frame.size.width > titleLabel.frame.size.width) {
        view.frame = CGRectMake(0,
                                0,
                                textLabel.frame.size.width + AlterViewTextLeftAndRightMargin*Proportion,
                                (AlterViewTitleTopMargin + AlterViewTitleAndTextSpace + AlterViewTextBottomMargin )*Proportion + textLabel.frame.size.height + titleLabel.frame.size.height);
    }else{
    
        view.frame = CGRectMake(0,
                                0,
                                titleLabel.frame.size.width + AlterViewTextLeftAndRightMargin*Proportion,
                                (AlterViewTitleTopMargin + AlterViewTitleAndTextSpace + AlterViewTextBottomMargin )*Proportion + textLabel.frame.size.height + titleLabel.frame.size.height);
    }
    
    titleLabel.frame =  CGRectMake(0,
                                   0,
                                   titleLabel.frame.size.width,
                                   titleLabel.frame.size.height);
    titleLabel.center = CGPointMake(view.center.x, AlterViewTitleTopMargin*Proportion + titleLabel.frame.size.height/2.0);
    
    textLabel.frame = CGRectMake(0,
                                 0,
                                 textLabel.frame.size.width,
                                 textLabel.frame.size.height);
    textLabel.center =CGPointMake(titleLabel.center.x, (AlterViewTitleTopMargin + AlterViewTitleAndTextSpace)*Proportion + titleLabel.frame.size.height);
    [view addSubview:titleLabel];
    [view addSubview:textLabel];
    
    return view;

}

#pragma mark -UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        //返回我们自定义的效果
        return [[PushTransition alloc]init];
    }
    else if (operation == UINavigationControllerOperationPop){
        return [[PopTransition alloc]init];
    }
    //返回nil则使用默认的动画效果
    return nil;
}

@end
