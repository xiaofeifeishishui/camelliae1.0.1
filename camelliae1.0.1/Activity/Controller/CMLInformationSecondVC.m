//
//  CMLInformationSecondVC.m
//  camelliae1.0.1
//
//  Created by 张越 on 16/4/21.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLInformationSecondVC.h"
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
#import "NewsObj.h"
#import "NSDate+CMLExspand.h"
#import "UIScrollView+RefreshHeader.h"
#import "CMLInfomationTVCell.h"
#import "CMLInformationDetailVC.h"
#import "MJRefresh.h"
#define ModuleHeight       280

#define PageSize           20

@interface CMLInformationSecondVC () <NavigationBarDelegate,NetWorkProtocol,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSNumber *dataCount;

@property (nonatomic,strong) NSMutableArray *cellShowAnimationArray;

@end

@implementation CMLInformationSecondVC

- (NSMutableArray *)cellShowAnimationArray{
    
    if (!_cellShowAnimationArray) {
        _cellShowAnimationArray = [NSMutableArray array];
    }
    return _cellShowAnimationArray;
}

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
    
    [self setNetWorkWithType:self.currentInformationType andPage:1];
    [self startLoading];
    
}
- (void) LoadViews{
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.navBar.frame), self.view.frame.size.width,
                                                                       self.contentView.frame.size.height - CGRectGetHeight(self.navBar.frame)) style:UITableViewStylePlain];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor CMLVIPGrayColor];
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    self.mainTableView.hidden = YES;
    [self.contentView addSubview:self.mainTableView];
    
    /**下拉刷新*/
    
    __weak typeof(self) weakSelf = self;
    [self.mainTableView addPullToRefreshWithPullText:@"CAMELLIAE" pullTextColor:[UIColor blackColor] pullTextFont: KSystemFontSize16 refreshingText:@"Loading...." refreshingTextColor:[UIColor blackColor] refreshingTextFont:KSystemFontSize16 action:^{
        [weakSelf pullRefreshOfHeader];
    }];
    
   /**上拉加载*/

    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
}

- (void) loadMoreData{
    [self pullToLoadingOfFooter];
    
}

- (void) setNetWorkWithType:(NSNumber *) type andPage:(int) page{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:type forKey:@"objType"];
    [paraDic setObject:[NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    [paraDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    
    [NetWorkTask postResquestWithApiName:NewsList paraDic:paraDic delegate:delegate];
    
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
        if (obj.retData.dataCount) {
           self.dataCount = obj.retData.dataCount;
        }
        
        if (obj.retData.dataList.count > 0) {
            
            [self.dataArray addObjectsFromArray:obj.retData.dataList];
            self.mainTableView.hidden = NO;
            [self.mainTableView reloadData];
            [self hiddenNotData];
        }else{
            
            self.mainTableView.hidden = YES;
            [self showNotData];
        }
        [self.mainTableView finishLoading];
        
    }else{
        
        [self.mainTableView finishLoading];
        
        [self showAlterViewWithText:obj.retMsg];
        self.mainTableView.hidden = YES;
        [self showNotData];
    }
    
    [self.mainTableView.mj_footer endRefreshing];
    [self performSelector:@selector(stopLoadingOfMainView) withObject:nil afterDelay:1.5];
    
}

- (void) stopLoadingOfMainView{
   [self stopLoading];

}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self.mainTableView.mj_footer endRefreshing];
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
    
    CMLInfomationTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[CMLInfomationTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(CMLInfomationTVCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count >0) {
        NewsObj *newsModel =  [NewsObj getBaseObjFrom:self.dataArray[indexPath.row]];
        
        BOOL isShowAnimation = NO;
        
        for (NSIndexPath *existIndexPath in self.cellShowAnimationArray) {
            if (existIndexPath.row == indexPath.row) {
                isShowAnimation = YES;
            }
        }
        if (!isShowAnimation) {
            
            /**动画只做一次*/
            [self.cellShowAnimationArray addObject:indexPath];
            
            CATransform3D rotation;//3D旋转
            
            rotation = CATransform3DMakeTranslation(0 ,50 ,20);
            //逆时针旋转
            
            rotation = CATransform3DScale(rotation, 0.9, 0.9, 1);
            
            rotation.m34 = 1.0/ -600;
            
            cell.layer.shadowColor = [[UIColor blackColor]CGColor];
            cell.layer.shadowOffset = CGSizeMake(10, 10);
            cell.alpha = 0;
            
            cell.layer.transform = rotation;
            
            [UIView beginAnimations:@"rotation" context:NULL];
            //旋转时间
            [UIView setAnimationDuration:0.6];
            cell.layer.transform = CATransform3DIdentity;
            cell.alpha = 1;
            cell.layer.shadowOffset = CGSizeMake(0, 0);
            [UIView commitAnimations];
        }
        
        cell.imageUrl = newsModel.coverPic;
        cell.imageID = [NSString stringWithFormat:@"%@%@",newsModel.typeId,newsModel.newsID];
        [cell refreshTableViewCell];
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CMLInformationDetailVC *vc = [[CMLInformationDetailVC alloc] init];
    vc.currentTitle = @"服务详情";
    NewsObj *newsModel =  [NewsObj getBaseObjFrom:self.dataArray[indexPath.row]];
    vc.objId = newsModel.newsID;
    vc.currentTitle = newsModel.typeName;
    [[VCManger mainVC] pushVC:vc animate:YES];
    
    
}
#pragma mark - 下拉刷新

- (void) pullRefreshOfHeader{
    
    self.page = 1;
    [self.dataArray removeAllObjects];
    [self setNetWorkWithType:self.currentInformationType andPage:1];
    
}

#pragma mark - 上拉加载

- (void) pullToLoadingOfFooter{
    
        
    if (self.dataArray.count%20 == 0) {
        if (self.dataArray.count != [self.dataCount intValue]) {
            self.page++;
            [self setNetWorkWithType:self.currentInformationType andPage:self.page];
        }else{
           
            [self.mainTableView.mj_footer endRefreshing];
        }
    }else{
        
        
        [self.mainTableView.mj_footer endRefreshing];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // Get visible cells on table view.
    NSArray *visibleCells = [self.mainTableView visibleCells];
    for (CMLInfomationTVCell *cell in visibleCells) {
        [cell cellOnTableView:self.mainTableView didScrollOnView:self.view];
    }
}
@end

