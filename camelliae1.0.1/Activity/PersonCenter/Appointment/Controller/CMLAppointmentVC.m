//
//  CMLAppointmentVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/4/8.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLAppointmentVC.h"
#import "CommonImg.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "NSString+CMLExspand.h"
#import "DataManager.h"
#import "AppGroup.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "VCManger.h"
#import "BaseResultObj.h"
#import "CMLAppointmentTVCell.h"
#import "AppointmentActivityObj.h"
#import "AppointmentServeObj.h"
#import "CMLActivityDetailVC.h"
#import "CMLServeDetailVC.h"
#import "UIScrollView+RefreshHeader.h"
#import "CMLRefreshFooter.h"

#define ChooseBtnHeight   44
#define RowHeight         202

#define PageSize          20
@interface CMLAppointmentVC ()<NavigationBarDelegate,NetWorkProtocol,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIButton *activityBtn;

@property (nonatomic,strong) UIButton *serveBtn;

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) BOOL isActivity;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,strong) CMLRefreshFooter *refreshFooter;

@end

@implementation CMLAppointmentVC

- (NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.titleContent = @"预约管理";
    self.navBar.titleColor = [UIColor CMLTitleYellowColor];
    self.navBar.backgroundColor = [UIColor blackColor];
    self.navBar.navigationBarDelegate = self;
    [self.navBar setWhiteLeftBarItem];
    self.contentView.backgroundColor = [UIColor CMLVIPGrayColor];
    self.page = 1;
    
    [self loadViews];
    
    [self loadData];
    
}

- (void) loadViews{

    self.activityBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(self.navBar.frame),
                                                                  self.view.frame.size.width/2.0,
                                                                  ChooseBtnHeight*Proportion)];
    self.activityBtn.titleLabel.font = KSystemFontSize12;
    [self.activityBtn setBackgroundColor:[UIColor blackColor]];
    [self.activityBtn setTitle:@"活动" forState:UIControlStateNormal];
    [self.activityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.activityBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.activityBtn.selected = YES;
    [self.activityBtn addTarget:self action:@selector(chooseActivityAppointment) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.activityBtn];
    
    self.serveBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.activityBtn.frame),
                                                               CGRectGetMaxY(self.navBar.frame),
                                                               self.view.frame.size.width/2.0,
                                                               ChooseBtnHeight*Proportion)];
    self.serveBtn.titleLabel.font = KSystemFontSize12;
    [self.serveBtn setBackgroundColor:[UIColor blackColor]];
    [self.serveBtn setTitle:@"服务" forState:UIControlStateNormal];
    [self.serveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.serveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.serveBtn addTarget:self action:@selector(chooseServeAppointment) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.serveBtn];
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.activityBtn.frame),
                                                                       self.view.frame.size.width,
                                                                       self.contentView.frame.size.height - self.navBar.frame.size.height - self.activityBtn.frame.size.height)
                                                      style:UITableViewStylePlain];
    self.mainTableView.backgroundColor = [UIColor CMLVIPGrayColor];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.hidden = YES;
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.mainTableView];
    
    /**下拉刷新*/
    
    __weak typeof(self) weakSelf = self;
    [self.mainTableView addPullToRefreshWithPullText:@"CAMELLIAE" pullTextColor:[UIColor blackColor] pullTextFont: KSystemFontSize16 refreshingText:@"Loading...." refreshingTextColor:[UIColor blackColor] refreshingTextFont:KSystemFontSize16 action:^{
        [weakSelf pullRefreshOfHeader];
    }];
    
    self.refreshFooter = [[CMLRefreshFooter alloc] init];
    self.refreshFooter.scrollView = self.mainTableView;
    [self.refreshFooter footer];
    
    /**上拉*/
    __block CMLAppointmentVC *vc = self;
    self.refreshFooter.beginRefreshingBlock = ^(){
        
        [vc.refreshFooter beginRefreshing];
        [vc pullToLoadingOfFooter];
        
    };
    

}

- (void) loadData{

    [self startLoading];
    [self sendRequestWithObjTypeId:[NSNumber numberWithInt:2] andPage:self.page];
    self.isActivity = YES;

}

- (void) chooseActivityAppointment{

    [self startLoading];
    self.page = 1;
    self.activityBtn.selected = YES;
    self.serveBtn.selected = NO;

    [self sendRequestWithObjTypeId:[NSNumber numberWithInt:2] andPage:self.page];
    self.isActivity = YES;
    

}


- (void) chooseServeAppointment{

    [self startLoading];
    self.page = 1;
    self.serveBtn.selected = YES;
    self.activityBtn.selected = NO;
    
    [self sendRequestWithObjTypeId:[NSNumber numberWithInt:3] andPage:self.page];
    self.isActivity = NO;

}


