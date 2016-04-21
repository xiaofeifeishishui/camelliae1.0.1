//
//  CMLLoginInterfaceVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/4/3.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLLoginInterfaceVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "CMLRegisterVC.h"
#import "VCManger.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "NSString+CMLExspand.h"
#import "UIColor+SDExspand.h"
#import "DataManager.h"
#import "AppGroup.h"
#import "BaseResultObj.h"
#import "CMLAlterCodeVC.h"

#define LOGOTopMargin             98
#define InputBackgroundHeight     484
#define InputBackgroundWidth      575
#define LOGOHeight                34
#define LOGOWidth                 266
#define InputFrameLeftMargin      51
#define InputFrameSpace           32
#define InputFrameTopMargin       46
#define LoginBtnBottomMargin      102
#define LoginBtnWidth             209
#define LoginBtnHeight            57

@interface CMLLoginInterfaceVC ()<NavigationBarDelegate,NetWorkProtocol>

@property (nonatomic,strong) UITextField *accountTextField;

@property (nonatomic,strong) UITextField *codeTextField;

@end

@implementation CMLLoginInterfaceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.backgroundColor = [UIColor blackColor];
    self.navBar.backgroundColor = [UIColor blackColor];
    self.navBar.titleColor = [UIColor CMLTitleYellowColor];
    self.navBar.titleContent = @"登录";
    self.navBar.navigationBarDelegate = self;
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.navBar.frame), self.view.frame.size.width, self.contentView.frame.size.height - self.navBar.frame.origin.y)];
    image.image = [UIImage imageNamed:KLoginBGImg];
    [self.contentView addSubview:image];
    self.view.backgroundColor = [UIColor blackColor];
    [self loadViews];
}


