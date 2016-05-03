//
//  CMLActivityDetailVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/4/6.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLActivityDetailVC.h"
#import <WebKit/WebKit.h>
#import "VCManger.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "BaseResultObj.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "NSString+CMLExspand.h"
#import "GTMBase64.h"
#import "BaseResultObj.h"
#import "UIColor+SDExspand.h"
#import "CMLCustomAlterView.h"
#import "NSDate+CMLExspand.h"
#import "CMLLine.h"
#import "WXApi.h"
#import "UMSocial.h"
#import "UIImage+CMLExspand.h"
#import "CMLCommentListTVCell.h"
#import "CommentObj.h"
#import "MJRefresh.h"

#define Duration                  0.5f
#define FunctionViewHeight        83
#define ButtonWidth               26
#define ShareBtnHeight            37
#define CollectBtnHeightAndWidth  37
#define ShareButtonLeftMargin     83
#define ButtonSpace               175
#define AppointmentBntLeftMargin  110
#define ButtonTopMargin           10
#define ButonLabelTopMargin       5

#define DetailInfoSpace           15
#define DetailInfoLeftMargin      25

#define DetailTopImageHeight      304
#define DetailTitleTopMargin      20
#define DetailTitleBottomMargin   23
#define DetailAddressLeftMargin   36

#define ShareMainViewHeight              195
#define CancelShareBtnHeight             60
#define ShareBtnTopMargin                26
#define ShareBtnWidthAndHeight           58
#define ShareTypeNameTopMargin           16

#define InputViewHeight                  300
#define commentBtnHeight                 100
#define commentBtnWidth                  200

#define PageSize                         20

@interface CMLActivityDetailVC ()<NavigationBarDelegate,NetWorkProtocol,UIWebViewDelegate,UIScrollViewDelegate,WXApiDelegate,WKUIDelegate,WKNavigationDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong) WKWebView *webView;

@property (nonatomic,strong) UIView *webBrowserView;

@property (nonatomic,assign) CGFloat currentOffSetY;

@property (nonatomic,strong) UIView *functionView;

@property (nonatomic,strong) UIButton *collectBtn;

@property (nonatomic,strong) UIImageView *collectBtnImge;

@property (nonatomic,strong) UIButton *appointmentBtn;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UIView *shareBigBGView;

@property (nonatomic,strong) UIView *shareMainBgView;

@property (nonatomic,strong) UIImage *shareImage;

@property (nonatomic,strong) UIImage *shareToSinaImage;

@property (nonatomic,strong) UIView *commentTxtMainView;

@property (nonatomic,strong) UITextView *commentTextView;

@property (nonatomic,strong) UIView *textFieldBigBGView;

@property (nonatomic,assign) CGFloat currentOffSet;

@property (nonatomic,assign) CGFloat currentOffSetOfTableView;


@property (nonatomic,strong) UITableView *commentTableView;

@property (nonatomic,strong) BaseResultObj *commentrootObj;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UILabel *noCommentLabel;

@property (nonatomic,strong) UIView *alterView;

@end

@implementation CMLActivityDetailVC

- (NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.titleContent = self.currentTitle;
    self.navBar.titleColor = [UIColor CMLTitleYellowColor];
    self.navBar.navigationBarDelegate = self;
    [self.navBar setWhiteLeftBarItem];
    [self.navBar setShareBarItem];
    self.navBar.backgroundColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor CMLVIPGrayColor];
    
    self.page = 1;
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [self loadViews];
    [self setNetWork];
    
}

