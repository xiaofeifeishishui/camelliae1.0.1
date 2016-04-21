//
//  CMLSettingVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/31.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLSettingVC.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "VCManger.h"
#import "UIColor+SDExspand.h"
#import "CMLLine.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "NSString+CMLExspand.h"
#import "AppGroup.h"
#import "CMLSettingDetailVC.h"

#define LeftMargin                 36
#define RightMargin                36
#define LineAndTextSpace           28
#define SectionAndSectionSpace     20

#define RowEnterBtnWidth           12
#define RowEnterBtnHeight          22
#define logoutBtnHeight            85
#define BackBtnLeftMarigin         92

@interface CMLSettingVC ()<NavigationBarDelegate,NetWorkProtocol,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *infoAttributeArray;

@property (nonatomic,assign) CGFloat currentRowHeight;

@end

@implementation CMLSettingVC


- (void) viewDidLoad{

    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navBar.titleContent = @"设置";
    self.navBar.titleColor = [UIColor CMLTitleYellowColor];
    self.navBar.backgroundColor = [UIColor blackColor];
    self.navBar.navigationBarDelegate = self;
    [self.navBar setWhiteLeftBarItem];
    self.contentView.backgroundColor = [UIColor CMLVIPGrayColor];
    
    [self loadData];
    
    [self loadViews];
    
    
    

}

- (void) loadData{

    self.infoAttributeArray = @[@"清除缓存",
                                @"版本信息",
                                @"关于我们",
                                @"服务及隐私的条款",
                                @"常见问题",
                                @"给CAMELLIAE打分"];
}

- (void) loadViews{

    
    CGFloat currentHeight = self.navBar.frame.size.height +LineAndTextSpace*Proportion;
    
    for (int i = 0; i < 2; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = self.infoAttributeArray[i];
        label.font = KSystemFontSize12;
        [label sizeToFit];
        
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                currentHeight - LineAndTextSpace*Proportion,
                                                                self.view.frame.size.width,
                                                                LineAndTextSpace*Proportion*2 + label.frame.size.height)];
        view.backgroundColor = [UIColor whiteColor];
        self.currentRowHeight = view.frame.size.height;
        [self.contentView addSubview:view];
        
        label.frame = CGRectMake(LeftMargin*Proportion,
                                 view.frame.size.height/2.0 - label.frame.size.height/2.0,
                                 label.frame.size.width,
                                 label.frame.size.height);
        [view addSubview:label];
        
        currentHeight = currentHeight + view.frame.size.height;
        
        if ( i != 1) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BlackBackBtnOfRowImg]];
            imageView.frame = CGRectMake(self.view.frame.size.width - RightMargin*Proportion - RowEnterBtnWidth*Proportion,
                                         label.center.y - RowEnterBtnHeight*Proportion/2.0,
                                         RowEnterBtnWidth*Proportion,
                                         RowEnterBtnHeight*Proportion);
            [view addSubview:imageView];
            
            CMLLine *line = [[CMLLine alloc] init];
            line.startingPoint = CGPointMake(0, CGRectGetMaxY(view.frame)-1);
            line.LineColor = [UIColor CMLLineGrayColor];
            line.lineWidth = 0.5;
            line.lineLength = self.view.frame.size.width;
            [self.contentView addSubview:line];
            
            
        }
        
        if (i == 1) {
            UILabel *label = [[UILabel alloc] init];
            label.font = KSystemFontSize12;
            label.text = [NSString stringWithFormat:@"%@",[AppGroup appVersion]];
            [label sizeToFit];
            label.frame =CGRectMake(self.view.frame.size.width - RightMargin*Proportion - label.frame.size.width,
                                    0,
                                    label.frame.size.width,
                                    view.frame.size.height);
            [view addSubview:label];
        }
        
        if (i == 1) {
            UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                                       CGRectGetMaxY(view.frame) + SectionAndSectionSpace*Proportion,
                                                                                       self.view.frame.size.width,
                                                                                       self.contentView.frame.size.height - CGRectGetMaxY(view.frame))
                                                                      style:UITableViewStylePlain];
            mainTableView.scrollEnabled = NO;
            mainTableView.delegate = self;
            mainTableView.dataSource = self;
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2000)];
            UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(BackBtnLeftMarigin*Proportion, logoutBtnHeight*Proportion, self.view.frame.size.width - BackBtnLeftMarigin*Proportion*2, logoutBtnHeight*Proportion)];
            [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
            [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            logoutBtn.titleLabel.font = KSystemFontSize15;
            logoutBtn.layer.cornerRadius = 10;
            logoutBtn.layer.borderColor = [UIColor blackColor].CGColor;
            logoutBtn.layer.borderWidth = 0.5;
            [logoutBtn addTarget:self action:@selector(logoutPersonalAccount) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:logoutBtn];
            bgView.backgroundColor = [UIColor CMLVIPGrayColor];
            mainTableView.tableFooterView = bgView;
            
            [self.contentView addSubview:mainTableView];
            
        }
    }
}

#pragma mark - NavigationBarDelegate
- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] popViewControllerAnimated:YES];
    

}

#pragma mark - logoutPersonalAccount

- (void) logoutPersonalAccount{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
    NSNumber *userID = [[DataManager lightData] readUserID];
    [paraDic setObject:[NSString stringWithFormat:@"%@",userID] forKey:@"userId"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSString stringWithFormat:@"%@",userID],skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:Logout paraDic:paraDic delegate:delegate];
    
    [self startLoading];
    
    
}

#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
        
        if ([obj.retCode intValue] == 0) {
            [[DataManager lightData] removeSkey];
            [[DataManager lightData]removeUserID];
            [[DataManager lightData]removeCityID];
            [[VCManger mainVC] dismissCurrentVCWithAnimate:NO];
            [[VCManger homeVC] viewDidLoad];
            
        }else{
            
            [self showAlterViewWithText:obj.retMsg];
        }
    [self stopLoading];
} 

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self stopLoading];
    [[DataManager lightData] removeSkey];
    [[DataManager lightData]removeUserID];
    [[DataManager lightData]removeCityID];
    [[VCManger mainVC] dismissCurrentVC];
    [[VCManger homeVC] viewDidLoad];
}


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 4;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = KSystemFontSize12;
        cell.textLabel.text = self.infoAttributeArray[indexPath.row+2];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BlackBackBtnOfRowImg]];
        imageView.frame = CGRectMake(self.view.frame.size.width - RightMargin*Proportion - RowEnterBtnWidth*Proportion,
                                     cell.center.y - RowEnterBtnHeight*Proportion/2.0,
                                     RowEnterBtnWidth*Proportion,
                                     RowEnterBtnHeight*Proportion);
        [cell addSubview:imageView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return self.currentRowHeight;

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row < 3) {
     
        CMLSettingDetailVC *vc = [[CMLSettingDetailVC alloc] init];
        switch (indexPath.row) {
            case 0:
                vc.currentitle = @"关于我们";
                break;
            case 1:
                vc.currentitle = @"服务及隐私的条款";
                break;
            case 2:
                vc.currentitle = @"常见问题";
                break;
                
            default:
                break;
        }
        [[VCManger mainVC] pushVC:vc animate:YES];
    }else{
    
        NSString *path = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purpl+Software&id=1103146605";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
    
    }
}
@end
