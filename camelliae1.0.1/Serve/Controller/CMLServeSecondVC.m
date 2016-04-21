//
//  CMLServeOfTravelVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/30.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLServeSecondVC.h"
#import "CommonNumber.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "VCManger.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "NetConfig.h"
#import "NetWorkDelegate.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "NSString+CMLExspand.h"
#import "BaseResultObj.h"
#import "CMLServeObj.h"
#import "NSDate+CMLExspand.h"
#import "CMLServeDetailVC.h"
#import "UIScrollView+RefreshHeader.h"
#import "CMLRefreshFooter.h"
#import "CMLServeTVCell.h"

#define ModuleHeight       260

#define PageSize           20

@interface CMLServeSecondVC () <NavigationBarDelegate,NetWorkProtocol,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) CMLRefreshFooter *refreshFooter;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSNumber *dataCount;

@end

@implementation CMLServeSecondVC

- (NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad{

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor CMLVIPGrayColor];
    self.navBar.titleContent = self.currenttitle;
    self.navBar.titleColor = [UIColor CMLTitleYellowColor];
    self.navBar.backgroundColor = [UIColor blackColor];
    self.navBar.navigationBarDelegate = self;
    [self.navBar setWhiteLeftBarItem];
    self.page = 1;
    
    [self LoadViews];
    
    [self loadData];
    

}

- (void) loadData{

    [self setNetWorkWithType:self.currentServeType andPage:1];
    [self startLoading];

}
- (void) LoadViews{
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                      CGRectGetMaxY(self.navBar.frame), self.view.frame.size.width,
                                                                       self.contentView.frame.size.height - CGRectGetHeight(self.navBar.frame)) style:UITableViewStylePlain];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    self.mainTableView.hidden = YES;
    [self.contentView addSubview:self.mainTableView];
    
    /**下拉刷新*/
    
    __weak typeof(self) weakSelf = self;
    [self.mainTableView addPullToRefreshWithPullText:@"CAMELLIAE" pullTextColor:[UIColor blackColor] pullTextFont: KSystemFontSize16 refreshingText:@"Loading...." refreshingTextColor:[UIColor blackColor] refreshingTextFont:KSystemFontSize16 action:^{
        [weakSelf pullRefreshOfHeader];
    }];
    
    /**上拉加载*/
    self.refreshFooter = [[CMLRefreshFooter alloc] init];
    self.refreshFooter.scrollView = self.mainTableView;
    [self.refreshFooter footer];
    __block CMLServeSecondVC *vc = self;
    self.refreshFooter.beginRefreshingBlock = ^(){
        [vc.refreshFooter beginRefreshing];
        [vc pullToLoadingOfFooter];
        
    };


}


- (void) setNetWorkWithType:(NSNumber *) type andPage:(int) page{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:type forKey:@"serveType"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    
    [NetWorkTask postResquestWithApiName:ProjectList paraDic:paraDic delegate:delegate];
    
    

}

#pragma mark - enterServeDetail

- (void) enterServeDetail: (UIButton *) button{

    CMLServeDetailVC *vc = [[CMLServeDetailVC alloc] init];
    vc.currentTitle = @"服务详情";
    CMLServeObj *serveModel =  [CMLServeObj getBaseObjFrom:self.dataArray[button.tag]];
    vc.objId = serveModel.serveID;
    
    [[VCManger mainVC] pushVC:vc animate:YES];

}

#pragma mark - NavigationBarDelegate

- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] dismissCurrentVC];
}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    if ([obj.retCode intValue] == 0) {
        self.dataCount = obj.retData.dataCount;
        if (obj.retData.dataList.count > 0) {
            
            [self.dataArray addObjectsFromArray:obj.retData.dataList];
            self.mainTableView.hidden = NO;
            [self.mainTableView reloadData];
            [self.refreshFooter endRefreshing];
            [self hiddenNotData];
        }else{
        
            [self.refreshFooter endRefreshing];
            self.mainTableView.hidden = YES;
            [self showNotData];
        }
        [self.mainTableView finishLoading];
        
    }else{
    
        [self.mainTableView finishLoading];
        [self.refreshFooter endRefreshing];
        [self showAlterViewWithText:obj.retMsg];
        self.mainTableView.hidden = YES;
        [self showNotData];
    }
    [self.refreshFooter endRefreshing];
    [self stopLoading];

}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self.mainTableView finishLoading];
    self.mainTableView.hidden = YES;
    [self stopLoading];
    [self showNotData];

}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return ModuleHeight*Proportion;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"myTableViewCell";
    
    CMLServeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[CMLServeTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    for (int i = 0; i < cell.contentView.subviews.count; i++) {
        UIView *view = [cell viewWithTag:i];
        [view removeFromSuperview];
    }
    if (self.dataArray.count > 0) {
        /**get model*/
        CMLServeObj *serveModel =  [CMLServeObj getBaseObjFrom:self.dataArray[indexPath.row]];
        cell.serveName = serveModel.shortTitle;
        cell.imageUrl = serveModel.coverPic;
        [cell refreshTableViewCell];
        
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CMLServeDetailVC *vc = [[CMLServeDetailVC alloc] init];
    vc.currentTitle = @"服务详情";
    CMLServeObj *serveModel =  [CMLServeObj getBaseObjFrom:self.dataArray[indexPath.row]];
    vc.objId = serveModel.serveID;
    [[VCManger mainVC] pushVC:vc animate:YES];
    

}
#pragma mark - 下拉刷新

- (void) pullRefreshOfHeader{
  
    self.page = 1;
   [self.dataArray removeAllObjects];
   [self setNetWorkWithType:self.currentServeType andPage:1];
    
}

#pragma mark - 上拉加载

- (void) pullToLoadingOfFooter{

    if (self.dataArray.count < [self.dataCount intValue]) {
     
        if (self.dataArray.count%20 == 0) {
            
            self.page++;
            [self setNetWorkWithType:self.currentServeType andPage:self.page];
        }
        
    }else{
        
        [self.refreshFooter endRefreshing];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // Get visible cells on table view.
    NSArray *visibleCells = [self.mainTableView visibleCells];
    for (CMLServeTVCell *cell in visibleCells) {
        [cell cellOnTableView:self.mainTableView didScrollOnView:self.view];
    }
}
@end
