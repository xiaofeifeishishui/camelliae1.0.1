//
//  ExerciseVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/24.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLActivityAndInfoVC.h"
#import "VCManger.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "CMLActivityTopView.h"
#import "NSString+CMLExspand.h"
#import "AppGroup.h"
#import "NetWorkTask.h"
#import "NetConfig.h"
#import "DataManager.h"
#import "BaseResultObj.h"
#import "NewsObj.h"
#import "ActivityObj.h"
#import "CMLMainPageTVCell.h"
#import "UIScrollView+RefreshHeader.h"
#import "CMLLine.h"
#import "UIColor+SDExspand.h"
#import "CMLCityChooseVC.h"
#import "CMLSettingVC.h"
#import "CMLPersonInfoVC.h"
#import "CMLIntroduceUpgradeVC.h"
#import "CMLLoginInterfaceVC.h"
#import "CMLActivityDetailVC.h"
#import "CMLScrollView.h"
#import "CMLAppointmentVC.h"
#import "CMLInformationDetailVC.h"
#import "CMLCollerctVC.h"
#import "CMLPointsVC.h"
#import "CMLSysNoticeVC.h"
#import "CMLOtherActivityDetailVC.h"
#import "TTUITableViewZoomController.h"
#import "CMLServeModuleModel.h"
#import "CMLServiceModuleBtn.h"
#import "CMLInformationSecondVC.h"
#import "MJRefresh.h"

#define CMLExerciseTopViewHeight   88
#define TabBarViewHeight           98
#define TableViewRowHeight         260

#define BgViewHeight               304

#define PersonCenterImgHeight      93
#define PersonCenterImgWidth       71
#define KUserHeadBtnHeight         130
#define KUserHeadBtnWidth          130
#define KUserTopMargin             80
#define PictureAndNameSpace        18
#define NameAndImageSpace          20

#define CMLNewsPageSize            5
#define CMLActivityPageSize        20

#define EnterPersonVCWidth         7
#define EnterPersonVCHeight        15

@interface CMLActivityAndInfoVC ()<UITableViewDelegate,UITableViewDataSource,NetWorkProtocol,UIScrollViewDelegate,CycleScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *newsArray;

@property (nonatomic,strong) NSMutableArray *activityArray;

@property (nonatomic,assign) RequestType currentRequestType;

@property (nonatomic,assign) NSInteger activityListCount;

@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) UIButton *userHeadBtn;

@property (nonatomic,strong) UIImageView *userImage;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) CMLActivityTopView *topView;

@property (nonatomic,strong) CMLScrollView *carouselFigureScro;

@property (nonatomic,strong) UILabel *nickNameLabel;

@property (nonatomic,strong) UILabel *noActivityLabel;

@end

@implementation CMLActivityAndInfoVC

- (NSMutableArray *)newsArray{

    if (!_newsArray) {
        _newsArray = [NSMutableArray array];
    }
    return _newsArray;
}

- (NSMutableArray *)activityArray{

    if (!_activityArray) {
        _activityArray = [NSMutableArray array];
    }
    return _activityArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 1;

     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.backgroundColor = [UIColor blackColor];
    /**点击个人时的通知接收*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeCurrentInterface)
                                                 name:@"showPersonCenterInterface"
                                               object:nil];
    
    /**活动请求通知*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendActivityRquest)
                                                 name:@"activityRequest"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showCityView)
                                                 name:@"chooseCity"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeCurrentCity)
                                                 name:@"refershActivityViewAndCity"
                                               object:nil];
    
    
    [self loadViews];
    [self laodData];
    
}


- (void) laodData{

    [self getDataListWith:NewsListRequest AndPage:1];
    [self startLoading];
    
}

- (void) loadViews{
    
    /**个人中心*/
    [self setPersonalCenter];
    
    /**设置头*/
    CMLActivityTopView *topView = [[CMLActivityTopView alloc] initWithFrame:CGRectMake(0,
                                                                                       0,
                                                                                       self.view.frame.size.width,
                                                                                       CMLExerciseTopViewHeight*Proportion)];
    self.topView = topView;
    [self.contentView addSubview: self.topView];
    [self.topView refreshCity];
    
    /**轮播图加活动*/
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(topView.frame),
                                                                       self.view.frame.size.width,
                                                                       self.view.frame.size.height - TabBarViewHeight*Proportion - CGRectGetMaxY(topView.frame))
                                                      style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:self.mainTableView];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /**无数据显示*/
    self.noActivityLabel = [[UILabel alloc] init];
    self.noActivityLabel.text = @"该地区暂无活动信息";
    self.noActivityLabel.textColor = [UIColor grayColor];
    [self.noActivityLabel sizeToFit];
    self.noActivityLabel.center = self.mainTableView.center;
    [self.mainTableView addSubview:self.noActivityLabel];
    self.noActivityLabel.hidden = YES;
    /**下拉刷新*/
    
    __weak typeof(self) weakSelf = self;
    [self.mainTableView addPullToRefreshWithPullText:@"CAMELLIAE" pullTextColor:[UIColor blackColor] pullTextFont: KSystemFontSize16 refreshingText:@"Loading...." refreshingTextColor:[UIColor blackColor] refreshingTextFont:KSystemFontSize16 action:^{
        [weakSelf pullRefreshOfHeader];
    }];

    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

}

