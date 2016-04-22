//
//  CMLAlterCodeVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/4/6.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLAlterCodeVC.h"
#import "UIColor+SDExspand.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "VCManger.h"
#import "CMLAlterCodeSecondStepVC.h"
#import "DataManager.h"

#define InputFrameTopMargin    46
#define InputFrameLeftMargin   36
#define NextBtnTopMargin       32
#define InputFrameHeiight      100

@interface CMLAlterCodeVC ()<NavigationBarDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITextField *textField;

@end

@implementation CMLAlterCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBar.titleContent = @"重置密码";
    self.navBar.titleColor = [UIColor CMLTitleYellowColor];
    self.navBar.navigationBarDelegate = self;
    [self.navBar setWhiteLeftBarItem];
    self.navBar.backgroundColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor CMLVIPGrayColor];
    
    [self laodViews];
    
}

- (void) laodViews{

    UITextField *textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(InputFrameLeftMargin*Proportion,
                                 CGRectGetMaxY(self.navBar.frame) + InputFrameTopMargin*Proportion,
                                 self.view.frame.size.width - InputFrameLeftMargin*Proportion*2,
                                 InputFrameHeiight*Proportion);
    textField.placeholder = @"手机号";
    textField.textAlignment = NSTextAlignmentCenter;
    textField.delegate = self;
    textField.backgroundColor = [UIColor whiteColor];
    NSString *phoneNum = [[DataManager lightData] readPhone];
    if (phoneNum.length > 0) {
        textField.text = phoneNum;
    }
    self.textField = textField;
    self.textField.textColor = [UIColor CMLInputTextGrayColor];
    self.textField.font = KSystemFontSize15;
    [self.contentView addSubview:self.textField];
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(InputFrameLeftMargin*Proportion,
                              CGRectGetMaxY(textField.frame) + NextBtnTopMargin*Proportion,
                              self.view.frame.size.width - 2*InputFrameLeftMargin*Proportion,
                              InputFrameHeiight*Proportion);
    [button setBackgroundColor:[UIColor blackColor]];
    button.layer.cornerRadius = 10;
    button.titleLabel.font = KSystemFontSize15;
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(enterGetverifyCodeVC) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - enterGetverifyCodeVC

- (void) enterGetverifyCodeVC {

    [self.textField resignFirstResponder];
    
    if (self.textField.text.length) {
     
        CMLAlterCodeSecondStepVC *vc = [[CMLAlterCodeSecondStepVC alloc] init];
        vc.telePhoneNum = self.textField.text;
        [[VCManger mainVC] pushVC:vc animate:YES];
    }else{
    
        [self showAlterViewWithText:@"请输入手机号"];
    }


}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{


}

#pragma mark - NavigationBarDelegate
- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.textField resignFirstResponder];
}
@end
