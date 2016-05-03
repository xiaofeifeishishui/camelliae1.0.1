//
//  HomeVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/24.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "HomeVC.h"
#import "CommonNumber.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "AppGroup.h"
#import "NetWorkTask.h"
#import "NetConfig.h"
#import "BaseResultObj.h"
#import "DataManager.h"
#import "NSString+CMLExspand.h"
#import "VCManger.h"
#import "UIColor+SDExspand.h"

#define TabBarViewHeight         98
#define TabBarItemLeftAndRightMargin 80


@interface HomeVC ()<UITabBarControllerDelegate,NetWorkProtocol>

@property (nonatomic,strong) UIViewController *currentVC;

@property (nonatomic,assign) HomeTag selectedTag;
@property (nonatomic,assign) NSInteger selectedNum;
@property (nonatomic,strong) UserDetailInfoObj *userInfo;
@property (nonatomic,strong) UIImageView *backgroundImg;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;

@end

@implementation HomeVC

- (instancetype)init{

    self = [super init];
    
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{

    [super viewDidLoad];
    self.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.backgroundImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:KEnterAppImg]];
    self.backgroundImg.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.backgroundImg.userInteractionEnabled = YES;
    UIGestureRecognizer *singleTap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked)];
    [self.backgroundImg addGestureRecognizer:singleTap];
    self.backgroundImg.hidden = NO;
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.activityView.center = self.view.center;
    self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.backgroundImg];
    self.backgroundImg.alpha = 0;
    [UIView animateWithDuration:1 animations:^{
        self.backgroundImg.alpha = 1;
    }];
    [self.view addSubview:self.activityView];
    
    [self APPStartupNetWork];
   
    
}

- (void) initializationHomeVC{

    /**服务*/
    self.serveVC = [[CMLServeVC alloc] init];

    
    /**活动*/
    self.exerciseVC = [[CMLActivityAndInfoVC alloc] init];
    self.exerciseVC.userInfo = self.userInfo;
    /**会员*/
    self.infomationVC = [[CMLInformationVC alloc] init];
    
    
    self.viewControllers = @[self.exerciseVC,self.serveVC,self.infomationVC];
    
    
    /**自定义tabbar*/
    self.tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               self.view.frame.size.height - TabBarViewHeight*Proportion,
                                                               self.view.frame.size.width,
                                                               TabBarViewHeight*Proportion)];
    self.tabBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:KTabBarBgImg]];
    [self.view bringSubviewToFront:self.tabBarView];
    [self.view addSubview:self.tabBarView];
    
    
    /**设置按键*/
    NSArray *imgArray = @[KExerciseAndConsultLightImg,
                          KServeLightImg,KVIPLightImg,
                          KExerciseAndConsultDarkImg,
                          KServeDarkImg,KVIPDarkImg];
    NSArray *titleArray = @[@"活动",@"服务",@"会员"];
    
    CGFloat itemSpace = (self.view.frame.size.width - 3*TabBarViewHeight*Proportion - TabBarItemLeftAndRightMargin*Proportion*2)/2;
    for (int i = 0; i < 3; i++) {
        UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(TabBarItemLeftAndRightMargin*Proportion
                                                                     +(TabBarViewHeight*Proportion+itemSpace)*i,
                                                                     0,
                                                                     TabBarViewHeight*Proportion,
                                                                     TabBarViewHeight*Proportion)];
        [button setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:imgArray[i+3]] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(-30*Proportion, 0, 0, 0)];
        button.titleLabel.font = KSystemFontSize11;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = titleArray[i];
        label.font = KSystemFontSize11;
        [label sizeToFit];
        label.frame = CGRectMake(button.center.x-label.frame.size.width/2.0, CGRectGetMaxY(button.imageView.frame) +10*Proportion, label.frame.size.width, label.frame.size.height);
        label.tag = (i+1)*10;
        label.textColor = [UIColor whiteColor];
        [self.tabBarView addSubview:label];
        button.tag = i+1;
        [self.tabBarView addSubview:button];
        [button addTarget:self action:@selector(changeVC:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    [self showCurrentViewController:homeexerciseTag];

}

- (void) showCurrentViewController:(HomeTag) tag{

    switch (tag) {
        case homeexerciseTag:
            self.selectedViewController = self.exerciseVC;
            self.currentVC = self.exerciseVC;
            self.selectedNum =1;
            break;
        case homeserveTag:
            self.selectedViewController = self.serveVC;
            self.currentVC = self.serveVC;
            self.selectedNum = 2;
            break;
        case homeinfomationTag:
            self.selectedViewController = self.infomationVC;
            self.currentVC = self.infomationVC;
            self.selectedNum =3;
            break;
            
        default:
            break;
    }
    [self setButtonState:self.selectedNum];

}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    self.currentVC = viewController;
    return YES;
}