- (void) loadViews{
    
    /**功能条*/
    self.functionView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 self.contentView.frame.size.height - FunctionViewHeight*Proportion,
                                                                 self.view.frame.size.width,
                                                                 FunctionViewHeight*Proportion)];
    self.functionView.backgroundColor = [UIColor CMLVIPGrayColor];
    
    UIImageView *shareBtnImge = [[UIImageView alloc] initWithFrame:CGRectMake(ShareButtonLeftMargin*Proportion,
                                                                              ButtonTopMargin*Proportion,
                                                                              ShareBtnHeight*Proportion,
                                                                              ShareBtnHeight*Proportion)];
    shareBtnImge.userInteractionEnabled = YES;
    shareBtnImge.image = [UIImage imageNamed:KFeedbackImg];
    [self.functionView addSubview:shareBtnImge];
    
    /**share*/
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(ShareButtonLeftMargin*Proportion - (FunctionViewHeight*Proportion - ButtonWidth*Proportion)/2.0,
                                                                    0,
                                                                    FunctionViewHeight*Proportion,
                                                                    FunctionViewHeight*Proportion)];
    [shareBtn addTarget:self action:@selector(shareCurrentPage) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.backgroundColor = [UIColor clearColor];
    [self.functionView addSubview:shareBtn];
    
    UILabel *shareLabel = [[UILabel alloc] init];
    shareLabel.text = @"评论";
    shareLabel.textColor = [UIColor blackColor];
    shareLabel.font = KSystemFontSize9;
    [shareLabel sizeToFit];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.frame = CGRectMake(shareBtnImge.center.x - shareLabel.frame.size.width/2.0,
                                  CGRectGetMaxY(shareBtnImge.frame)+ ButonLabelTopMargin*Proportion,
                                  shareLabel.frame.size.width,
                                  shareLabel.frame.size.height);
    [self.functionView addSubview:shareLabel];
    
    
    self.commentTxtMainView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      CGRectGetMaxY(self.contentView.frame),
                                                                      self.view.frame.size.width,
                                                                      InputViewHeight*Proportion+commentBtnHeight*Proportion)];
    self.commentTxtMainView.backgroundColor = [UIColor lightGrayColor];

    self.commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0,
                                                                       commentBtnHeight*Proportion,
                                                                       self.view.frame.size.width,
                                                                       InputViewHeight*Proportion)];
    self.commentTextView.font = KSystemFontSize14;
    self.commentTextView.delegate = self;
    self.commentTextView.backgroundColor = [UIColor lightTextColor];
    [self.commentTxtMainView addSubview:self.commentTextView];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     commentBtnWidth*Proportion,
                                                                     commentBtnHeight*Proportion)];
    [cancelBtn addTarget:self action:@selector(cancelComment) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = KSystemFontSize14;
    cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                 -cancelBtn.frame.size.width/2.0,
                                                 0,
                                                 0);
    [self.commentTxtMainView addSubview:cancelBtn];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - commentBtnWidth*Proportion,
                                                                      0,
                                                                      commentBtnWidth*Proportion,
                                                                      commentBtnHeight*Proportion)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = KSystemFontSize14;
    confirmBtn.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                  cancelBtn.frame.size.width/2.0,
                                                  0,
                                                  0);
    [confirmBtn addTarget:self action:@selector(confrimComment) forControlEvents:UIControlEventTouchUpInside];
    [self.commentTxtMainView addSubview:confirmBtn];
    
    
    
    
    /**收藏按键*/
    
    
    self.collectBtnImge = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(shareBtnImge.frame) + ButtonSpace*Proportion,
                                                                        ButtonTopMargin*Proportion,
                                                                        CollectBtnHeightAndWidth*Proportion,
                                                                        CollectBtnHeightAndWidth*Proportion)];
    self.collectBtnImge.userInteractionEnabled = YES;
    [self.functionView addSubview:self.collectBtnImge];
    
    UIButton *collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.collectBtnImge.frame.origin.x - (FunctionViewHeight*Proportion - CollectBtnHeightAndWidth*Proportion)/2.0,
                                                                      0,
                                                                      FunctionViewHeight*Proportion,
                                                                      FunctionViewHeight*Proportion)];
    self.collectBtn = collectBtn;
    collectBtn.backgroundColor = [UIColor clearColor];
    [collectBtn addTarget:self action:@selector(collectCurrentInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.functionView addSubview:self.collectBtn];
    
    UILabel *collectLabel = [[UILabel alloc] init];
    collectLabel.text = @"收藏";
    collectLabel.textColor = [UIColor blackColor];
    collectLabel.textAlignment =NSTextAlignmentCenter;
    collectLabel.font = KSystemFontSize9;
    [collectLabel sizeToFit];
    collectLabel.frame = CGRectMake(self.collectBtnImge.center.x - collectLabel.frame.size.width/2.0,
                                    CGRectGetMaxY(self.collectBtnImge.frame)+ ButonLabelTopMargin*Proportion,
                                    collectLabel.frame.size.width,
                                    collectLabel.frame.size.height);
    [self.functionView addSubview:collectLabel];
    
    self.appointmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(collectBtn.frame) + AppointmentBntLeftMargin*Proportion,
                                                                          0,
                                                                          self.functionView.frame.size.width - (CGRectGetMaxX(collectBtn.frame) + AppointmentBntLeftMargin*Proportion),
                                                                          self.functionView.frame.size.height)];
    [self.appointmentBtn setBackgroundColor:[UIColor blackColor]];
    [self.appointmentBtn setTitle:@"立即预约" forState:UIControlStateNormal];
    [self.appointmentBtn setTitle:@"已经预约" forState:UIControlStateSelected];
    self.appointmentBtn.titleLabel.font = KSystemFontSize15;
    [self.appointmentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.appointmentBtn addTarget:self action:@selector(makeAppointmentImmediately) forControlEvents:UIControlEventTouchUpInside];
    [self.functionView addSubview:self.appointmentBtn];
    
    
    
    /**主界面*/
    CGFloat screenW = self.view.frame.size.width - 20;
    
    NSString *js = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport');  meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
                    "var sty = document.createElement('style');"
                    "sty.innerHTML = 'img {width:%fpx;}';"
                    "document.getElementsByTagName('head')[0].appendChild(sty);",screenW];
    
    // 根据JS字符串初始化WKUserScript对象
    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    // 根据生成的WKUserScript对象，初始化WKWebViewConfiguration
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.userContentController addUserScript:script];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetMaxY(self.navBar.frame),
                                                               self.view.frame.size.width,
                                                               self.contentView.frame.size.height - self.navBar.frame.size.height - self.functionView.frame.size.height) configuration:config];
    self.webView.UIDelegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.navigationDelegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    
    self.alterView = [[UIView alloc] initWithFrame:CGRectMake(0, self.webView.frame.size.height, self.view.frame.size.width, 40)];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"评论";
    label.font = KSystemFontSize11;
    [label sizeToFit];
    label.frame =CGRectMake(36*Proportion,
                            self.alterView.frame.size.height/2.0 - label.frame.size.height/2.0,
                            label.frame.size.width,
                            label.frame.size.height);
    
    CMLLine *line = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake(CGRectGetMaxX(label.frame) + 10 , label.center.y);
    line.directionOfLine = HorizontalLine;
    line.lineWidth = 0.3;
    line.LineColor = [UIColor CMLCommentTimeGrayColor];
    line.lineLength = self.view.frame.size.width - CGRectGetMaxX(label.frame);
    [self.alterView addSubview:line];
    [self.alterView addSubview:label];
    /**主界面和功能条隐藏*/
    self.functionView.hidden = YES;
    self.webView.hidden = YES;

}


