//
//  CMLServeVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/24.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLServeVC.h"
#import "VCManger.h"
#import "CMLServeDetailVC.h"
#import "CommonNumber.h"
#import "CommonImg.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "CMLServeSecondVC.h"
#import "VCManger.h"


#define LOGOTopMargin              30
#define LOGOWidth                  218
#define LOGOHeight                 28

#define ServeModuleHeight          (self.contentView.frame.size.height - self.navBar.frame.size.height - 98*Proportion)/3

@interface CMLServeVC ()

@end

@implementation CMLServeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.backgroundColor = [UIColor blackColor];
    self.contentView .backgroundColor= [UIColor grayColor];
    self.navBar.backgroundColor = [UIColor blackColor];
    
    /**设置头*/
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0 - LOGOWidth*Proportion/2.0,
                                                                         LOGOTopMargin*Proportion,
                                                                         LOGOWidth*Proportion,
                                                                         LOGOHeight*Proportion)];
    logoImg.image = [UIImage imageNamed:KLOGOImg];
    [self.navBar addSubview:logoImg];
    

    /**设置按键*/
    [self loadViews];
    
    
}


- (void) loadViews{

    
    NSArray *moduleImgArray = @[KGrowupImg,KTravelImg,KFashionImg];
    NSArray *moduleBGImgArray =@[KGrowupBGImg,KTravelBGImg,KFashionBGImg];
    for (int i = 0; i < 3; i++) {
        
        UIImageView *bgImage = [[UIImageView alloc] init];
        bgImage.frame = CGRectMake(0,
                                   CGRectGetMaxY(self.navBar.frame)+ServeModuleHeight*i,
                                   self.view.frame.size.width,
                                   ServeModuleHeight);
        bgImage.image = [UIImage imageNamed:moduleBGImgArray[i]];
        [self.contentView addSubview:bgImage];
        
        /**按键设置*/
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(0,
                                  CGRectGetMaxY(self.navBar.frame)+ServeModuleHeight*i,
                                  self.view.frame.size.width,
                                  ServeModuleHeight);
        button.tag = i+1;
        [button setImage:[UIImage imageNamed:moduleImgArray[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(enterSpecialServeListVC:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
    }


}

#pragma mark - netWork

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - enterSpecialServeListVC

- (void) enterSpecialServeListVC:(UIButton *) button {

    if (button.tag == 1) {
        
        CMLServeSecondVC *vc = [[CMLServeSecondVC alloc] init];
        vc.currenttitle = @"成长";
        vc.currentServeType = [NSNumber numberWithInt:1];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else if(button.tag == 2){

        CMLServeSecondVC *vc = [[CMLServeSecondVC alloc] init];
        vc.currenttitle = @"旅游";
        vc.currentServeType = [NSNumber numberWithInt:2];
        [[VCManger mainVC] pushVC:vc animate:YES];
    
    }else{
    
        CMLServeSecondVC *vc = [[CMLServeSecondVC alloc] init];
        vc.currenttitle = @"生活";
        vc.currentServeType = [NSNumber numberWithInt:3];
        [[VCManger mainVC] pushVC:vc animate:YES];
    
    }

}


@end
