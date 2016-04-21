//
//  CMLOtherActivityDetailVC.m
//  camelliae1.0
//
//  Created by 张越 on 16/4/15.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLOtherActivityDetailVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "VCManger.h"
#import "AFNetworking.h"
#import "DataManager.h"
#import "AppGroup.h"
#import "NSString+CMLExspand.h"

@interface CMLOtherActivityDetailVC ()<NavigationBarDelegate>

@end

@implementation CMLOtherActivityDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.backgroundColor = [UIColor blackColor];
    self.navBar.titleColor = [UIColor CMLTitleYellowColor];
    self.navBar.titleContent = @"活动详情";
    self.contentView.backgroundColor = [UIColor CMLVIPGrayColor];
    self.navBar.navigationBarDelegate = self;
    [self.navBar setWhiteLeftBarItem];

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,
                                                                     CGRectGetMaxY(self.navBar.frame),
                                                                     self.view.frame.size.width,
                                                                     self.contentView.frame.size.height - CGRectGetMaxY(self.navBar.frame))];
    webView.scalesPageToFit = YES;
    
    NSString *skey = [[DataManager lightData] readSkey];
    NSNumber*userID = [[DataManager lightData] readUserID];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    NSString *hashToken = [NSString getEncryptStringfrom:@[skey,reqTime,userID]];
    NSURL *url = [NSURL URLWithString: self.url];
    NSString *body = [NSString stringWithFormat: @"reqTime=%@&skey=%@&clientId=%@&hashToken=%@",reqTime,skey,userID,hashToken]; NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [webView loadRequest: request];
    
    [self.contentView addSubview:webView];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
    

}

@end