- (void) setNetWork{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *objId = self.objId;
    if (objId) {
     [paraDic setObject:self.objId forKey:@"objId"];
    }
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.objId,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    if (objId) {
     
        [NetWorkTask postResquestWithApiName:ActivityInfo paraDic:paraDic delegate:delegate];
        self.currentApiName = ActivityInfo;
        [self startLoading];
    }else{
        [self showNotData];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
    [self stopLoading];
    [self showAlterViewWithText:@"加载失败"];
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}
#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
    
    if ([self.currentApiName isEqualToString:ActivityInfo]) {
        
        self.obj =[BaseResultObj getBaseObjFrom:responseResult];
        
        NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.obj.retData.coverPic]];
        UIImage *image = [UIImage imageWithData:imageNata];
        self.shareToSinaImage = image;
        UIImage *transitImage = [UIImage scaleToRect:image];
        self.shareImage = [UIImage scaleToSize:transitImage size:CGSizeMake(60, 60)];
        
        if ([self.obj.retCode intValue] == 0) {
            
            self.functionView.hidden = NO;
            self.webView.hidden = NO;
            
            NSData *data =[[NSData alloc] initWithBase64EncodedString:self.obj.retData.content options:0];
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

            /**加表头*/
            UIView *headerView = [[UIView alloc] init];
            CGFloat height =[self addSubViewsTo:headerView];
            headerView.frame = CGRectMake(0, -height, self.view.frame.size.width, height);
            
            [self.webView loadHTMLString:str baseURL:nil];
            self.webBrowserView = self.webView.scrollView.subviews[0];
            [UIView animateWithDuration:1 animations:^{
              self.webView.scrollView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
            }];
            
            [self.webView.scrollView addSubview:headerView];
            [self.contentView addSubview:self.webView];
            
            /**comment*/
            self.commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                                  CGRectGetMaxY(self.contentView.frame)- self.functionView.frame.size.height,
                                                                                  self.view.frame.size.width, self.contentView.frame.size.height - CGRectGetMaxY(self.navBar.frame) - self.functionView.frame.size.height)
                                                                 style:UITableViewStylePlain];
            self.commentTableView.delegate = self;
            self.commentTableView.dataSource = self;
            self.commentTableView.tableFooterView = [[UIView alloc] init];
            [self.contentView addSubview:self.commentTableView];
            
            self.noCommentLabel = [[UILabel alloc] init];
            self.noCommentLabel.text = @"暂无评论";
            self.noCommentLabel.textColor = [UIColor CMLCommentTimeGrayColor];
            self.noCommentLabel.font = KSystemFontSize14;
            [self.noCommentLabel sizeToFit];
            self.noCommentLabel.frame = CGRectMake(self.commentTableView.frame.size.width/2.0 - self.noCommentLabel.frame.size.width/2.0, 100, self.noCommentLabel.frame.size.width, self.noCommentLabel.frame.size.height);
            
            [self.commentTableView addSubview:self.noCommentLabel];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
            UILabel *label = [[UILabel alloc] init];
            label.text = @"评论";
            label.font = KSystemFontSize11;
            [label sizeToFit];
            label.frame =CGRectMake(36*Proportion,
                                    view.frame.size.height/2.0 - label.frame.size.height/2.0,
                                    label.frame.size.width,
                                    label.frame.size.height);
            
            CMLLine *line = [[CMLLine alloc] init];
            line.startingPoint = CGPointMake(CGRectGetMaxX(label.frame) + 10 , label.center.y);
            line.directionOfLine = HorizontalLine;
            line.lineWidth = 0.3;
            line.LineColor = [UIColor CMLCommentTimeGrayColor];
            line.lineLength = self.view.frame.size.width - CGRectGetMaxX(label.frame);
            [view addSubview:line];
            [view addSubview:label];
            
            self.commentTableView.tableHeaderView = view;
            
            /**上拉加载*/
            self.commentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

            [self.contentView addSubview:self.functionView];
            
            /**预约按键处理*/
            
            if ([self.obj.retData.isAllowApply intValue] == 2) {
                 self.appointmentBtn.selected = NO;
                [self.appointmentBtn setTitle:@"停止预约" forState:UIControlStateNormal];
                self.appointmentBtn.userInteractionEnabled = NO;
            }else{
            
                if ([self.obj.retData.isUserSubscribe intValue] == 1) {
                    self.appointmentBtn.selected = YES;
                }else{
                    self.appointmentBtn.selected = NO;
                }
            }
            
            
            if ([self.obj.retData.isUserFav intValue] == 1) {
                self.collectBtn.selected = YES;
                self.collectBtnImge.image = [UIImage imageNamed:KCollectedBtnImg];
            }else{
                self.collectBtn.selected = NO;
                self.collectBtnImge.image = [UIImage imageNamed:KCollectBtnImg];
            }
            
            [self stopLoading];
            
        }
    }else if ([self.currentApiName isEqualToString:ActivitySubscribe]){
   
        BaseResultObj *resultObj =[BaseResultObj getBaseObjFrom:responseResult];
        
        if ([resultObj.retCode intValue] == 0) {
          
            self.appointmentBtn.selected = YES;
        }else{
            self.appointmentBtn.selected = NO;
            [self showAlterViewWithText:resultObj.retMsg];
        }
        [self stopLoading];
        
    }else if ([self.currentApiName isEqualToString:ActivityFav]){
       
        BaseResultObj *resultObj =[BaseResultObj getBaseObjFrom:responseResult];
        if ([resultObj.retCode intValue] == 0) {
            
            if (self.collectBtn.selected) {
                self.collectBtnImge.image = [UIImage imageNamed:KCollectedBtnImg];
                self.collectBtn.selected = YES;
            }else{
                self.collectBtnImge.image = [UIImage imageNamed:KCollectBtnImg];
                self.collectBtn.selected = NO;
            }
        }
        
        [self stopLoading];
    
    }else if ([self.currentApiName isEqualToString:ActivityShare]){
    
       
    }else if ([self.currentApiName isEqualToString:CommentList]){
        
        self.commentrootObj = [BaseResultObj getBaseObjFrom:responseResult];
        
        [self.dataArray addObjectsFromArray:self.commentrootObj.retData.dataList];
        [self.commentTableView reloadData];
        
        [self.commentTableView.mj_footer endRefreshing];
        
        if (self.dataArray.count == 0) {
            self.noCommentLabel.hidden = NO;
        }else{
           self.noCommentLabel.hidden = YES;
        }
    
    }else if ([self.currentApiName isEqualToString:CommentPost]){
    
        [self.dataArray removeAllObjects];
        [self showCommentView];

    }
    
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self.commentTableView.mj_footer endRefreshingWithNoMoreData];
    [self stopLoading];
    [self showNotData];

}

