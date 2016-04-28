//
//  CMLCollerctVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/4/10.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLCollerctVC.h"
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
#import "MJRefresh.h"

#define ChooseBtnHeight   44
#define RowHeight         202


#define PageSize          20

@interface CMLCollerctVC ()<NavigationBarDelegate,NetWorkProtocol,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UIButton *activityBtn;

@property (nonatomic,strong) UIButton *serveBtn;

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,assign) BOOL isActivity;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSNumber *dataCount;

@end

@implementation CMLCollerctVC

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.titleContent = @"活动收藏";
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
    
    /**下拉*/
    __weak typeof(self) weakSelf = self;
    [self.mainTableView addPullToRefreshWithPullText:@"CAMELLIAE" pullTextColor:[UIColor blackColor] pullTextFont: KSystemFontSize16 refreshingText:@"Loading...." refreshingTextColor:[UIColor blackColor] refreshingTextFont:KSystemFontSize16 action:^{
        [weakSelf pullRefreshOfHeader];
    }];
    
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

- (void) loadMoreData{
    [self pullToLoadingOfFooter];
    
}

- (void) loadData{
    
    [self startLoading];
    [self sendRequestWithObjTypeId:[NSNumber numberWithInt:2] withPage:self.page];
    self.isActivity = YES;
    
}

- (void) chooseActivityAppointment{
    
    [self startLoading];
    self.page = 1;
    [self.dataArray removeAllObjects];
    self.activityBtn.selected = YES;
    self.serveBtn.selected = NO;
    
    [self sendRequestWithObjTypeId:[NSNumber numberWithInt:2]withPage:self.page];
    self.isActivity = YES;
    
}


- (void) chooseServeAppointment{
  
    [self startLoading];
    self.page = 1;
    [self.dataArray removeAllObjects];
    self.serveBtn.selected = YES;
    self.activityBtn.selected = NO;
    
    [self sendRequestWithObjTypeId:[NSNumber numberWithInt:3] withPage:self.page];
    self.isActivity = NO;
    
}


- (void) sendRequestWithObjTypeId:(NSNumber *)objTypeId withPage:(int) page{
    
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSNumber *userID = [[DataManager lightData] readUserID];
    [paraDic setObject:userID forKey:@"userId"];
    [paraDic setObject:objTypeId forKey:@"objTypeId"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    
    int currentTime = [AppGroup getCurrentDate];
    [paraDic setObject:[NSNumber numberWithInt:currentTime] forKey:@"reqTime"];
    NSString *skey =[[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:currentTime],userID,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [paraDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [NetWorkTask postResquestWithApiName:FavList paraDic:paraDic delegate:delegate];
    self.currentApiName = FavList;
    [self hiddenNotData];
    
    
}

- (void) sendRequestCancelFav:(NSNumber*)objTypeID  withUid:(NSNumber *) uid{
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:reqTime forKey:@"favTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:uid forKey:@"objId"];
    [paraDic setObject:objTypeID forKey:@"objTypeId"];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"actType"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[uid,
                                                           objTypeID,
                                                           reqTime,
                                                           [NSNumber numberWithInt:2],
                                                           skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    [NetWorkTask postResquestWithApiName:ActivityFav paraDic:paraDic delegate:delegate];
    self.currentApiName = ActivityFav;
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    
    if ([self.currentApiName isEqualToString:FavList]) {
        self.dataCount = obj.retData.dataCount;
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
            
            if ([obj.retCode intValue] == 0) {
                
                if (obj.retData.dataList) {
                    
                    self.mainTableView.hidden = NO;
                    [self.dataArray addObjectsFromArray:obj.retData.dataList];
                    [self.mainTableView reloadData];
                    [self stopLoading];
                    [self hiddenNotData];
                    
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
    }else{
        
        
    }
    
    [self.mainTableView finishLoading];
    if ([self.dataCount intValue] == self.dataArray.count) {
        [self.mainTableView.mj_footer endRefreshing];
    }
    
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self showNotData];
    [self stopLoading];
    [self.mainTableView finishLoading];
    [self.mainTableView.mj_footer endRefreshing];
    
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
    if (self.dataArray.count >0) {
     
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
            cell.title = currentObj.typeName;
            cell.content = currentObj.title;
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    return YES;
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
        AppointmentServeObj *obj = [AppointmentServeObj getBaseObjFrom:self.dataArray[indexPath.row]];
        vc.objId = obj.currentID;
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
    
        if (self.isActivity) {
          
            AppointmentActivityObj *obj = [AppointmentActivityObj getBaseObjFrom:self.dataArray[indexPath.row]];
            [self sendRequestCancelFav:[NSNumber numberWithInt:2] withUid:obj.currentID];
        }else{
            
            AppointmentServeObj *obj = [AppointmentServeObj getBaseObjFrom:self.dataArray[indexPath.row]];
            [self sendRequestCancelFav:[NSNumber numberWithInt:3] withUid:obj.currentID];
        }
        [self.dataArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [self.mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if (self.dataArray.count == 0) {
            self.mainTableView.hidden = YES;
            [self showNotData];
        }
    }
}

#pragma mark - pullRefreshOfHeader

- (void) pullRefreshOfHeader{

    [self.dataArray removeAllObjects];
    self.page = 1;
    if (self.isActivity) {
      [self sendRequestWithObjTypeId:[NSNumber numberWithInt:2]withPage:self.page];
    }else{
       [self sendRequestWithObjTypeId:[NSNumber numberWithInt:3]withPage:self.page];
    }
}

#pragma mark - pullToLoadingOfFooter

- (void) pullToLoadingOfFooter{
    
        if (self.dataArray.count%PageSize == 0) {
            if (self.dataArray.count != [self.dataCount intValue]) {
                self.page ++;
                if (self.isActivity) {
                    [self sendRequestWithObjTypeId:[NSNumber numberWithInt:2]withPage:self.page];
                }else{
                    
                    [self sendRequestWithObjTypeId:[NSNumber numberWithInt:3]withPage:self.page];
                }
        }else{
        
            [self.mainTableView.mj_footer endRefreshing];
        }
    }else{
        [self.mainTableView.mj_footer endRefreshing];
    }
}
@end