- (void) loadMoreData{
    [self pullToLoadingOfFooter];
    
}
#pragma mark - 设置个人中心

- (void) setPersonalCenter{

    UIButton *bgView = [[UIButton alloc] initWithFrame:CGRectMake(MovingDistance,
                                                              20,
                                                              MovingDistance*4,
                                                              BgViewHeight*Proportion)];
    bgView.backgroundColor = [UIColor blackColor];
    [bgView addTarget:self action:@selector(enterPersonalInfoVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgView];
    [self.view sendSubviewToBack:bgView];
    
    /**相片切换按键或是登录按键*/
    self.userImage = [[UIImageView alloc] init];
    self.userImage.frame = CGRectMake((MovingDistance*4 - KUserHeadBtnWidth*Proportion)/2,
                                      KUserTopMargin*Proportion,
                                      KUserHeadBtnHeight*Proportion,
                                      KUserHeadBtnHeight*Proportion);
    self.userImage.backgroundColor = [UIColor whiteColor];
    self.userImage.userInteractionEnabled = YES;
    [NetWorkTask setImageView:self.userImage
                      WithURL:[NSURL URLWithString:self.userInfo.gravatar]
             placeholderImage:[UIImage imageNamed:KUserHeadImg]];
    self.userImage.layer.cornerRadius = KUserHeadBtnHeight*Proportion/2;
    self.userImage.layer.masksToBounds=YES;
    [bgView addSubview:self.userImage];

    
    self.userHeadBtn = [[UIButton alloc] initWithFrame:CGRectMake((MovingDistance*4 - KUserHeadBtnWidth*Proportion)/2,
                                                                  KUserTopMargin*Proportion,
                                                                  KUserHeadBtnWidth*Proportion,
                                                                  KUserHeadBtnHeight*Proportion)];
    [self.userHeadBtn addTarget:self action:@selector(enterPersonalInfoVC) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.userHeadBtn];
    
    self.nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel.text = self.userInfo.nickName;
    self.nickNameLabel.textColor = [UIColor whiteColor];
    self.nickNameLabel.font = KSystemFontSize12;
    [self.nickNameLabel sizeToFit];
    self.nickNameLabel.frame = CGRectMake(0, 0, self.nickNameLabel.frame.size.width, self.nickNameLabel.frame.size.height);
    self.nickNameLabel.center = CGPointMake(self.userHeadBtn.center.x, CGRectGetMaxY(self.userHeadBtn.frame)+ PictureAndNameSpace*Proportion + self.nickNameLabel.frame.size.height/2.0);
    [bgView addSubview:self.nickNameLabel];
    
    UIImageView *enterPersonImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nickNameLabel.frame) + NameAndImageSpace*Proportion, self.nickNameLabel.frame.origin.y + (self.nickNameLabel.frame.size.height - EnterPersonVCHeight*Proportion)/2.0, EnterPersonVCWidth*Proportion, EnterPersonVCHeight*Proportion)];
    enterPersonImage.image = [UIImage imageNamed:KEnterPersonVCImg];
    [bgView addSubview:enterPersonImage];
    UIButton *nameBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.nickNameLabel.frame.size.width*2, self.nickNameLabel.frame.size.height*2)];
    nameBtn.center = self.nickNameLabel.center;
    nameBtn.backgroundColor = [UIColor clearColor];
    [nameBtn addTarget:self action:@selector(enterPersonalInfoVC) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:nameBtn];
    
    /**初始化模块按键*/
    CGFloat moduleHeight = (self.view.frame.size.height - 20 - BgViewHeight*Proportion)/3;
    
    /**初始化分割线*/
    CMLLine *verLine = [[CMLLine alloc] init];
    verLine.startingPoint = CGPointMake(3*MovingDistance, BgViewHeight*Proportion +20);
    verLine.lineLength = self.view.frame.size.height;
    verLine.LineColor = [UIColor CMLLineGrayColor];
    verLine.directionOfLine = VerticalLine;
    verLine.lineWidth = 0.5;
    [self.view addSubview:verLine];
    [self.view sendSubviewToBack:verLine];
    
    CMLLine *horLineOne = [[CMLLine alloc] init];
    horLineOne.startingPoint = CGPointMake(MovingDistance, CGRectGetMaxY(bgView.frame)+moduleHeight);
    horLineOne.lineLength = self.view.frame.size.width;
    horLineOne.LineColor = [UIColor CMLLineGrayColor];
    horLineOne.lineWidth = 0.5;
    horLineOne.directionOfLine = HorizontalLine;
    [self.view addSubview:horLineOne];
    [self.view sendSubviewToBack:horLineOne];
    
    CMLLine *horLineTwo = [[CMLLine alloc] init];
    horLineTwo.startingPoint = CGPointMake(MovingDistance, CGRectGetMaxY(bgView.frame) + moduleHeight*2);
    horLineTwo.LineColor = [UIColor CMLLineGrayColor];
    horLineTwo.lineWidth = 0.5;
    horLineTwo.lineLength = self.view.frame.size.width;
    horLineTwo.directionOfLine = HorizontalLine;
    [self.view addSubview:horLineTwo];
    [self.view sendSubviewToBack:horLineTwo];
    
    /**初始化btn*/
    NSArray *imgNameAry = @[KReserveImg,
                            KActivityCollectImg,
                            KMessageImg,
                            KPointsImg,
                            KSettingImg,
                            KMoreNewsImg];
    NSArray *titleArray = @[@"预约管理",@"活动收藏",@"消息",@"积分",@"设置",@"敬请期待"];
    for (int i = 0 ; i < 6; i++) {
    
        UIButton *moduleBtn = [[UIButton alloc] init];
        moduleBtn.backgroundColor = [UIColor whiteColor];
        moduleBtn.tag = i+1;
        if (i%2 == 1) {
        
            moduleBtn.frame = CGRectMake(MovingDistance*3,
                                    BgViewHeight*Proportion + moduleHeight*(i - 1)/2 + 20,
                                    MovingDistance*2,
                                    moduleHeight);
        }else{
            moduleBtn.frame = CGRectMake(MovingDistance,
                                    BgViewHeight*Proportion + moduleHeight*i/2 + 20,
                                    MovingDistance*2,
                                    moduleHeight);
            
        }
        moduleBtn.backgroundColor = [UIColor whiteColor];
        [moduleBtn setImage:[UIImage imageNamed:imgNameAry[i]] forState:UIControlStateNormal];
        [moduleBtn addTarget:self action:@selector(enterPersonModule:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:moduleBtn];
        [self.view sendSubviewToBack:moduleBtn];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = KSystemFontSize12;
        label.textColor = [UIColor blackColor];
        label.text = titleArray[i];
        [label sizeToFit];
        label.frame = CGRectMake(moduleBtn.frame.size.width/2.0 -label.frame.size.width/2.0, CGRectGetMaxX(moduleBtn.imageView.frame) + 20*Proportion, label.frame.size.width, label.frame.size.height);
        [moduleBtn addSubview:label];
    }
    
}