- (void) loadMoreData{
    [self pullToLoadingOfFooter];
    
}

- (void) makeAppointmentImmediately{

    if (!self.appointmentBtn.selected) {
        
            NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
            delegate.delegate = self;
            NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
            [paraDic setObject:self.obj.retData.currentID forKey:@"objId"];
            [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"objType"];
            [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"actType"];
            [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"pageSize"];
            [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
            NSString *skey = [[DataManager lightData] readSkey];
            [paraDic setObject:skey forKey:@"skey"];
            NSString *hashToken =[NSString getEncryptStringfrom:@[self.obj.retData.currentID,
                                                                  [NSNumber numberWithInt:1],
                                                                  skey]];
            [paraDic setObject:hashToken forKey:@"hashToken"];
            [NetWorkTask postResquestWithApiName:ActivitySubscribe paraDic:paraDic delegate:delegate];
            self.currentApiName = ActivitySubscribe;
            [self startLoading];
        
    }else{
    
        [self showAlterViewWithText:@"已预约过！"];
    }
}


#pragma mark - collectCurrentInfo

- (void) collectCurrentInfo: (UIButton *) button {

    self.collectBtn.selected = !self.collectBtn.selected;
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.objId forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"objTypeId"];
    if (button.selected) {
        [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"actType"];
        
    }else{
         [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"actType"];
    }
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:reqTime forKey:@"favTime"];
    
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken;
    if (button.selected) {
        hashToken = [NSString getEncryptStringfrom:@[self.objId,
                                                     [NSNumber numberWithInt:2],
                                                     reqTime,
                                                     [NSNumber numberWithInt:1],
                                                     skey]];
    }else{
        hashToken = [NSString getEncryptStringfrom:@[self.objId,
                                                     [NSNumber numberWithInt:2],
                                                     reqTime,
                                                     [NSNumber numberWithInt:2],
                                                     skey]];
    }
    [paraDic setObject:hashToken forKey:@"hashToken"];

    [NetWorkTask postResquestWithApiName:ActivityFav paraDic:paraDic delegate:delegate];
    self.currentApiName = ActivityFav;
    
    [self startLoading];
    

}

