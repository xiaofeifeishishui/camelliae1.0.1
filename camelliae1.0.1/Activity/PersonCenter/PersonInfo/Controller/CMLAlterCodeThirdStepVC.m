//
//  CMLAlterCodeThirdStepVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/4/8.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLAlterCodeThirdStepVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NSString+CMLExspand.h"
#import "UIColor+SDExspand.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "VCManger.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "BaseResultObj.h"


#define InputFrameLeftMargin     36
#define InputFrameTopMargin      46
#define InputFrameSpace          2
#define InpuFrameHeight          100
#define FinshedBtnTopMargin      46

@interface CMLAlterCodeThirdStepVC ()<NavigationBarDelegate,NetWorkProtocol>

@property (nonatomic,copy) NSString * CodeStr;

@property (nonatomic,strong) UITextField *oldCodeTextField;

@property (nonatomic,strong) UITextField *confirmCodeTextField;

@end

@implementation CMLAlterCodeThirdStepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.backgroundColor = [UIColor blackColor];
    self.navBar.titleContent = @"重置密码";
    self.navBar.titleColor = [UIColor CMLTitleYellowColor];
    self.navBar.navigationBarDelegate = self;
    [self.navBar setWhiteLeftBarItem];
    self.contentView.backgroundColor = [UIColor CMLVIPGrayColor];
    
    
    [self loadViews];
    
}

- (void) loadViews{

    UITextField *oldCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(InputFrameLeftMargin*Proportion, CGRectGetMaxY(self.navBar.frame) + InputFrameTopMargin*Proportion, self.view.frame.size.width - 2*InputFrameLeftMargin*Proportion, InpuFrameHeight*Proportion)];
    oldCodeTextField.font = KSystemFontSize15;
    oldCodeTextField.backgroundColor = [UIColor whiteColor];
    oldCodeTextField.tag = 1;
    oldCodeTextField.placeholder = @"输入新密码";
    oldCodeTextField.secureTextEntry = YES;
    self.oldCodeTextField = oldCodeTextField;
    [self.contentView addSubview:self.oldCodeTextField];
    
    UITextField *newCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(InputFrameLeftMargin*Proportion, CGRectGetMaxY(oldCodeTextField.frame) + InputFrameSpace*Proportion, self.view.frame.size.width - 2*InputFrameLeftMargin*Proportion, InpuFrameHeight*Proportion)];
    newCodeTextField.font = KSystemFontSize15;
    newCodeTextField.backgroundColor = [UIColor whiteColor];
    newCodeTextField.tag = 2;
    newCodeTextField.secureTextEntry = YES;
    newCodeTextField.placeholder = @"确认密码";
    self.confirmCodeTextField = newCodeTextField;
    [self.contentView addSubview:self.confirmCodeTextField];
    
    UIButton *finshedBtn = [[UIButton alloc] initWithFrame:CGRectMake(InputFrameLeftMargin*Proportion, CGRectGetMaxY(newCodeTextField.frame) + FinshedBtnTopMargin*Proportion, self.view.frame.size.width - 2*InputFrameLeftMargin*Proportion, InpuFrameHeight*Proportion)];
    [finshedBtn setTitle:@"确认" forState:UIControlStateNormal];
    finshedBtn.titleLabel.font =KSystemFontSize15;
    [finshedBtn setBackgroundColor:[UIColor blackColor]];
    finshedBtn.layer.cornerRadius = 10;
    [finshedBtn addTarget:self action:@selector(confirmAlter) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:finshedBtn];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - confirmAlter

- (void) confirmAlter {

    if ([self.oldCodeTextField.text isEqualToString:self.confirmCodeTextField.text]) {
    
        if (self.verifyCode.length >0 && self.telePhoneNum.length > 0) {
            
            NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
            delegate.delegate = self;
            
            NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
            [paraDic setObject:self.telePhoneNum forKey:@"mobile"];
            [paraDic setObject:self.verifyCode forKey:@"smsCode"];
            [paraDic setObject:self.confirmCodeTextField.text forKey:@"password"];
            NSString *skey = [[DataManager lightData] readSkey];
            [paraDic setObject:skey forKey:@"skey"];
            NSNumber *reqTime =[NSNumber numberWithInt:[AppGroup getCurrentDate]];
            [paraDic setObject:reqTime forKey:@"reqTime"];
            
            NSString *hashToken = [NSString getEncryptStringfrom:@[self.telePhoneNum,skey,self.verifyCode,self.confirmCodeTextField.text]];
            [paraDic setObject:hashToken forKey:@"hashToken"];
            
            [NetWorkTask postResquestWithApiName:FindPassword paraDic:paraDic delegate:delegate];
            [self startLoading];
            
        }else{
        
            [self showAlterViewWithText:@"输入不正确"];
        }
    }else{
        [self showAlterViewWithText:@"两次输入密码不一致"];
    
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.oldCodeTextField resignFirstResponder];
    [self.confirmCodeTextField resignFirstResponder];

}

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
    
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    
    if ([obj.retCode intValue] == 0) {
        [[DataManager lightData] removeSkey];
        [[DataManager lightData]removeUserID];
        [[VCManger mainVC] popToVC:[VCManger homeVC] animated:NO];
        [[VCManger homeVC] viewDidLoad];
        
    }else{
    
        [self showAlterViewWithText:@"修改失败"];
    }
    
    
    [self stopLoading];

}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{


    [self stopLoading];
}
@end