#pragma mark - 通知中心接受信息

- (void) changeCurrentInterface{

    [[VCManger homeVC] hideTabBarView];
    [self moveContentViewWith:LeftMovementDirection];

}


- (void) sendActivityRquest{
    
    [self getDataListWith:ActivityListRequest AndPage:1];

}

- (void) showCityView{

    CMLCityChooseVC *vc = [[CMLCityChooseVC alloc] init];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:^{
        
    }];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.activityArray.count;


}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"myTableViewCell";
    CMLMainPageTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell =[[CMLMainPageTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

    }
    for (int i = 0; i < cell.contentView.subviews.count; i++) {
        UIView *view = [cell viewWithTag:i];
        [view removeFromSuperview];
    }
    if (self.activityArray.count >0) {
         
            ActivityObj *obj = self.activityArray[indexPath.row];
            cell.imgUrl = obj.coverPic;
            cell.memberLevel = [obj.memberLevelId integerValue];
            cell.shortTitle  =  obj.shortTitle;
            [cell reloadTableViewCell];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return TableViewRowHeight*Proportion;

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ActivityObj *obj = self.activityArray[indexPath.row];
    if ([obj.isWebView intValue] == 1) {
     
        CMLOtherActivityDetailVC *vc = [[CMLOtherActivityDetailVC alloc] init];
        vc.url = obj.webViewLink;
        [[VCManger mainVC] pushVC:vc animate:YES];
    }else if ([obj.isWebView intValue] == 2){
    
        CMLActivityDetailVC *vc = [[CMLActivityDetailVC alloc] init];
        vc.objId = obj.activityID;
        vc.currentTitle = @"活动详情";
        [[VCManger mainVC] pushVC:vc animate:YES];
    }

}

#pragma mark - NetWorkProtocol
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    BaseResultObj *baseObj = [BaseResultObj getBaseObjFrom:responseResult];
    NSArray *dataArray = baseObj.retData.dataList;
    
    /**根据请求类型将请求分开*/
    if (self.currentRequestType == NewsListRequest) {

        if ([baseObj.retCode intValue] == 0) {
         
            NSMutableArray *urlArray = [NSMutableArray array];
            NSMutableArray *typeNameArray = [NSMutableArray array];
            for (int i = 0; i < dataArray.count; i++) {
                
                NewsObj *newsObj = [NewsObj getBaseObjFrom:dataArray[i]];
                [urlArray addObject:newsObj.coverPic];
                [typeNameArray addObject:newsObj.typeName];
                [self.newsArray addObject:newsObj];
            }
            if (self.newsArray.count > 0) {
                /**轮播图*/
                self.carouselFigureScro = [[CMLScrollView alloc] initWithFrame:CGRectMake(0,
                                                                                          0,
                                                                                          self.view.frame.size.width,
                                                                                          CarouselFigureScroHeight*Proportion)];
                self.carouselFigureScro.delegate = self;
                self.carouselFigureScro.autoTime = 4.0f;
                self.carouselFigureScro.autoScroll = NO;
                self.carouselFigureScro.backgroundColor = [UIColor whiteColor];
                self.carouselFigureScro.urlArray = urlArray;
                self.carouselFigureScro.typeNameArray = typeNameArray;
                self.mainTableView.tableHeaderView = self.carouselFigureScro;
                [self.mainTableView reloadData];
            }
            /**分开请求活动和资讯*/
            [[NSNotificationCenter defaultCenter] postNotificationName:@"activityRequest" object:nil];
        }
        
    }else{
        
        if (baseObj.retData.dataCount) {
          self.activityListCount = [baseObj.retData.dataCount integerValue];
        }
        
        for (int i = 0; i < dataArray.count; i++) {
            
             ActivityObj *activityObj = [ActivityObj getBaseObjFrom:dataArray[i]];
            [self.activityArray addObject:activityObj];
        }
        if (self.activityArray.count == 0) {
            self.noActivityLabel.hidden = NO;
        }else{
            self.noActivityLabel.hidden = YES;
        }

        [self.mainTableView reloadData];
        __weak typeof(UITableView *) weakTableView = self.mainTableView;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakTableView finishLoading];
        });
        
    }
    if ([baseObj.retData.dataCount intValue] == self.activityArray.count) {
        [self.mainTableView.mj_footer endRefreshing];
    }
    
    [self stopLoading];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    /**无网络状态直接结束*/
    [self.mainTableView finishLoading];
    [self stopLoading];
    

}