- (CGFloat) addSubViewsTo:(UIView *) view{

    /**头图*/
    UIImageView *topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          self.view.frame.size.width,
                                                                          DetailTopImageHeight*Proportion)];
    [view addSubview:topImage];
    
    [NetWorkTask setImageView:topImage
                      WithURL:[NSURL URLWithString:self.obj.retData.coverPic]
             placeholderImage: [UIImage imageNamed:KActivityPlaceholderImg]];
    
    /**标题*/
    UILabel *title = [[UILabel alloc] init];
    title.text = self.obj.retData.title;
    title.font = KSystemBoldFontSize21;
    title.numberOfLines = 0;
    title.textAlignment = NSTextAlignmentCenter;
    CGRect rect = [title.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 2*DetailInfoLeftMargin*Proportion, 1000)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:KSystemBoldFontSize21}
                                           context:nil];
    
    title.frame =CGRectMake(DetailInfoLeftMargin*Proportion,
                            CGRectGetMaxY(topImage.frame) + DetailTitleTopMargin*Proportion,
                            self.view.frame.size.width - 2*DetailInfoLeftMargin*Proportion,
                            rect.size.height);
    title.textColor = [UIColor blackColor];
    [view addSubview:title];
    
    /**浏览次数和收藏此书*/
    UILabel *numOfBrowseCollectionLabel = [[UILabel alloc] init];
    numOfBrowseCollectionLabel.textColor = [UIColor grayColor];
    numOfBrowseCollectionLabel.font = KSystemFontSize12;
    numOfBrowseCollectionLabel.text = [NSString stringWithFormat:@"浏览 %@次 收藏 %@次",self.obj.retData.hitNum,self.obj.retData.favNum];
    [numOfBrowseCollectionLabel sizeToFit];
    numOfBrowseCollectionLabel.frame = CGRectMake(self.view.frame.size.width - DetailInfoLeftMargin*Proportion - numOfBrowseCollectionLabel.frame.size.width,
                                                  CGRectGetMaxY(title.frame) + DetailInfoSpace*Proportion*2,
                                                  numOfBrowseCollectionLabel.frame.size.width,
                                                  numOfBrowseCollectionLabel.frame.size.height);
    [view addSubview:numOfBrowseCollectionLabel];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(DetailInfoLeftMargin*Proportion,
                                                                CGRectGetMaxY(numOfBrowseCollectionLabel.frame) + DetailInfoLeftMargin*Proportion ,
                                                                self.view.frame.size.width - 2*DetailInfoSpace*Proportion,
                                                                0.3)];
    lineView.backgroundColor = [UIColor CMLLineGrayColor];
    [view addSubview:lineView];
    
    
    /**time**/
    NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:[self.obj.retData.actBeginTime intValue]];
    NSString *beginTimeStr = [NSDate getStringDependOnFormatterAFromDate: beginDate];
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[self.obj.retData.actEndTime intValue]];
    NSString *endTimeStr = [NSDate getStringDependOnFormatterAFromDate:endDate];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = [NSString stringWithFormat:@"%@--%@",beginTimeStr,endTimeStr];
    dateLabel.font = KSystemFontSize14;
    dateLabel.textColor = [UIColor CMLInputTextGrayColor];
    [dateLabel sizeToFit];
    
    UIImageView *dateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DetailInfoLeftMargin*Proportion,
                                                                               CGRectGetMaxY(numOfBrowseCollectionLabel.frame) + DetailInfoSpace*Proportion*3 ,
                                                                               dateLabel.frame.size.height,
                                                                               dateLabel.frame.size.height)];
    dateImageView.image = [UIImage imageNamed:KActivityDetailTimeImg];
    dateImageView.alpha = 0.6;
    [view addSubview:dateImageView];
    
    dateLabel.frame = CGRectMake(CGRectGetMaxX(dateImageView.frame) + DetailInfoSpace*Proportion,
                                 dateImageView.frame.origin.y,
                                 dateLabel.frame.size.width,
                                 dateLabel.frame.size.height);
    [view addSubview:dateLabel];
    
    /**address*/
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = self.obj.retData.address;
    addressLabel.textColor = [UIColor CMLInputTextGrayColor];
    addressLabel.font = KSystemFontSize14;
    [addressLabel sizeToFit];
    addressLabel.numberOfLines = 0;
    UIImageView *addressImage = [[UIImageView alloc] initWithFrame:CGRectMake(DetailInfoLeftMargin*Proportion,
                                                                              CGRectGetMaxY(dateImageView.frame) + DetailInfoSpace*Proportion,
                                                                              addressLabel.frame.size.height,
                                                                              addressLabel.frame.size.height)];
    addressImage.image = [UIImage imageNamed:KActivityDetailAddressImg];
    addressImage.alpha = 0.6;
    [view addSubview:addressImage];
    
    CGRect rectOfAddressLbel = [addressLabel.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - DetailAddressLeftMargin*Proportion*2, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KSystemFontSize14} context:nil];
    addressLabel.frame = CGRectMake(CGRectGetMaxX(addressImage.frame) + DetailInfoSpace*Proportion,
                                    addressImage.frame.origin.y,
                                    rectOfAddressLbel.size.width,
                                    rectOfAddressLbel.size.height);
    [view addSubview:addressLabel];
    
    UILabel *telephone = [[UILabel alloc] init];
    telephone.text = [NSString stringWithFormat:@"%@",self.obj.retData.telephone];
    telephone.textColor = [UIColor CMLInputTextGrayColor];
    telephone.font = KSystemFontSize14;
    [telephone sizeToFit];
    
    UIImageView *telephoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(DetailInfoLeftMargin*Proportion,
                                                                              CGRectGetMaxY(addressLabel.frame) + DetailInfoSpace*Proportion,
                                                                              telephone.frame.size.height,
                                                                              telephone.frame.size.height)];
    telephoneImg.image = [UIImage imageNamed:KActivityNumImg];
    telephoneImg.alpha = 0.6;
    [view addSubview:telephoneImg];
    
    telephone.frame = CGRectMake(CGRectGetMaxX(telephoneImg.frame) + DetailInfoSpace*Proportion,
                                 telephoneImg.frame.origin.y,
                                 telephone.frame.size.width,
                                 telephone.frame.size.height);
    [view addSubview:telephone];
    
    
    UIView *endView = [[UIView alloc] init];
    endView.frame =CGRectMake(0,
                              CGRectGetMaxY(telephone.frame) + DetailInfoSpace*Proportion,
                              self.view.frame.size.width,
                              DetailInfoSpace*Proportion*2);
    endView.backgroundColor = [UIColor CMLVIPGrayColor];
    [view addSubview:endView];
    
    return topImage.frame.size.height + title.frame.size.height + numOfBrowseCollectionLabel.frame.size.height + dateLabel.frame.size.height + addressImage.frame.size.height + DetailTitleTopMargin*Proportion + DetailInfoSpace*Proportion*10 + telephone.frame.size.height + endView.frame.size.height;
    

}


- (void) shareCurrentPage{

    self.textFieldBigBGView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.textFieldBigBGView];
    self.textFieldBigBGView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    [self.contentView addSubview:self.commentTxtMainView];
    
    [self.commentTextView becomeFirstResponder];

}