- (void) loadViews{

    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                                0,
                                                                                InputBackgroundWidth*Proportion,
                                                                                InputBackgroundHeight*Proportion)];
    backgroundImage.userInteractionEnabled = YES;
    backgroundImage.image = [UIImage imageNamed:KLoginVCBackGroundImg];
    backgroundImage.center = CGPointMake(self.contentView.center.x, self.contentView.center.y);
    [self.contentView addSubview:backgroundImage];
    
    /**set LOGO*/
    UIImageView *LOGOImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           LOGOWidth*Proportion,
                                                                           LOGOHeight*Proportion)];
    LOGOImage.image = [UIImage imageNamed:KLoginVCLoginLOGOImg];
    LOGOImage.center = CGPointMake(backgroundImage.frame.size.width/2.0, LOGOTopMargin*Proportion + LOGOImage.frame.size.height/2.0);
    [backgroundImage addSubview:LOGOImage];
    
    CGFloat inputHeight = (backgroundImage.frame.size.height - LOGOImage.frame.size.height - LOGOTopMargin*Proportion - InputFrameTopMargin*Proportion - LoginBtnBottomMargin*Proportion - InputFrameSpace*Proportion*2)/3.0;
    
    
    /**accountInput*/
    UIImageView *inputAccountBG = [[UIImageView alloc] initWithFrame:CGRectMake(InputFrameLeftMargin*Proportion,
                                                                                CGRectGetMaxY(LOGOImage.frame) + InputFrameTopMargin*Proportion,
                                                                                backgroundImage.frame.size.width - 2*InputFrameLeftMargin*Proportion,
                                                                                inputHeight)];
    inputAccountBG.image = [UIImage imageNamed:KLoginInputFrameImg];
    inputAccountBG.userInteractionEnabled = YES;
    [backgroundImage addSubview:inputAccountBG];
    
    UITextField *accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(1,
                                                                                  1,
                                                                                  inputAccountBG.frame.size.width - 2,
                                                                                  inputAccountBG.frame.size.height - 2)];
    accountTextField.placeholder = @"请输入手机号";
    accountTextField.keyboardType = UIKeyboardTypeNumberPad;
    accountTextField.clearButtonMode = UITextFieldViewModeAlways;
    accountTextField.font = KSystemFontSize12;
    accountTextField.textAlignment = NSTextAlignmentCenter;
    self.accountTextField =accountTextField;
    [inputAccountBG addSubview:accountTextField];
    
    
    
    /**codeInput*/
    UIImageView *inputCodeBG = [[UIImageView alloc] initWithFrame:CGRectMake(InputFrameLeftMargin*Proportion,
                                                                             CGRectGetMaxY(inputAccountBG.frame) + InputFrameSpace*Proportion,
                                                                             backgroundImage.frame.size.width - 2*InputFrameLeftMargin*Proportion,
                                                                             inputHeight)];
    inputCodeBG.image = [UIImage imageNamed:KLoginInputFrameImg];
    inputCodeBG.userInteractionEnabled = YES;
    [backgroundImage addSubview:inputCodeBG];
    
    UITextField *codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(1, 1, inputCodeBG.frame.size.width - 2, inputCodeBG.frame.size.height - 2)];
    codeTextField.placeholder = @"请输入密码";
    codeTextField.clearButtonMode = UITextFieldViewModeAlways;
    codeTextField.secureTextEntry = YES;
    codeTextField.font = KSystemFontSize12;
    codeTextField.textAlignment = NSTextAlignmentCenter;
    self.codeTextField =codeTextField;
    [inputCodeBG addSubview:codeTextField];
    
    
    /**loginBtn*/
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(InputFrameLeftMargin*Proportion,
                                                                    CGRectGetMaxY(inputCodeBG.frame) + InputFrameSpace*Proportion,
                                                                    LoginBtnWidth*Proportion,
                                                                    LoginBtnHeight*Proportion)];
    [loginBtn setImage:[UIImage imageNamed:KLoginVCOfLoginBtnImg] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(enterMainVC) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImage addSubview:loginBtn];
    
    
    /**registerBtn*/
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(backgroundImage.frame.size.width - (InputFrameLeftMargin + LoginBtnWidth) *Proportion,
                                                                       CGRectGetMaxY(inputCodeBG.frame) + InputFrameSpace*Proportion,
                                                                       LoginBtnWidth*Proportion,
                                                                       LoginBtnHeight*Proportion)];
    [registerBtn setImage:[UIImage imageNamed:KLoginVCOfRegisterBtnImg] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(enterRegisterVC) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImage addSubview:registerBtn];
    
    UIButton *ForgetPasswordBtn = [[UIButton alloc] initWithFrame:CGRectMake(loginBtn.frame.origin.x, backgroundImage.frame.size.height - LoginBtnHeight*Proportion, loginBtn.frame.size.width, LoginBtnHeight*Proportion)];
    [ForgetPasswordBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    ForgetPasswordBtn.titleLabel.font = KSystemFontSize12;
    ForgetPasswordBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [ForgetPasswordBtn addTarget:self action:@selector(enterAlterVC) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImage addSubview:ForgetPasswordBtn];
    
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - NavigationBarDelegate

- (void) didSelectedLeftBarItem{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}

#pragma mark - enterRegisterVC

- (void) enterRegisterVC{

    CMLRegisterVC *vc = [[CMLRegisterVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

- (void) enterMainVC{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.accountTextField.text forKey:@"mobile"];
    [paraDic setObject:self.codeTextField.text forKey:@"password"];
    [paraDic setObject:@"0" forKey:@"smsCode"];
    NSString *skey = [[DataManager lightData] readSkey];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.accountTextField.text,
                                                           skey,
                                                           @"0",
                                                           self.codeTextField.text]];
    
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    NSNumber *reqTime =[NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [NetWorkTask postResquestWithApiName:TelephoneLogin paraDic:paraDic delegate:delegate];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.accountTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    

}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    BaseResultObj *obj =[BaseResultObj getBaseObjFrom:responseResult];
    if ([obj.retCode intValue] == 0) {
        
        [[VCManger mainVC] dismissCurrentVCWithAnimate:NO];
        [[VCManger homeVC] viewDidLoad];
        
    }else{
    
        [self showAlterViewWithText:@"登录失败"];
    
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self showAlterViewWithText:@"失败"];

}

- (void) enterAlterVC{

    CMLAlterCodeVC *vc = [[CMLAlterCodeVC alloc] init];
    [[VCManger mainVC] pushVC:vc animate:YES];

}
@end
