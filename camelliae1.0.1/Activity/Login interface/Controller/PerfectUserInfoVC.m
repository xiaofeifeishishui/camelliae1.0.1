//
//  PerfectUserInfoVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/4/5.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "PerfectUserInfoVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NSString+CMLExspand.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "BaseResultObj.h"
#import "VCManger.h"
#import "UserDetailInfoObj.h"
#import "DataManager.h"

#define InputBackgroundHeight     484
#define InputBackgroundWidth      575
#define LOGOHeight                34
#define LOGOWidth                 266
#define LOGOTopMargin             56
#define InputFrameLeftMargin      64
#define InputFrameSpace           32
#define InputFrameTopMargin       46
#define LoginBtnHeight            57
#define FinshedBtnBottomMargin    53
#define FihshedBtnWidthMargin     185

@interface PerfectUserInfoVC ()<NavigationBarDelegate,UITextFieldDelegate,NetWorkProtocol>

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) NSMutableDictionary *perfectDic;

@end

@implementation PerfectUserInfoVC

- (NSMutableDictionary *)perfectDic{

    if (!_perfectDic) {
        _perfectDic = [NSMutableDictionary dictionary];
    }
    return _perfectDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.titleColor = [UIColor CMLTitleYellowColor];
    self.navBar.titleContent = @"注册";
    self.navBar.navigationBarDelegate = self;
    self.navBar.backgroundColor = [UIColor blackColor];
    [self.navBar setWhiteLeftBarItem];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.navBar.frame),
                                                                       self.view.frame.size.width,
                                                                       self.contentView.frame.size.height - self.navBar.frame.origin.y)];
    image.image = [UIImage imageNamed:KLoginBGImg];
    [self.contentView addSubview:image];
    
    [self loadViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    CGFloat inputHeight = (backgroundImage.frame.size.height - LOGOImage.frame.size.height - LOGOTopMargin*Proportion - InputFrameTopMargin*Proportion*2 - FinshedBtnBottomMargin*Proportion - LoginBtnHeight*Proportion - InputFrameSpace*Proportion*2)/3.0;
    
    NSArray *placeholderArray = @[@"请输入您的昵称",@"请输入您的真实姓名"];
    for (int i = 0 ; i < 3; i++) {
        
        UIImageView *inputAccountBG = [[UIImageView alloc] initWithFrame:CGRectMake(InputFrameLeftMargin*Proportion,
                                                                                    CGRectGetMaxY(LOGOImage.frame) + InputFrameTopMargin*Proportion+(inputHeight + InputFrameSpace*Proportion)*i,
                                                                                    backgroundImage.frame.size.width - 2*InputFrameLeftMargin*Proportion,
                                                                                    inputHeight)];
        inputAccountBG.image = [UIImage imageNamed:KLoginInputFrameImg];
        inputAccountBG.userInteractionEnabled = YES;
        inputAccountBG.userInteractionEnabled = YES;
        [backgroundImage addSubview:inputAccountBG];
        
        if (i != 1) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, inputAccountBG.frame.size.width, inputAccountBG.frame.size.height)];
            textField.delegate = self;
            if (i == 2) {
              textField.placeholder = placeholderArray[1];
            }else{
              textField.placeholder = placeholderArray[i];
            }
            textField.tag = i +1;
            textField.font = KSystemFontSize12;
            textField.textAlignment = NSTextAlignmentCenter;
            [inputAccountBG addSubview:textField];
            
        }else{
            
            NSArray *chooseArray = @[@"男",@"女"];
            UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:chooseArray];
            [control setTintColor:[UIColor blackColor]];
            control.selectedSegmentIndex = 1;
            control.frame = CGRectMake(0, 0, inputAccountBG.frame.size.width, inputAccountBG.frame.size.height);
            [inputAccountBG addSubview:control];
            [control addTarget:self action:@selector(changeSex:) forControlEvents:UIControlEventValueChanged];
            [self.perfectDic setObject:[NSNumber numberWithInt:2] forKey:@"gender"];
        
        
        }
        
        if (i == 2) {
            UIButton *finshedBtn = [[UIButton alloc] initWithFrame:CGRectMake(backgroundImage.frame.size.width/2.0 - FihshedBtnWidthMargin*Proportion/2.0, CGRectGetMaxY(inputAccountBG.frame) + InputFrameTopMargin*Proportion, FihshedBtnWidthMargin*Proportion, LoginBtnHeight*Proportion)];
            [finshedBtn setBackgroundImage:[UIImage imageNamed:KFinshedBtnImg] forState:UIControlStateNormal];
            [finshedBtn addTarget:self action:@selector(finshedInfoPerfect) forControlEvents:UIControlEventTouchUpInside];
            [backgroundImage addSubview:finshedBtn];
        }
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.textField = textField;
    
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 1) {
        [self.perfectDic setObject:textField.text forKey:@"nickName"];
    }else{
        [self.perfectDic setObject:textField.text forKey:@"userRealName"];
    }
}

#pragma mark - NavigationBarDelegate

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];

}


#pragma mark - finshedInfoPerfect

- (void) finshedInfoPerfect{

    NSString *nickName = [self.perfectDic valueForKey:@"nickName"];
    NSString *userRealName = [self.perfectDic valueForKey:@"userRealName"];
    if ((nickName.length >0 )&&(userRealName.length > 0)&&[self.perfectDic valueForKey:@"gender"]) {
     
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:[self.perfectDic valueForKey:@"gender"] forKey:@"gender"];
        [paraDic setObject:[self.perfectDic valueForKey:@"nickName"] forKey:@"nickName"];
        [paraDic setObject:[self.perfectDic valueForKey:@"userRealName"] forKey:@"userRealName"];
        NSNumber *reqTime =[NSNumber numberWithInt:[AppGroup getCurrentDate]];
        [paraDic setObject:reqTime forKey:@"reqTime"];
        NSString *skey = [[DataManager lightData] readSkey];
        [paraDic setObject:skey forKey:@"skey"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
        [NetWorkTask postResquestWithApiName:UpdateUser paraDic:paraDic delegate:delegate];
        
        
    }else{
    
        [self showAlterViewWithText:@"注册失败"];
    }

}

#pragma mark - changeSex

- (void) changeSex :(UISegmentedControl *) control{
    
    if (control.selectedSegmentIndex == 0) {
        [self.perfectDic setObject:[NSNumber numberWithInt:1] forKey:@"gender"];
    }else{
        [self.perfectDic setObject:[NSNumber numberWithInt:2] forKey:@"gender"];
    }

}

#pragma mark - NetWorkProtocol

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
   
    if ([obj.retCode intValue] == 0) {

        
        [[VCManger mainVC] popToVC:[VCManger homeVC] animated:YES];
        [[VCManger homeVC] viewDidLoad];

    }else{
        
        [self showAlterViewWithText:obj.retMsg];
    }
    
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self showAlterViewWithText:@"失败"];

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.textField resignFirstResponder];
}
@end