- (void) showShareViewWithShareModel{
    
    self.shareBigBGView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   self.view.frame.size.width,
                                                                   self.contentView.frame.size.height)];
    
    [self.contentView addSubview:self.shareBigBGView];
    [self.contentView bringSubviewToFront:self.shareBigBGView];
    
    self.shareMainBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    self.view.frame.size.height,
                                                                    self.view.frame.size.width,
                                                                    ShareMainViewHeight*Proportion)];
    self.shareMainBgView.backgroundColor = [UIColor whiteColor];
    [self.shareBigBGView addSubview:self.shareMainBgView];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                     Proportion*(ShareMainViewHeight - CancelShareBtnHeight),
                                                                     self.view.frame.size.width,
                                                                     CancelShareBtnHeight*Proportion)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = KSystemFontSize13;
    [cancelBtn setTitleColor:[UIColor CMLInputTextGrayColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelShare) forControlEvents:UIControlEventTouchUpInside];
    [self.shareMainBgView addSubview:cancelBtn];
    
    CMLLine *line = [[CMLLine alloc] init];
    line.directionOfLine = HorizontalLine;
    line.startingPoint = CGPointMake(0, cancelBtn.frame.origin.y - 0.5);
    line.lineWidth = 0.5;
    line.lineLength = self.view.frame.size.width;
    line.LineColor = [UIColor CMLLineGrayColor];
    [self.shareMainBgView addSubview:line];
    
    CGFloat buttonSpace = (self.view.frame.size.width - ShareBtnWidthAndHeight*Proportion*5)/6;
    
    UIButton *converseBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonSpace,
                                                                       ShareBtnTopMargin*Proportion,
                                                                       ShareBtnWidthAndHeight*Proportion,
                                                                       ShareBtnWidthAndHeight*Proportion)];
    [converseBtn addTarget:self action:@selector(shareToConverse) forControlEvents:UIControlEventTouchUpInside];
    [converseBtn setBackgroundImage:[UIImage imageNamed:KShareToConverImg] forState:UIControlStateNormal];
    [self.shareMainBgView addSubview:converseBtn];
    
    UILabel *converLabel = [[UILabel alloc] init];
    converLabel.font = KSystemFontSize9;
    converLabel.text = @"微信好友";
    converLabel.textColor = [UIColor CMLTabBarItemGrayColor];
    [converLabel sizeToFit];
    converLabel.frame = CGRectMake(converseBtn.center.x - converLabel.frame.size.width/2.0,
                                   CGRectGetMaxY(converseBtn.frame) + ShareTypeNameTopMargin*Proportion,
                                   converLabel.frame.size.width,
                                   converLabel.frame.size.height);
    [self.shareMainBgView addSubview:converLabel];
    
    UIButton *friendsBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(converseBtn.frame) + buttonSpace,
                                                                      ShareBtnTopMargin*Proportion ,
                                                                      ShareBtnWidthAndHeight*Proportion,
                                                                      ShareBtnWidthAndHeight*Proportion)];
    [friendsBtn addTarget:self action:@selector(shareToCircleOfFriends) forControlEvents:UIControlEventTouchUpInside];
    [friendsBtn setBackgroundImage:[UIImage imageNamed:KShareToCircleImg] forState:UIControlStateNormal];
    [self.shareMainBgView addSubview:friendsBtn];
    
    UILabel *circleOfFriendsLabel = [[UILabel alloc] init];
    circleOfFriendsLabel.font = KSystemFontSize9;
    circleOfFriendsLabel.text = @"朋友圈";
    circleOfFriendsLabel.textColor = [UIColor CMLTabBarItemGrayColor];
    [circleOfFriendsLabel sizeToFit];
    circleOfFriendsLabel.frame = CGRectMake(friendsBtn.center.x - circleOfFriendsLabel.frame.size.width/2.0,
                                            CGRectGetMaxY(friendsBtn.frame) + ShareTypeNameTopMargin*Proportion,
                                            circleOfFriendsLabel.frame.size.width,
                                            circleOfFriendsLabel.frame.size.height);
    [self.shareMainBgView addSubview:circleOfFriendsLabel];
    
    UIButton *weiboBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(friendsBtn.frame) + buttonSpace,
                                                                   ShareBtnTopMargin*Proportion,
                                                                   ShareBtnWidthAndHeight*Proportion,
                                                                    ShareBtnWidthAndHeight*Proportion)];
    [weiboBtn setBackgroundImage:[UIImage imageNamed:KShareToweiboImg] forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(shareToWeibo) forControlEvents:UIControlEventTouchUpInside];
    [self.shareMainBgView addSubview:weiboBtn];
    UILabel *weiboLabel = [[UILabel alloc]init];
    weiboLabel.font = KSystemFontSize9;
    weiboLabel.text = @"新浪微博";
    weiboLabel.textColor = [UIColor CMLTabBarItemGrayColor];
    [weiboLabel sizeToFit];
    weiboLabel.frame = CGRectMake(weiboBtn.center.x - weiboLabel.frame.size.width/2.0,
                                            CGRectGetMaxY(friendsBtn.frame) + ShareTypeNameTopMargin*Proportion,
                                            weiboLabel.frame.size.width,
                                            weiboLabel.frame.size.height);
    [self.shareMainBgView addSubview:weiboLabel];
    
    UIButton *EmailBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(weiboBtn.frame) + buttonSpace,
                                                                    ShareBtnTopMargin*Proportion,
                                                                    ShareBtnWidthAndHeight*Proportion,
                                                                    ShareBtnWidthAndHeight*Proportion)];
    [EmailBtn setBackgroundImage:[UIImage imageNamed:KShareToEmailImg] forState:UIControlStateNormal];
    [EmailBtn addTarget:self action:@selector(shareToEmail) forControlEvents:UIControlEventTouchUpInside];
    [self.shareMainBgView addSubview:EmailBtn];
    UILabel *EmailLabel = [[UILabel alloc]init];
    EmailLabel.font = KSystemFontSize9;
    EmailLabel.text = @"邮件";
    EmailLabel.textColor = [UIColor CMLTabBarItemGrayColor];
    [EmailLabel sizeToFit];
    EmailLabel.frame = CGRectMake(EmailBtn.center.x - EmailLabel.frame.size.width/2.0,
                                  CGRectGetMaxY(weiboBtn.frame) + ShareTypeNameTopMargin*Proportion,
                                  EmailLabel.frame.size.width,
                                  EmailLabel.frame.size.height);
    [self.shareMainBgView addSubview:EmailLabel];
    
    
    UIButton *DouBanBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(EmailBtn.frame) + buttonSpace,
                                                                    ShareBtnTopMargin*Proportion,
                                                                    ShareBtnWidthAndHeight*Proportion,
                                                                    ShareBtnWidthAndHeight*Proportion)];
    [DouBanBtn setBackgroundImage:[UIImage imageNamed:KShareToDouBImg] forState:UIControlStateNormal];
    [DouBanBtn addTarget:self action:@selector(shareToDouBan) forControlEvents:UIControlEventTouchUpInside];
    [self.shareMainBgView addSubview:DouBanBtn];
    UILabel *DouBanLabel = [[UILabel alloc]init];
    DouBanLabel.font = KSystemFontSize9;
    DouBanLabel.text = @"豆瓣";
    DouBanLabel.textColor = [UIColor CMLTabBarItemGrayColor];
    [DouBanLabel sizeToFit];
    DouBanLabel.frame = CGRectMake(DouBanBtn.center.x - DouBanLabel.frame.size.width/2.0,
                                  CGRectGetMaxY(EmailBtn.frame) + ShareTypeNameTopMargin*Proportion,
                                  DouBanLabel.frame.size.width,
                                  DouBanLabel.frame.size.height);
    [self.shareMainBgView addSubview:DouBanLabel];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        self.shareBigBGView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }];
    
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.shareMainBgView.frame = CGRectMake(0,
                                                self.contentView.frame.size.height - ShareMainViewHeight*Proportion,
                                                self.view.frame.size.width,
                                                ShareMainViewHeight*Proportion);
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    /**评论时的界面处理*/
    [self.commentTextView resignFirstResponder];
    [UIView animateWithDuration:1 animations:^{
        self.textFieldBigBGView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        [self.textFieldBigBGView removeFromSuperview];
    }];
    
    /**分享时的界面处理*/
    [UIView animateWithDuration:0.2 animations:^{
        self.shareMainBgView.frame = CGRectMake(0,
                                                self.contentView.frame.size.height,
                                                self.view.frame.size.width,
                                                ShareMainViewHeight*Proportion);
    } completion:^(BOOL finished) {
        
        [self.shareMainBgView removeFromSuperview];
        
    }];
    
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.shareBigBGView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        
        [self.shareBigBGView removeFromSuperview];
        
    }];
    
}