- (void) sendRequestWithObjTypeId:(NSNumber *)objTypeId andPage:(int) page{

    [self.dataArray removeAllObjects];
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *userID = [[DataManager lightData] readUserID];
    [paraDic setObject:userID forKey:@"userId"];
    int currentTime = [AppGroup getCurrentDate];
    [paraDic setObject:[NSNumber numberWithInt:currentTime] forKey:@"reqTime"];
    NSString *skey =[[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:currentTime],userID,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [paraDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    if (self.activityBtn.selected) {
        [paraDic setObject:objTypeId forKey:@"objTypeId"];
        [NetWorkTask postResquestWithApiName:SubscribeList paraDic:paraDic delegate:delegate];
        self.currentApiName = SubscribeList;
    }else{
        [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
        [NetWorkTask postResquestWithApiName:ServeBookList paraDic:paraDic delegate:delegate];
        self.currentApiName = ServeBookList;
    }

    
    [self hiddenNotData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    
    self.dataCount = obj.retData.dataCount;
    
    if ([self.currentApiName isEqualToString:SubscribeList]) {
      
        if (self.isActivity) {
            
            if ([obj.retCode intValue] == 0) {
                
                if (obj.retData.dataList) {
                
                    [self hiddenNotData];
                    self.mainTableView.hidden = NO;
                    
                    [self.dataArray addObjectsFromArray: obj.retData.dataList];
                    [self.mainTableView reloadData];
                    [self stopLoading];
                    
                }else{
                    
                    [self showNotData];
                    [self stopLoading];
                    self.mainTableView.hidden = YES;
                }
                
            }else{
                [self stopLoading];
                [self showAlterViewWithText:obj.retMsg];
            }
        }else{
            if (obj.retData.dataList) {
                self.mainTableView.hidden = NO;
                [self stopLoading];
                [self hiddenNotData];
                
            }else{
            
                [self showNotData];
                [self stopLoading];
                self.mainTableView.hidden = YES;
            }
        }
    }else{
        if ([obj.retCode intValue] == 0) {
            
            if (obj.retData.dataList) {
                
                [self hiddenNotData];
                self.mainTableView.hidden = NO;
                
                [self.dataArray addObjectsFromArray: obj.retData.dataList];
                [self.mainTableView reloadData];
                [self stopLoading];
                
            }else{
                
                [self showNotData];
                [self stopLoading];
                self.mainTableView.hidden = YES;
            }
            
        }else{
            [self stopLoading];
            [self showAlterViewWithText:obj.retMsg];
        }
    }
    
    [self.mainTableView finishLoading];
    [self.refreshFooter endRefreshing];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self stopLoading];
    [self showNotData];
    [self.mainTableView finishLoading];
    [self.refreshFooter endRefreshing];

}

#pragma mark - NavigationBarDelegate

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];

}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return RowHeight*Proportion;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"myTableViewcell";
    CMLAppointmentTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CMLAppointmentTVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.dataArray.count > 0) {
     
        if (self.activityBtn.selected) {
            
            AppointmentActivityObj *currentObj =  [AppointmentActivityObj getBaseObjFrom:self.dataArray[indexPath.row]];
            cell.imageUrl = currentObj.coverPic;
            cell.title = currentObj.title;
            cell.content = currentObj.briefIntro;
            
            cell.isShowExpire = YES;
            cell.showExpire = currentObj.isExpire;
            cell.showDelegate = currentObj.isDeleted;
            [cell refreshTableViewCell];
            
            if ([currentObj.isDeleted intValue] == 2) {
                cell.userInteractionEnabled = NO;
            }
        }else{
        
            AppointmentServeObj *currentObj = [AppointmentServeObj getBaseObjFrom:self.dataArray[indexPath.row]];
            cell.imageUrl = currentObj.coverPic;
            cell.title = currentObj.title;
            cell.content = currentObj.briefIntro;
            cell.isShowExpire = NO;
            cell.showDelegate = currentObj.isDeleted;
            [cell refreshTableViewCell];
            if ([currentObj.isDeleted intValue] == 2) {
                cell.userInteractionEnabled = NO;
            }
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.activityBtn.selected) {
    
        CMLActivityDetailVC *vc = [[CMLActivityDetailVC alloc] init];
        AppointmentActivityObj *obj = [AppointmentActivityObj getBaseObjFrom:self.dataArray[indexPath.row]];
        vc.objId = obj.currentID;
        vc.currentTitle = @"活动详情";
        [[VCManger mainVC] pushVC:vc animate:YES];
        
        
    }else{
     
        CMLServeDetailVC *vc = [[CMLServeDetailVC alloc] init];
        vc.currentTitle = @"服务详情";
        AppointmentServeObj *serveModel = [AppointmentServeObj getBaseObjFrom:self.dataArray[indexPath.row]];
        vc.objId = serveModel.currentID;
        [[VCManger mainVC] pushVC:vc animate:YES];
    
    }

}
#pragma mark - pullRefreshOfHeader
- (void) pullRefreshOfHeader{

    self.page = 1;
    if (self.isActivity) {
       [self sendRequestWithObjTypeId:[NSNumber numberWithInt:2] andPage:self.page];
    }else{
       [self sendRequestWithObjTypeId:[NSNumber numberWithInt:3] andPage:self.page];
    }
}

#pragma mark - pullToLoadingOfFooter
- (void) pullToLoadingOfFooter{
        
    if (self.dataArray.count%PageSize == 0) {
        if (self.dataArray.count != [self.dataCount intValue]) {
            self.page++;
            if (self.isActivity) {
               [self sendRequestWithObjTypeId:[NSNumber numberWithInt:2] andPage:self.page];
            }else{
                [self sendRequestWithObjTypeId:[NSNumber numberWithInt:3] andPage:self.page];
            }
        }else{
            [self.refreshFooter endRefreshing];
        }
    }else{
    
        [self.refreshFooter endRefreshing];
    }
}
@end
