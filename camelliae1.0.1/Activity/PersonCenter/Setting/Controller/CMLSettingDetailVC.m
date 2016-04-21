//
//  CMLSettingDetailVC.m
//  camelliae1.0
//
//  Created by 张越 on 16/4/15.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLSettingDetailVC.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "VCManger.h"

@interface CMLSettingDetailVC ()<NavigationBarDelegate>

@property (nonatomic,strong) NSString *path;

@end

@implementation CMLSettingDetailVC

- (void)viewDidLoad{

    [super viewDidLoad];
    self.navBar.backgroundColor = [UIColor blackColor];
    self.navBar.titleContent = self.currentitle;
    self.navBar.titleColor = [UIColor CMLTitleYellowColor];
    self.navBar.navigationBarDelegate = self;
    [self.navBar setWhiteLeftBarItem];
    
    [self loadData];
    
    [self loadViews];
    
    
}

- (void) loadData{

    if ([self.currentitle isEqualToString:@"关于我们"]) {
        
        self.path = [[NSBundle mainBundle] pathForResource:@"introduce" ofType:@"html"];
        
    }else if ([self.currentitle isEqualToString:@"服务及隐私的条款"]){
    
        self.path = [[NSBundle mainBundle] pathForResource:@"softPermission" ofType:@"html"];
    
    }else{
    
        self.path = [[NSBundle mainBundle] pathForResource:@"commonProblem" ofType:@"html"];
    }


}

- (void) loadViews{

    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navBar.frame), self.view.frame.size.width, self.contentView.frame.size.height- CGRectGetHeight(self.navBar.frame))];
    NSURL *url = [NSURL fileURLWithPath:self.path];
    webView.scalesPageToFit = YES;
    webView.scrollView.bounces = NO;
    webView.scrollView.alwaysBounceHorizontal = NO;
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.contentView addSubview:webView];


}

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];

}
@end