- (void) shareToConverse{

    if (self.obj.retData.shareLink) {
       [UMSocialData defaultData].extConfig.wechatSessionData.url = self.obj.retData.shareLink;
    }
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:self.obj.retData.title image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity * response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
            [self sendShareAction];
        } else if(response.responseCode != UMSResponseCodeCancel) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (void) shareToCircleOfFriends{
    
    if (self.obj.retData.shareLink) {
        [UMSocialData defaultData].extConfig.wechatSessionData.url = self.obj.retData.shareLink;
    }
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:self.obj.retData.title image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity * response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
            [self sendShareAction];
        } else if(response.responseCode != UMSResponseCodeCancel) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        }
    }];
    
}

- (void) shareToWeibo {

    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@,%@",self.obj.retData.title,self.obj.retData.shareLink] image:self.shareToSinaImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
            [self sendShareAction];
        } else if(shareResponse.responseCode != UMSResponseCodeCancel) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        }
    }];

}

- (void) shareToEmail{

    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToEmail] content:[NSString stringWithFormat:@"%@,%@",self.obj.retData.title,self.obj.retData.shareLink] image:self.shareToSinaImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
            [self sendShareAction];
        } else if(shareResponse.responseCode != UMSResponseCodeCancel) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        }
    }];

}

- (void) shareToDouBan{

    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToDouban] content:[NSString stringWithFormat:@"%@,%@",self.obj.retData.title,self.obj.retData.shareLink] image:self.shareToSinaImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
            [self sendShareAction];
        } else if(shareResponse.responseCode != UMSResponseCodeCancel) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        }
    }];

}

- (void) cancelShare {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.shareMainBgView.frame = CGRectMake(0,
                                                self.contentView.frame.size.height,
                                                self.view.frame.size.width,
                                                ShareMainViewHeight*Proportion);
    } completion:^(BOOL finished) {
        
        [self.shareMainBgView removeFromSuperview];
        
    }];
    
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.shareBigBGView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        
        [self.shareBigBGView removeFromSuperview];
        
    }];
    
}

- (void) sendShareAction{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.obj.retData.currentID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"objTypeId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.obj.retData.currentID,[NSNumber numberWithInt:2],skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:ActivityShare paraDic:paraDic delegate:delegate];
    self.currentApiName = ActivityShare;
    
}

#pragma mark - NavigationBarDelegate

- (void) didSelectedRightBarItem {

    [self.commentTextView resignFirstResponder];
    [self showShareViewWithShareModel];

}

- (void) didSelectedLeftBarItem{
    
    [self.commentTextView resignFirstResponder];
    [[VCManger mainVC] dismissCurrentVC];
    
}

#pragma mark - 监控键盘的高度
- (void)keyboardWasShown:(NSNotification*)aNotification{

    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.25 animations:^{
        
        self.commentTxtMainView.frame = CGRectMake(0,
                                                   self.contentView.frame.size.height - kbSize.height - InputViewHeight*Proportion - commentBtnHeight*Proportion,
                                                   self.view.frame.size.width,
                                                   InputViewHeight*Proportion + commentBtnHeight*Proportion);
    }];
    
}