/**隐藏地底部tabbar*/
- (void) hideTabBarView{
    
    [UIView animateWithDuration:AnimateWithDuration animations:^{
        self.tabBarView.frame = CGRectMake(-MovingDistance*4,
                                       self.view.frame.size.height - TabBarViewHeight*Proportion,
                                       self.view.frame.size.width,
                                       TabBarViewHeight*Proportion);
    } completion:^(BOOL finished) {
        
    }];
}

/**显现底部tabbar*/
- (void) appearTabBarView{
    
    [UIView animateWithDuration:AnimateWithDuration animations:^{
        self.tabBarView.frame = CGRectMake(0,
                                       self.view.frame.size.height - TabBarViewHeight*Proportion,
                                       self.view.frame.size.width,
                                       TabBarViewHeight*Proportion);
    } completion:^(BOOL finished) {
        
    }];
    
}


#pragma mark - changeVC

- (void) changeVC:(UIButton *) button{
    
    [self setButtonState:button.tag];
    [self setCurrnetVC:button.tag];
    

}

- (void) setButtonState:(NSInteger) num{

    
    for (int i = 1;  i <= 3 ; i ++) {
        UIButton *button = [self.tabBarView viewWithTag:i];
        UILabel *label = [self.tabBarView viewWithTag:i*10];

        if (num == i) {
            button.selected =YES;
            label.textColor = [UIColor whiteColor];
        }else{
            button.selected = NO;
            label.textColor = [UIColor CMLTabBarItemGrayColor];
        }
    }

}

- (void) setCurrnetVC:(NSUInteger) num{

    switch (num) {
        case 1:
            self.selectedViewController = self.exerciseVC;
            self.currentVC = self.exerciseVC;
            self.selectedNum =1;
            break;
        case 2:
            self.selectedViewController = self.serveVC;
            self.currentVC = self.serveVC;
            self.selectedNum = 2;
            break;
        case 3:
            self.selectedViewController = self.infomationVC;
            self.currentVC = self.infomationVC;
            self.selectedNum =3;
            break;
            
        default:
            break;
    }
    
}

- (void)APPStartupNetWork{
    
    [self.activityView startAnimating];
    
    if ([[DataManager lightData] readCityID]) {
        
    }else{
       [[DataManager lightData] saveCityID:[NSNumber numberWithInt:9]];
    }
    
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSString *skey = [[DataManager lightData] readSkey];
    if (skey) {
        [paraDic setObject:skey forKey:@"skey"];
    }else{
        [paraDic setObject:@"" forKey:@"skey"];
    }
    
    [paraDic setObject:[AppGroup appType] forKey:@"clientType"];
    [paraDic setObject:[AppGroup deviceUUID] forKey:@"imei"];
    [paraDic setObject:[AppGroup deviceSystem] forKey:@"osInfo"];
    [paraDic setObject:[AppGroup appVersion] forKey:@"curAppVersion"];
    
    NSString *enString =[NSString getEncryptStringfrom:@[[AppGroup appType],[AppGroup deviceUUID]]];
    [paraDic setObject:enString forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:AppStarting paraDic:paraDic delegate:delegate];
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    BaseResultObj *resObj = [BaseResultObj getBaseObjFrom:responseResult];
    [[DataManager lightData] saveSkey:resObj.retData.sKey];
    [[DataManager lightData]saveUserID:resObj.retData.userInfo.uid];
    [[DataManager lightData] saveUserName:resObj.retData.userInfo.userRealName];
    [[DataManager lightData]savePhone:resObj.retData.userInfo.mobile];
    [[DataManager lightData] saveUserLevel:resObj.retData.userInfo.memberLevel];
    [[DataManager lightData] saveUserPoints:resObj.retData.userInfo.userPoints];
    
    self.userInfo = resObj.retData.userInfo;
    
    if ([resObj.retData.isLogin intValue] == 0) {
        
        [self performSelector:@selector(enterMainVC) withObject:nil afterDelay:1.5];
        
    }else{
        
        [self performSelector:@selector(enterLoginVC) withObject:nil afterDelay:1.5];
        
    }
    
    [self.activityView stopAnimating];
    
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
 
    [self.activityView stopAnimating];
    
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"" message:@"网络连接错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alterView show];
    
}

- (void) refreshController{

    [self APPStartupNetWork];
}

#pragma mark - UesrClicked

- (void) UesrClicked{

    [self APPStartupNetWork];
}

#pragma mark - hiddenBackgroundImage

- (void) enterMainVC {

    self.backgroundImg.hidden = YES;
    [[VCManger mainVC] pushVC:[VCManger loginVC] animate:NO];

}

#pragma mark - enterLoginVC
- (void)enterLoginVC {
     self.backgroundImg.hidden = YES;
    [self initializationHomeVC];
}
@end
