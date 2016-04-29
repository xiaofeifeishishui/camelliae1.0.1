//
//  CMLSysNoticeVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/4/10.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLSysNoticeVC.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "NetConfig.h"
#import "NetWorkDelegate.h"
#import "NetWorkTask.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "VCManger.h"
#import "UIColor+SDExspand.h"
#import "BaseResultObj.h"
#import "CMLSysNoticeTVCell.h"
#import "CMLSysNoticeObj.h"
#import "UIScrollView+RefreshHeader.h"
#import "CMLSysDetailNoticeVC.h"
#import "MJRefresh.h"

#define PageSize   20

@interface CMLSysNoticeVC () <NavigationBarDelegate,UITableViewDelegate,UITableViewDataSource,NetWorkProtocol>

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;

@property (nonatomic,assign) CGFloat currentRowHeight;

@property (nonatomic,strong) BaseResultObj *obj;

@end

@implementation CMLSysNoticeVC


- (NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentView.backgroundColor = [UIColor CMLVIPGrayColor];
    self.navBar.titleContent = @"消息";
    self.navBar.titleColor = [UIColor CMLTitleYellowColor];
    self.navBar.backgroundColor = [UIColor blackColor];
    self.navBar.navigationBarDelegate = self;
    [self.navBar setWhiteLeftBarItem];
    
    self.page = 1;
    
    [self loadViews];
    
    [self loadData];
}

- (void) loadViews{

   
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.navBar.frame),
                                                                       self.view.frame.size.width,
                                                                       self.contentView.frame.size.height - CGRectGetHeight(self.navBar.frame)) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.hidden = YES;
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    self.mainTableView.tableHeaderView = [[UIView alloc] init];
    self.mainTableView.backgroundColor = [UIColor CMLVIPGrayColor];
    [self.contentView addSubview:self.mainTableView];
    /**下拉刷新*/
    
    __weak typeof(self) weakSelf = self;
    [self.mainTableView addPullToRefreshWithPullText:@"CAMELLIAE" pullTextColor:[UIColor blackColor] pullTextFont: KSystemFontSize16 refreshingText:@"Loading...." refreshingTextColor:[UIColor blackColor] refreshingTextFont:KSystemFontSize16 action:^{
        [weakSelf pullRefreshOfHeader];
    }];
    
    /**上拉*/
   self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void) loadMoreData{
    [self pullToLoadingOfFooter];
    
}
- (void) loadData{

     [self startLoading];
    [self.dataArray removeAllObjects];
    [self setNetworkWithPage:self.page];

}

- (void) setNetworkWithPage:(int) page{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [NetWorkTask postResquestWithApiName:SysNotice paraDic:paraDic delegate:delegate];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
    

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"myTableViewCell";
    
    CMLSysNoticeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[CMLSysNoticeTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (self.dataArray.count > 0) {
        
        CMLSysNoticeObj *obj = [CMLSysNoticeObj getBaseObjFrom:self.dataArray[indexPath.row]];
        cell.currentTitle = obj.title;
        cell.currentText = obj.briefIntro;
        self.currentRowHeight = [cell getRowHeight];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return self.currentRowHeight;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CMLSysNoticeObj *obj = [CMLSysNoticeObj getBaseObjFrom:self.dataArray[indexPath.row]];
    CMLSysDetailNoticeVC *vc = [[CMLSysDetailNoticeVC alloc] init];
    vc.currentID = obj.currentID;
    [[VCManger mainVC] pushVC:vc animate:YES];
    

}

#pragma mark - NavigationBarDelegate
- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    [self stopLoading];
    self.obj = [BaseResultObj getBaseObjFrom:responseResult];
    
    if ([self.obj.retCode intValue] == 0) {
      
        [self hiddenNotData];
        self.mainTableView.hidden = NO;
        [self.dataArray addObjectsFromArray:self.obj.retData.dataList];
        [self.mainTableView reloadData];
        
    }else{
    
        [self showNotData];
        [self showAlterViewWithText:self.obj.retMsg];
        
    }
    [self.mainTableView finishLoading];
    [self.mainTableView.mj_footer endRefreshing];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self showNotData];
    [self stopLoading];
    [self.mainTableView.mj_footer endRefreshing];
    [self.mainTableView finishLoading];
}

- (void) pullToLoadingOfFooter{

    if (self.dataArray.count < [self.obj.retData.dataCount intValue]) {
     
        if (self.dataArray.count%PageSize == 0) {
            
            self.page++;
            
            [self setNetworkWithPage:self.page];
        }else{
            [self.mainTableView.mj_footer endRefreshing];
        }
    }else{
        [self.mainTableView.mj_footer endRefreshing];
    }
}

- (void) pullRefreshOfHeader{

    self.page = 1;
    [self.dataArray removeAllObjects];
    [self setNetworkWithPage:self.page];
}
@end
