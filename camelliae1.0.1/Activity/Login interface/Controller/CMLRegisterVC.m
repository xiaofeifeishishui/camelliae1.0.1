//
//  CMLRegisterVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/4/3.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLRegisterVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "NSString+CMLExspand.h"
#import "BaseResultObj.h"
#import "UserInitialInfoObj.h"
#import "UserDetailInfoObj.h"
#import "PerfectUserInfoVC.h"
#import "VCManger.h"

#define InputBackgroundTopMargin  226
#define InputBackgroundWidth      575
#define LOGOHeight                34
#define LOGOWidth                 266
#define LOGOTopMargin             56
#define FirstInputFrameTopMargin  46
#define OtherInputFrameTopMargin  32
#define InputFrameLeftMargin      52
#define LastInputBottomMargin     61
#define NextBtnTopMargin          45
#define NextBtnBottomMargin       51
#define NextBtnHeight             57
#define NextBtnWidth              185


#define SpecialCustom             20

@interface CMLRegisterVC ()<NavigationBarDelegate,UITextFieldDelegate,NetWorkProtocol>

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) NSMutableDictionary *registerDic;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UIImageView *backGroundImage;

@end

@implementation CMLRegisterVC

- (NSMutableDictionary *)registerDic{

    if (!_registerDic) {
        _registerDic = [NSMutableDictionary dictionary];
    }
    return _registerDic;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.backgroundColor = [UIColor blackColor];
    self.navBar.titleContent = @"注册";
    self.navBar.backgroundColor = [UIColor blackColor];
    self.navBar.titleColor = [UIColor CMLTitleYellowColor];
    self.navBar.navigationBarDelegate = self;
    [self.navBar setWhiteLeftBarItem];

    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.navBar.frame),
                                                                       self.view.frame.size.width,
                                                                       self.contentView.frame.size.height - self.navBar.frame.origin.y)];
    image.image = [UIImage imageNamed:KLoginBGImg];
    [self.contentView addSubview:image];
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [self loadViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadViews{

    self.backGroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        InputBackgroundWidth*Proportion,
                                                                        self.contentView.frame.size.height - self.navBar.frame.size.height - InputBackgroundTopMargin*Proportion*2)];
    self.backGroundImage.userInteractionEnabled = YES;
    self.backGroundImage.image = [UIImage imageNamed:KLoginVCBackGroundImg];
    self.backGroundImage.center = CGPointMake(self.contentView.center.x, self.contentView.center.y);
    [self.contentView addSubview:self.backGroundImage];
    
    /**set LOGO*/
    UIImageView *LOGOImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           LOGOWidth*Proportion,
                                                                           LOGOHeight*Proportion)];
    LOGOImage.image = [UIImage imageNamed:KLoginVCLoginLOGOImg];
    LOGOImage.center = CGPointMake(self.backGroundImage.frame.size.width/2.0, LOGOTopMargin*Proportion + LOGOImage.frame.size.height/2.0);
    [self.backGroundImage addSubview:LOGOImage];
    
    
    
    CGFloat inputFrameHeight = (self.backGroundImage.frame.size.height - LOGOTopMargin*Proportion - FirstInputFrameTopMargin*Proportion - LOGOImage.frame.size.height - (NextBtnTopMargin + NextBtnBottomMargin + NextBtnHeight)*Proportion - OtherInputFrameTopMargin*Proportion*3)/4;
    NSArray *placeholderArray = @[@"请输入您的手机号",
                                  @"请输入验证码",
                                  @"请输入密码",
                                  @"邀请码(非必填)"];
    /**phoneNum*/
    for (int i = 0 ; i < 4; i++) {
        UIImageView *inputFrameBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:KLoginInputFrameImg]];
        inputFrameBackgroundImage.frame = CGRectMake(InputFrameLeftMargin*Proportion,
                                                     CGRectGetMaxY(LOGOImage.frame) + FirstInputFrameTopMargin*Proportion + (inputFrameHeight + OtherInputFrameTopMargin*Proportion)*i,
                                                     self.backGroundImage.frame.size.width - 2*InputFrameLeftMargin*Proportion,
                                                     inputFrameHeight);
        inputFrameBackgroundImage.userInteractionEnabled = YES;
        [self.backGroundImage addSubview:inputFrameBackgroundImage];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.tag = i+1;
        textField.placeholder = placeholderArray[i];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.font = KSystemFontSize12;
        textField.delegate = self;
        [textField addTarget:self action:@selector(inputNeedInformation:) forControlEvents:UIControlEventEditingChanged];
        if (i == 0) {
            textField.frame = CGRectMake(0,
                                         0,
                                         (inputFrameBackgroundImage.frame.size.width - SpecialCustom*Proportion)/2.0 + SpecialCustom*Proportion ,
                                         inputFrameHeight);
            textField.keyboardType = UIKeyboardTypeNumberPad;
            [inputFrameBackgroundImage addSubview:textField];
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textField.frame),
                                                                               0,
                                                                               inputFrameBackgroundImage.frame.size.width - CGRectGetMaxX(textField.frame),
                                                                               inputFrameBackgroundImage.frame.size.height)];
            image.userInteractionEnabled = YES;
            image.backgroundColor = [UIColor blackColor];
            image.layer.cornerRadius = 4;
            [inputFrameBackgroundImage addSubview:image];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textField.frame),
                                                                          0,
                                                                          (inputFrameBackgroundImage.frame.size.width - SpecialCustom*Proportion)/2.0,
                                                                          textField.frame.size.height)];
            [button setTitle:@"发送验证码" forState:UIControlStateNormal];
            button.titleLabel.font = KSystemFontSize12;
            [button addTarget:self action:@selector(receiVeverificationCode) forControlEvents:UIControlEventTouchUpInside];
            [inputFrameBackgroundImage addSubview:button];
        }else{
            if (i == 1) {
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }
            textField.frame = CGRectMake(0, 0, inputFrameBackgroundImage.frame.size.width, inputFrameBackgroundImage.frame.size.height);
            if (i != 1) {
                textField.secureTextEntry = YES;
            }
        }
        [inputFrameBackgroundImage addSubview:textField];
        
        if (i == 3) {
            UIButton *prefectInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.backGroundImage.frame.size.width/2.0 - NextBtnWidth*Proportion/2.0,
                                                                                  CGRectGetMaxY(inputFrameBackgroundImage.frame) + NextBtnTopMargin*Proportion,
                                                                                  NextBtnWidth*Proportion,
                                                                                  NextBtnHeight*Proportion)];
            [prefectInfoBtn setImage:[UIImage imageNamed:KNextBtnImg] forState:UIControlStateNormal];
            [prefectInfoBtn addTarget:self action:@selector(perfectPersonInfo) forControlEvents:UIControlEventTouchUpInside];
            [self.backGroundImage addSubview:prefectInfoBtn];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    self.textField = textField;
    
    return YES;

}

