//
//  CMLAlterCodeSecondStepVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/4/8.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLAlterCodeSecondStepVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "UIColor+SDExspand.h"
#import "VCManger.h"
#import "NSString+CMLExspand.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "BaseResultObj.h"
#import "CMLAlterCodeThirdStepVC.h"

#define DescribeTitleTopMargin  157
#define TelePhoneTopMargin      42
#define InputFrameLeftMargin    36
#define InputFrameWidth         375
#define InputFrameTopMargin     114
#define InputFrameHeight        100
#define NextStepBtnTopMargin    130

@interface CMLAlterCodeSecondStepVC ()<NavigationBarDelegate,NetWorkProtocol>

@property (nonatomic,strong) UITextField *inputVerifyCodeTextField;

@end

@implementation CMLAlterCodeSecondStepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.backgroundColor = [UIColor blackColor];
    self.navBar.titleContent = @"重置密码";
    self.navBar.titleColor = [UIColor CMLTitleYellowColor];
    self.navBar.navigationBarDelegate =self;
    [self.navBar setWhiteLeftBarItem];
    
    [self loadViews];
    
    self.contentView.backgroundColor = [UIColor CMLVIPGrayColor];
}


- (void) loadViews{
    UILabel *describeLabel = [[UILabel alloc] init];
    describeLabel.textColor = [UIColor CMLInputTextGrayColor];
    describeLabel.text = @"您正在通过以下手机号召回密码";
    describeLabel.font = KSystemFontSize15;
    describeLabel.textColor = [UIColor CMLInputTextGrayColor];
    [describeLabel sizeToFit];
    describeLabel.frame = CGRectMake(self.view.frame.size.width/2.0 - describeLabel.frame.size.width/2.0,
                                     DescribeTitleTopMargin*Proportion + CGRectGetMaxY(self.navBar.frame),
                                     describeLabel.frame.size.width,
                                     describeLabel.frame.size.height);
    [self.contentView addSubview:describeLabel];
    
    UILabel *telePhoneLabel = [[UILabel alloc] init];
    telePhoneLabel.font =KSystemFontSize30;
    telePhoneLabel.textAlignment = NSTextAlignmentCenter;
    telePhoneLabel.text = self.telePhoneNum;
    telePhoneLabel.textColor = [UIColor CMLInputTextGrayColor];
    [telePhoneLabel sizeToFit];
    telePhoneLabel.backgroundColor = [UIColor grayColor];
    telePhoneLabel.frame = CGRectMake(self.view.frame.size.width/2.0 - telePhoneLabel.frame.size.width/2.0,
                                      TelePhoneTopMargin*Proportion + CGRectGetMaxY(describeLabel.frame),
                                      telePhoneLabel.frame.size.width,
                                      telePhoneLabel.frame.size.height);
    telePhoneLabel.font = KSystemFontSize15;
    [self.contentView addSubview:telePhoneLabel];
    
    UITextField *inputVerifyCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(InputFrameLeftMargin*Proportion,
                                                                                          CGRectGetMaxY(telePhoneLabel.frame) + InputFrameTopMargin*Proportion,
                                                                                          InputFrameWidth*Proportion,
                                                                                          InputFrameHeight*Proportion)];
    inputVerifyCodeTextField.placeholder = @"手机验证码";
    inputVerifyCodeTextField.backgroundColor = [UIColor whiteColor];
    inputVerifyCodeTextField.font = KSystemFontSize15;
    self.inputVerifyCodeTextField =inputVerifyCodeTextField;
    [self.contentView addSubview:self.inputVerifyCodeTextField];
    
    UIButton *getVerifyCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(inputVerifyCodeTextField.frame),
                                                                            inputVerifyCodeTextField.frame.origin.y,
                                                                            self.view.frame.size.width - InputFrameLeftMargin*Proportion*2 - InputFrameWidth*Proportion,
                                                                            InputFrameHeight*Proportion)];
    [getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerifyCodeBtn setBackgroundColor:[UIColor blackColor]];
    getVerifyCodeBtn.titleLabel.font = KSystemFontSize15;
    [getVerifyCodeBtn addTarget:self action:@selector(getVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:getVerifyCodeBtn];
    
    
    UIButton *nextStepBtn = [[UIButton alloc] initWithFrame:CGRectMake(InputFrameLeftMargin*Proportion, CGRectGetMaxY(inputVerifyCodeTextField.frame) + NextStepBtnTopMargin*Proportion, self.view.frame.size.width - 2*InputFrameLeftMargin*Proportion, InputFrameHeight*Proportion)];
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextStepBtn.titleLabel.font = KSystemFontSize15;
    nextStepBtn.layer.cornerRadius = 10;
    [nextStepBtn setBackgroundColor:[UIColor blackColor]];
    [nextStepBtn addTarget:self action:@selector(enterFinshedVC) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:nextStepBtn];
    
    
    
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getVerifyCode

- (void) getVerifyCode {
    

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    if (self.telePhoneNum.length >0) {
     [paraDic setObject:self.telePhoneNum forKey:@"mobile"];
     [paraDic setObject:[NSNumber numberWithInt:10004] forKey:@"reqType"];
     NSString *skey = [[DataManager lightData] readSkey];
     [paraDic setObject:skey forKey:@"skey"];
     NSString *hashToken = [NSString getEncryptStringfrom:@[self.telePhoneNum,[NSNumber numberWithInt:10004],skey]];
     [paraDic setObject:hashToken forKey:@"hashToken"];
     NSNumber *reqTime =[NSNumber numberWithInt:[AppGroup getCurrentDate]];
     [paraDic setObject:reqTime forKey:@"reqTime"];
     [NetWorkTask postResquestWithApiName:MessageVerify paraDic:paraDic delegate:delegate];
        
        [self startLoading];
    }

}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    
    if ([obj.retCode intValue] == 0) {
        
        
    }else if ([obj.retCode intValue] == 100204){
        NSLog(@"请输入正确手机号");
        [self showAlterViewWithText:obj.retMsg];
    
    }else if ([obj.retCode intValue] ==100208){
        NSLog(@"您今日验证码已超限,请联系客服!");
        [self showAlterViewWithText:obj.retMsg];
    }
    
    [self stopLoading];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self stopLoading];

}

#pragma mark - enterFinshedVC

- (void) enterFinshedVC{

    CMLAlterCodeThirdStepVC *vc = [[CMLAlterCodeThirdStepVC alloc] init];
    vc.telePhoneNum = self.telePhoneNum;
    vc.verifyCode = self.inputVerifyCodeTextField.text;
    [[VCManger mainVC] pushVC:vc animate:YES];
    

}

#pragma mark - NavigationBarDelegate

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];

}

#pragma mark -

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.inputVerifyCodeTextField resignFirstResponder];

}
@end