-(void)keyboardWillBeHidden:(NSNotification*)aNotification{
 

    [UIView animateWithDuration:0.25 animations:^{
        
        self.commentTxtMainView.frame = CGRectMake(0,
                                                CGRectGetMaxY(self.contentView.frame),
                                                self.view.frame.size.width,
                                                InputViewHeight*Proportion + commentBtnHeight*Proportion);
    }];

    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{


    self.currentOffSet = self.webView.scrollView.contentOffset.y;
    
    if (self.commentTableView.contentOffset.y != 0) {
      self.currentOffSetOfTableView = self.commentTableView.contentOffset.y;
    }
    if ((int)self.currentOffSet > (int)(self.webView.scrollView.contentSize.height - self.webView.frame.size.height)) {
        self.alterView.frame = CGRectMake(0, self.webView.frame.size.height - (self.currentOffSet - (self.webView.scrollView.contentSize.height - self.webView.frame.size.height)), self.view.frame.size.width, 40);
    }else{
        self.alterView.frame = CGRectMake(0, self.webView.frame.size.height, self.view.frame.size.width, 40);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    if ((int)self.currentOffSet == (int)(self.webView.scrollView.contentSize.height - self.webView.frame.size.height)) {
        [self.webView addSubview:self.alterView];
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if ((int)self.currentOffSet > (int)(self.webView.scrollView.contentSize.height - self.webView.frame.size.height)) {
        
        [self showCommentView];
        self.webView.hidden = YES;
    }
    
    if ((int)self.currentOffSetOfTableView < 0) {
        [self hiddenCommentView];
        self.webView.hidden = NO;
        self.currentOffSetOfTableView = 0;
    }

}

#pragma mark - UITableViewDataSource


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.commentrootObj) {
        if (self.dataArray.count > 0) {
            CMLCommentListTVCell *cell = (CMLCommentListTVCell *)[self tableView:self.commentTableView cellForRowAtIndexPath:indexPath];
            CommentObj *obj =  [CommentObj getBaseObjFrom:self.dataArray[indexPath.row]];
            cell.imageUrl = obj.userHeadImg;
            cell.nickName = obj.userNickName;
            cell.commentContent = obj.comment;
            cell.publishTime = obj.postTimeStr;
            CGFloat rowHeight = [cell refreshTableViewCell];
            return rowHeight;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.dataArray.count>0) {
        return self.dataArray.count;
    }else{
        return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"tableViewCell";
    CMLCommentListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[CMLCommentListTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (self.dataArray.count>0) {
        CommentObj *obj =  [CommentObj getBaseObjFrom:self.dataArray[indexPath.row]];
        cell.imageUrl = obj.userHeadImg;
        cell.nickName = obj.userNickName;
        cell.commentContent = obj.comment;
        cell.publishTime = obj.postTimeStr;
        [cell refreshTableViewCell];
        
    }
    return cell;
}

- (void) showCommentView{

    [UIView animateWithDuration:0.2 animations:^{
       
        self.commentTableView.frame = CGRectMake(0,
                                                 CGRectGetMaxY(self.navBar.frame),
                                                 self.view.frame.size.width,
                                                 self.contentView.frame.size.height - self.functionView.frame.size.height - self.navBar.frame.size.height);
    }];
    
    [self getCommentList:1];
    
    
}

- (void) hiddenCommentView{

    [UIView animateWithDuration:0.2 animations:^{
       
        self.commentTableView.frame = CGRectMake(0,
                                                 CGRectGetMaxY(self.contentView.frame) - self.functionView.frame.size.height,
                                                 self.view.frame.size.width,
                                                 self.contentView.frame.size.height - self.functionView.frame.size.height - self.navBar.frame.size.height);
    }];
    
    [self.dataArray removeAllObjects];
    
    
}

- (void) getCommentList:(int) page{

    self.page = page;
    if (page == 1) {
        [self.dataArray removeAllObjects];
    }
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.obj.retData.currentID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"objType"];
    [paraDic setObject: [NSNumber numberWithInt:PageSize] forKey:@"pageSize"];
    [paraDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.obj.retData.currentID,[NSNumber numberWithInt:2],reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:CommentList paraDic:paraDic delegate:delegate];
    self.currentApiName = CommentList;


}

- (void) cancelComment{

    self.commentTextView.text = @"";
    [self.commentTextView resignFirstResponder];
    [UIView animateWithDuration:1 animations:^{
        self.textFieldBigBGView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        [self.textFieldBigBGView removeFromSuperview];
    }];
    

}

- (void) confrimComment{

    if (self.commentTextView.text.length <= 0) {
        [self cancelComment];
        
    }else{
    
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:self.obj.retData.currentID forKey:@"objId"];
        [paraDic setObject:[NSNumber numberWithInt:2] forKey:@"objType"];
        [paraDic setObject:self.commentTextView.text forKey:@"comment"];
        NSString *skey = [[DataManager lightData] readSkey];
        [paraDic setObject:skey forKey:@"skey"];
        NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
        [paraDic setObject:reqTime forKey:@"reqTime"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[self.obj.retData.currentID,[NSNumber numberWithInt:2],reqTime,skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
        
        NSString *commhash =[NSString stringWithFormat:@"%@%@%@",self.commentTextView.text,skey,reqTime];
        [paraDic setObject:[commhash md5] forKey:@"commentHash"];
        [NetWorkTask postResquestWithApiName:CommentPost paraDic:paraDic delegate:delegate];
        self.currentApiName = CommentPost;
        [self cancelComment];
    }
}

- (void) pullToLoadingOfFooter{

    if (self.dataArray.count%20 == 0) {
        if (self.dataArray.count != [self.commentrootObj.retData.dataCount intValue]) {
            self.page++;
            [self getCommentList:self.page];
        }else{
            [self.commentTableView.mj_footer endRefreshing];
        }
    }else{
        
        [self.commentTableView.mj_footer endRefreshing];
    }

}

@end