- (void) inputNeedInformation:(UITextField*)textField{
    
    if (textField.tag == 1) {
        [self.registerDic setObject:textField.text forKey:@"telephone"];
    }else if (textField.tag == 2){
        [self.registerDic setObject:textField.text forKey:@"verificationCode"];
    }else if (textField.tag == 3){
        [self.registerDic setObject:textField.text forKey:@"code"];
    }else{
        [self.registerDic setObject:textField.text forKey:@"againCode"];
    }


}


#pragma mark - receiVeverificationCode

- (void) receiVeverificationCode{

    [self.textField resignFirstResponder];
 
    
    if ([self.registerDic valueForKey:@"telephone"]) {
        
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        
        [paraDic setObject:[self.registerDic valueForKey:@"telephone"] forKey:@"account"];
        [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"accountType"];
        NSString *skey = [[DataManager lightData] readSkey];
        [paraDic setObject:skey forKey:@"skey"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[[self.registerDic valueForKey:@"telephone"],skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
        NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
        [paraDic setObject:reqTime forKey:@"reqTime"];
        [NetWorkTask postResquestWithApiName:CheckUser paraDic:paraDic delegate:delegate];
        self.currentApiName = CheckUser;
        [self startLoading];
        
    }else{
    
        [self showAlterViewWithText:@"请输入手机号"];
    }
    
}


#pragma mark - NavigationBarDelegate

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
    

}
- (void) perfectPersonInfo{

    NSString *code = [self.registerDic valueForKey:@"code"];
    if (code.length >= 6) {
     
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:[self.registerDic valueForKey:@"telephone"] forKey:@"mobile"];
        [paraDic setObject:[self.registerDic valueForKey:@"verificationCode"] forKey:@"smsCode"];
        [paraDic setObject:[self.registerDic valueForKey:@"code"] forKey:@"password"];
        NSNumber *reqTime =[NSNumber numberWithInt:[AppGroup getCurrentDate]];
        [paraDic setObject:reqTime forKey:@"reqTime"];
        NSString *skey = [[DataManager lightData] readSkey];
        [paraDic setObject:skey forKey:@"skey"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[[self.registerDic valueForKey:@"telephone"],
                                                               skey,
                                                               [self.registerDic valueForKey:@"verificationCode"],
                                                               [self.registerDic valueForKey:@"code"]]];
        if ([self.registerDic valueForKey:@"againCode"]) {
         
            [paraDic setObject:[self.registerDic valueForKey:@"againCode"] forKey:@"inviteCode"];
        }else{
            [paraDic setObject:[NSNumber numberWithInt:0] forKey:@"inviteCode"];
        }

        [paraDic setObject:hashToken forKey:@"hashToken"];
        
         
        [NetWorkTask postResquestWithApiName:TelephoneLogin paraDic:paraDic delegate:delegate];
        self.currentApiName = TelephoneLogin;
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.textField resignFirstResponder];
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    
    if ([self.currentApiName isEqualToString:MessageVerify]) {
        
        if ([obj.retCode intValue] == 100204) {
            [self showAlterViewWithText:@"请输入正确手机号"];
            
        }else if ([obj.retCode intValue] == 100208){
            [self showAlterViewWithText:@"您今日验证码已超限,请联系客服!"];
        }else if ([obj.retCode intValue] == 0){
            [self showAlterViewWithText:@"短信已发送"];
        }
        [self stopLoading];
    }else if ([self.currentApiName isEqualToString:CheckUser]){
    
        
        if ([obj.retCode intValue] == 100302) {

            [self getSmsCode];
            
        }else if([obj.retCode intValue] == 0){
        
            [self showAlterViewWithText:@"用户已存在"];
        }else if ([obj.retCode intValue] == 100110){
        
            [self showAlterViewWithText:@"请求超时"];
        
        }else if ([obj.retCode intValue] == 100100){
        
            [self showAlterViewWithText:@"输入错误"];
        }
        
        [self stopLoading];
    
    }else{
    
        if ([obj.retCode intValue] == 0) {
        
            [[DataManager lightData] saveSkey:obj.retData.skey];
            PerfectUserInfoVC *vc = [[PerfectUserInfoVC alloc] init];
            [[VCManger mainVC] pushVC:vc animate:YES];
            
        }else{
            [self showAlterViewWithText:obj.retMsg];
        }
    }
    
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self showAlterViewWithText:@"失败"];
}