#pragma mark - 网络请求


- (void) getDataListWith:(RequestType) type AndPage:(int) page{

    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    if (type == NewsListRequest) {
        
    }else{
        [paraDic setObject:[NSNumber numberWithInt:CMLActivityPageSize] forKey:@"pageSize"];
        [paraDic setObject:[[DataManager lightData] readCityID] forKey:@"provinceId"];
        [paraDic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    }
    [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
    NSString *skey = [[DataManager lightData] readSkey];
    if (skey) {
       [paraDic setObject:skey forKey:@"skey"];
    }else{
        [paraDic setObject:@"" forKey:@"skey"];
    }
    
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    self.currentRequestType = type;
    if (type == NewsListRequest) {
       [NetWorkTask postResquestWithApiName:NewsRecomm
                                    paraDic:paraDic
                                   delegate:delegate];
    }else{
        [NetWorkTask postResquestWithApiName:ActivityList
                                     paraDic:paraDic
                                    delegate:delegate];
    }

}


#pragma mark - 下拉刷新

- (void) pullRefreshOfHeader{
    
    self.page = 1;
   [self.activityArray removeAllObjects];
   [self getDataListWith:ActivityListRequest AndPage:1];
    
}

#pragma mark - 上拉加载

- (void) pullToLoadingOfFooter{

    if (self.activityArray.count%CMLActivityPageSize == 0) {
        
        if (self.activityListCount != self.activityArray.count) {
            self.page++;
            [self getDataListWith:ActivityListRequest AndPage:(int)self.page];

        }else{
            [self.mainTableView.mj_footer endRefreshing];
        }
        
    }else{
        
        [self.mainTableView.mj_footer endRefreshing];
        
    }
}

#pragma mark - enterPersonModule

- (void) enterPersonModule:(UIButton *) button {

    if (button.tag == 1) {
        
        CMLAppointmentVC *vc = [[CMLAppointmentVC alloc] init];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }else if (button.tag == 2){
        
        CMLCollerctVC *vc = [[CMLCollerctVC alloc] init];
        [[VCManger mainVC] pushVC:vc animate:YES];
    
    }else if (button.tag == 3){
        CMLSysNoticeVC *vc = [[CMLSysNoticeVC alloc] init];
        [[VCManger mainVC] pushVC:vc animate:YES];
    
    }else if (button.tag == 4){
        
        CMLPointsVC *vc = [[CMLPointsVC alloc] init];
        [[VCManger mainVC] pushVC:vc animate:YES];
    
    }else if (button.tag == 5){
    
        CMLSettingVC *vc = [[CMLSettingVC alloc] init];
        [[VCManger mainVC] pushVC:vc animate:YES];
        
    }else if (button.tag == 6){
    
    }
    
}

#pragma mark -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[VCManger homeVC] appearTabBarView];
    [self reductionContentPlace];
    
}

#pragma mark - enterPersonalInfoVC

- (void) enterPersonalInfoVC{

    CMLPersonInfoVC *vc = [[CMLPersonInfoVC alloc] init];
    vc.userInfo = self.userInfo;
    [[VCManger mainVC] pushVC:vc animate:YES];

}

#pragma mark - Clicked
- (void)clickImgAtIndex:(NSInteger)index{

    CMLInformationSecondVC *vc = [[CMLInformationSecondVC alloc] init];
    NewsObj *obj = self.newsArray[index];
    vc.currentInformationType = obj.typeId;
    vc.currenttitle = obj.typeName;
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}

#pragma mark - changeCurrentCity

- (void) changeCurrentCity {

    [self.topView refreshCity];

    [self startLoading];
    [self pullRefreshOfHeader];
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // Get visible cells on table view.
    NSArray *visibleCells = [self.mainTableView visibleCells];
    
    for (CMLMainPageTVCell *cell in visibleCells) {
        [cell cellOnTableView:self.mainTableView didScrollOnView:self.view];
    }
}
@end
