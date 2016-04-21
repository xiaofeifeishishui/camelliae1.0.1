//
//  CMLSysDetailNoticeVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/4/13.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLSysDetailNoticeVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"
#import "NSString+CMLExspand.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "VCManger.h"
#import "DataManager.h"
#import "AppGroup.h"
#import "BaseResultObj.h"
#import "CMLSysNoticeObj.h"
#import "NSDate+CMLExspand.h"
#import "CMLLine.h"

#define LeftMargin            36
#define DateTopMargin         15
#define DateBottomMargin      30

@interface CMLSysDetailNoticeVC () <NavigationBarDelegate,NetWorkProtocol>

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,strong) UILabel *sysNoticeTitle;

@property (nonatomic,strong) UILabel *sysNoticeContent;


@end

@implementation CMLSysDetailNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentView.backgroundColor = [UIColor CMLVIPGrayColor];
    self.navBar.backgroundColor = [UIColor blackColor];
    self.navBar.titleColor = [UIColor CMLTitleYellowColor];
    self.navBar.titleContent = @"系统信息";
    self.navBar.navigationBarDelegate = self;
    [self.navBar setWhiteLeftBarItem];
    
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadData{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    [paraDic setObject:self.currentID forKey:@"objId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.currentID,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:SysNoticeInfo paraDic:paraDic delegate:delegate];
    

}

- (void) loadViews{

    
    self.sysNoticeTitle = [[UILabel alloc] init];
    self.sysNoticeTitle.text = self.obj.retData.title;
    self.sysNoticeTitle.font = KSystemFontSize15;
    [self.sysNoticeTitle sizeToFit];
    self.sysNoticeTitle.frame = CGRectMake(LeftMargin*Proportion,
                                           CGRectGetMaxY(self.navBar.frame) + LeftMargin *Proportion,
                                           self.sysNoticeTitle.frame.size.width,
                                           self.sysNoticeTitle.frame.size.height);
    [self.contentView addSubview:self.sysNoticeTitle];
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.obj.retData.publishDate intValue]];
    
    NSString *dateStr = [NSDate getStringDependOnFormatterAFromDate:date];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text =dateStr;
    dateLabel.font = KSystemBoldFontSize13;
    [dateLabel sizeToFit];
    dateLabel.frame = CGRectMake(LeftMargin*Proportion,
                                 CGRectGetMaxY(self.sysNoticeTitle.frame) + DateTopMargin*Proportion,
                                 dateLabel.frame.size.width,
                                 dateLabel.frame.size.height);
    
    [self.contentView addSubview:dateLabel];
    
    CMLLine *line = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake(LeftMargin*Proportion, CGRectGetMaxY(dateLabel.frame) + DateBottomMargin*Proportion);
    line.lineWidth = 0.5;
    line.lineLength = self.view.frame.size.width;
    line.LineColor = [UIColor CMLLineGrayColor];
    [self.contentView addSubview:line];
    
    
    self.sysNoticeContent = [[UILabel alloc] init];
    self.sysNoticeContent.font = KSystemFontSize13;
    self.sysNoticeContent.text = self.obj.retData.content;
    NSLog(@"%@",self.sysNoticeContent.text);
    CGRect rect = [self.sysNoticeContent.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - LeftMargin*Proportion*2, 1000)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:KSystemFontSize13}
                                                           context:nil];
    self.sysNoticeContent.frame = CGRectMake(LeftMargin*Proportion,
                                             CGRectGetMaxY(dateLabel.frame) + 2*DateBottomMargin*Proportion,
                                             self.view.frame.size.width - 2*LeftMargin*Proportion,
                                             rect.size.height);
    self.sysNoticeContent.numberOfLines = 0;
    self.sysNoticeContent.textColor = [UIColor CMLInputTextGrayColor];
    [self.contentView addSubview:self.sysNoticeContent];
    

}

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];

}


#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    self.obj = [BaseResultObj getBaseObjFrom:responseResult];
    
    if ([self.obj.retCode intValue] == 0) {
        [self loadViews];
        
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{


}
@end
