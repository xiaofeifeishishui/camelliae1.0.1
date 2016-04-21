//
//  InformationVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/24.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLInformationVC.h"
#import "CommonImg.h"
#import "CommonNumber.h"
#import "CMLVIPDetailVC.h"
#import "VCManger.h"

#define LOGOTopMargin              30
#define LOGOWidth                  218
#define LOGOHeight                 28
#define VIPNameWidht               215
#define VIPNameHeight              53

#define KVIPModule                 (self.contentView.frame.size.height - self.navBar.frame.size.height - 98*Proportion)/4

@interface CMLInformationVC ()

@end

@implementation CMLInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.contentView.backgroundColor = [UIColor grayColor];
    self.navBar.backgroundColor = [UIColor blackColor];
    
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0 - LOGOWidth*Proportion/2.0,
                                                                         LOGOTopMargin*Proportion,
                                                                         LOGOWidth*Proportion,
                                                                         LOGOHeight*Proportion)];
    logoImg.image = [UIImage imageNamed:KLOGOImg];
    [self.navBar addSubview:logoImg];
    
    [self loadViews];
    
}

#pragma mark -loadViews

- (void) loadViews{

    NSArray *moduleImgArray = @[KVIPPinkImg,KVIPPurpleImg,KVIPGoldImg,KVIPLnkImg];
    NSArray *moduleBGImgArray = @[KVIPPinBGkImg,KVIPPurpleBGImg,KVIPGoldBGImg,KVIPLnkBGImg];
    for (int i = 0; i < 4; i++) {
        
        UIImageView *bgImg = [[UIImageView alloc] init];
        bgImg.frame = CGRectMake(0,
                                 CGRectGetMaxY(self.navBar.frame)+KVIPModule*i,
                                 self.view.frame.size.width,
                                 KVIPModule);
        bgImg.image = [UIImage imageNamed:moduleBGImgArray[i]];
        [self.contentView addSubview:bgImg];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               VIPNameWidht*Proportion,
                                                                               VIPNameHeight*Proportion)];
        imageView.image = [UIImage imageNamed:moduleImgArray[i]];
        imageView.userInteractionEnabled = YES;
        imageView.center = bgImg.center;
        [self.contentView addSubview:imageView];
        
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(0,
                                  CGRectGetMaxY(self.navBar.frame)+KVIPModule*i,
                                  self.view.frame.size.width,
                                  KVIPModule);
        button.tag = i+1;
        [button addTarget:self action:@selector(showDetailOfVIPType:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - showDetailOfVIPType

- (void) showDetailOfVIPType:(UIButton *) button{

    CMLVIPDetailVC *vc = [[CMLVIPDetailVC alloc] init];
    switch (button.tag) {
        case 1:
            vc.currentRank = VIPRankOfPink;
            break;
        case 2:
            vc.currentRank = VIPRankOfPurple;
            break;
        case 3:
            vc.currentRank = VIPRankGold;
            break;
        case 4:
            vc.currentRank = VIPRankLnk;
            break;
            
        default:
            break;
    }
    [[VCManger mainVC] pushVC:vc animate:YES];
    
    

}

@end