- (void) getSmsCode{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSString *telephone = [self.registerDic valueForKey:@"telephone"];
    if (telephone) {
        [paraDic setObject:telephone forKey:@"mobile"];
    }
    
    [paraDic setObject:[NSNumber numberWithInt:10004] forKey:@"reqType"];
    
    NSString *skey = [[DataManager lightData] readSkey];
    
    if (skey) {
        [paraDic setObject:skey forKey:@"skey"];
    }else{
        
        [paraDic setObject:@"" forKey:@"skey"];
    }
    
    NSString *hashToken;
    if (skey) {
        hashToken = [NSString getEncryptStringfrom:@[telephone,[NSNumber numberWithInt:10004],skey]];
    }else{
        hashToken = [NSString getEncryptStringfrom:@[telephone,[NSNumber numberWithInt:10004],@""]];
    }
    
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    NSNumber *reqTime =[NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [NetWorkTask postResquestWithApiName:MessageVerify paraDic:paraDic delegate:delegate];
    self.currentApiName = MessageVerify;

}

#pragma mark - 监控键盘的高度
- (void)keyboardWasShown:(NSNotification*)aNotification{
    
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.3 animations:^{

        self.backGroundImage.center = CGPointMake(self.contentView.center.x, self.contentView.center.y - kbSize.height/2.0);
        
    }];
}



-(void)keyboardWillBeHidden:(NSNotification*)aNotification{
  
    [UIView animateWithDuration:0.3 animations:^{
        
         self.backGroundImage.center = CGPointMake(self.contentView.center.x, self.contentView.center.y);
        
    }];
    
}
@end
