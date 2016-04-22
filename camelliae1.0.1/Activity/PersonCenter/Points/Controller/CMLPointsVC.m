//
//  CMLPointsVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/4/10.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLPointsVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "UIColor+SDExspand.h"
#import "NSString+CMLExspand.h"
#import "VCManger.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "CMLFontLayout.h"
#import "CMLLine.h"
#import "DataManager.h"

#define LineStartPointX       36
#define TextAndLineMargin     28
#define EndTitleTopMargin     10
#define EndLineTopMargin      38

@interface CMLPointsVC () <NavigationBarDelegate>

@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation CMLPointsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentView.backgroundColor = [UIColor CMLVIPGrayColor];
    self.navBar.backgroundColor = [UIColor blackColor];
    self.navBar.titleContent = @"积分";
    self.navBar.titleColor = [UIColor CMLTitleYellowColor];
    self.navBar.navigationBarDelegate = self;
    [self.navBar setWhiteLeftBarItem];
    
    [self loadData];
    
    [self loadViews];
    
}

- (void) loadData{
    
    self.dataArray = @[@"APP服务模块（旅游、课程、生活等），线上消费获得会员积分。",@"引荐朋友申请成为卡枚连会员，可获得会员积分。",@"转发卡枚连文章：在个人微信朋友圈转发卡枚连官方微信公众号（包括订阅号和服务号）或卡枚连新浪微博公众号的发布文章，可获得会员积分。",@"出席除粉色级别外的其他会员等级的线下活动，不定期获得幸运积分。",@"直接充值升级。（暂未开放，敬请期待）"];
    
    
    
}

- (void) loadViews{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-1,
                                                            CGRectGetMaxY(self.navBar.frame)+1,
                                                            self.view.frame.size.width+2,
                                                            CGRectGetHeight(self.navBar.frame))];
    view.backgroundColor = [UIColor CMLVIPGrayColor];
    view.layer.borderWidth =0.5;
    view.layer.borderColor = [UIColor CMLLineGrayColor].CGColor;
    [self.contentView addSubview:view];
    
    UILabel *startLabel = [[UILabel alloc]init];
    startLabel.text = [NSString stringWithFormat:@"当前积分：%@",[[DataManager lightData] readUserPoints]];
    startLabel.font = KSystemFontSize14;
    [startLabel sizeToFit];
    startLabel.frame = CGRectMake(LineStartPointX*Proportion, view.frame.size.height/2.0 - startLabel.frame.size.height/2.0, startLabel.frame.size.width, startLabel.frame.size.height);
    [view addSubview:startLabel];
    
    CGFloat currentOrginY = CGRectGetMaxY(view.frame) + TextAndLineMargin*Proportion;
    for (int i = 0; i < 5; i++) {
        
        CMLFontLayout *fontLayout = [[CMLFontLayout alloc] initWithFrame:CGRectMake(LineStartPointX*Proportion,
                                                                                    currentOrginY,
                                                                                    self.view.frame.size.width - LineStartPointX*Proportion*2,
                                                                                    0)];
        CGFloat textHeight = [fontLayout setFontLayoutWith:self.dataArray[i] dependFont:KSystemFontSize12];
        fontLayout.frame = CGRectMake(LineStartPointX*Proportion,
                                      currentOrginY ,
                                      self.view.frame.size.width - LineStartPointX*Proportion*2,
                                      textHeight);
        [self.contentView addSubview:fontLayout];
        
        CMLLine *line = [[CMLLine alloc] init];
        line.directionOfLine = HorizontalLine;
        line.LineColor = [UIColor CMLLineGrayColor];
        line.lineWidth = 0.5;
        line.lineLength = self.view.frame.size.width - LineStartPointX*Proportion;
        line.startingPoint = CGPointMake(LineStartPointX*Proportion,
                                         CGRectGetMaxY(fontLayout.frame) + TextAndLineMargin*Proportion);
        [self.contentView addSubview:line];
        currentOrginY = currentOrginY + TextAndLineMargin*Proportion*2 + textHeight;
        
        if (i == 4) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LineStartPointX*Proportion,
                                                                       currentOrginY + EndTitleTopMargin*Proportion,
                                                                       self.view.frame.size.width - 2*LineStartPointX*Proportion,
                                                                       20)];
            label.text = @"注：1）人民币100元=1个积分";
            label.font = KSystemFontSize12;
            [label sizeToFit];
            label.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:label];
            
            UILabel *labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(LineStartPointX*Proportion,
                                                                          CGRectGetMaxY(label.frame) + 11*Proportion,
                                                                          self.view.frame.size.width - 2*LineStartPointX*Proportion,
                                                                          20)];
            labelTwo.text = @"        2）以上所有内容的最终解释权，归卡枚连所有。";
            labelTwo.font = KSystemFontSize12;
            [labelTwo sizeToFit];
            labelTwo.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:labelTwo];
            
            CMLLine *endLine = [[CMLLine alloc] init];
            endLine.startingPoint = CGPointMake(0, CGRectGetMaxY(labelTwo.frame) +EndLineTopMargin*Proportion);
            endLine.lineWidth = 0.5;
            endLine.LineColor = [UIColor CMLLineGrayColor];
            endLine.lineLength = self.view.frame.size.width;
            endLine.directionOfLine = HorizontalLine;
            [self.contentView addSubview:endLine];
            
            UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(labelTwo.frame) + EndLineTopMargin*Proportion + 1,
                                                                       self.view.frame.size.width,
                                                                       self.view.frame.size.height)];
            endView.backgroundColor = [UIColor CMLVIPGrayColor];
            [self.contentView addSubview:endView];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NavigationBarDelegate

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
}

@end
