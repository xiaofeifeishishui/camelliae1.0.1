//
//  CMLServeDetailVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/25.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLServeDetailVC.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
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
#import "UIImage+CMLExspand.h"
#import "UMSocial.h"

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
#define ContentLeftAndRightMargin 30

#define DetailInfoSpace           15
#define DetailInfoLeftMargin      25

#define DetailTopImageHeight      304
#define DetailTitleTopMargin      20
#define DetailTitleBottomMargin   23
#define DetailPriceTopMargin      10

#define ShareMainViewHeight              195
#define CancelShareBtnHeight             60
#define FriendsShareLeftMargin           43
#define ShareBtnTopMargin                26
#define ShareBtnSpace                    62
#define ShareBtnWidthAndHeight           58
#define ShareTypeNameTopMargin           16


#define ConfirmationViewHeight            468
#define ConfirmationImageHeight           168
#define ConfirmationImageWidth            235
#define ConfirmationImageLeftMargin       36
#define ConfirmationImageTopMargin        18
#define ConfimrationInfoHeight            88


@interface CMLServeDetailVC () <NavigationBarDelegate,NetWorkProtocol,UIWebViewDelegate,UIScrollViewDelegate,WXApiDelegate,UITextFieldDelegate,WKUIDelegate,WKNavigationDelegate>

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

@property (nonatomic,strong) UIView *informationConfirmationView;

@property (nonatomic,assign) BOOL isShowConfirmationView;

@property (nonatomic,copy) NSString *phone;

@property (nonatomic,copy) NSString *realUserName;

@property (nonatomic,assign) BOOL isKeyBoardShow;

@property (nonatomic,strong) UIImage *shareToSinaImage;

@end

@implementation CMLServeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.titleContent = self.currentTitle;
    self.navBar.titleColor = [UIColor CMLTitleYellowColor];
    self.navBar.navigationBarDelegate = self;
    [self.navBar setWhiteLeftBarItem];
    [self.navBar setShareBarItem];
    self.navBar.backgroundColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    /***/
    self.phone = [[DataManager lightData] readPhone];
    self.realUserName = [[DataManager lightData] readUserName];
    
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
    [self.contentView addSubview:self.functionView];
    
    UIImageView *shareBtnImge = [[UIImageView alloc] initWithFrame:CGRectMake(ShareButtonLeftMargin*Proportion,
                                                                             ButtonTopMargin*Proportion,
                                                                             ButtonWidth*Proportion,
                                                                             ShareBtnHeight*Proportion)];
    shareBtnImge.userInteractionEnabled = YES;
    shareBtnImge.image = [UIImage imageNamed:KBlackShareImg];
    [self.functionView addSubview:shareBtnImge];

    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(ShareButtonLeftMargin*Proportion - (FunctionViewHeight*Proportion - ButtonWidth*Proportion)/2.0,
                                                                    0,
                                                                    FunctionViewHeight*Proportion,
                                                                    FunctionViewHeight*Proportion)];
    [shareBtn addTarget:self action:@selector(shareCurrentPage) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.backgroundColor = [UIColor clearColor];
    [self.functionView addSubview:shareBtn];
    
    UILabel *shareLabel = [[UILabel alloc] init];
    shareLabel.text = @"分享";
    shareLabel.textColor = [UIColor blackColor];
    shareLabel.font = KSystemFontSize9;
    [shareLabel sizeToFit];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.frame = CGRectMake(shareBtnImge.center.x - shareLabel.frame.size.width/2.0,
                                  CGRectGetMaxY(shareBtnImge.frame)+ ButonLabelTopMargin*Proportion,
                                  shareLabel.frame.size.width,
                                  shareLabel.frame.size.height);
    [self.functionView addSubview:shareLabel];
    
    
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
    
    UIButton *appointmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(collectBtn.frame) + AppointmentBntLeftMargin*Proportion,
                                                                          0,
                                                                          self.functionView.frame.size.width - (CGRectGetMaxX(collectBtn.frame) + AppointmentBntLeftMargin*Proportion),
                                                                          self.functionView.frame.size.height)];
    [appointmentBtn setBackgroundColor:[UIColor blackColor]];
    [appointmentBtn setTitle:@"我要预订" forState:UIControlStateNormal];
    [appointmentBtn setTitle:@"已经预订" forState:UIControlStateSelected];
    appointmentBtn.titleLabel.font = KSystemFontSize15;
    [appointmentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [appointmentBtn addTarget:self action:@selector(makeAppointmentImmediately) forControlEvents:UIControlEventTouchUpInside];
    self.appointmentBtn = appointmentBtn;
    [self.functionView addSubview:self.appointmentBtn];
    
    
    /**主界面*/
    CGFloat screenW = self.view.frame.size.width - ContentLeftAndRightMargin*Proportion;
    NSString *js = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
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
                                                               self.view.frame.size.width ,
                                                               self.contentView.frame.size.height - self.navBar.frame.size.height - self.functionView.frame.size.height) configuration:config];
    self.webView.UIDelegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.bounces = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
    
    
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
      [paraDic setObject:objId forKey:@"objId"];
    }
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.objId,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    if (objId) {
        [NetWorkTask postResquestWithApiName:ProjectInfo paraDic:paraDic delegate:delegate];
        self.currentApiName = ProjectInfo;
        [self startLoading];
    }else{
        [self showNotData];
    }
}

- (void) textAnalysis{
    
    
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
    
    if ([self.currentApiName isEqualToString:ProjectInfo]) {
        
        self.obj = [BaseResultObj getBaseObjFrom:responseResult];
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
            [self.webView loadHTMLString:str baseURL:nil];
            self.webBrowserView = self.webView.scrollView.subviews[0];
            /**加表头*/
            UIView *headerView = [[UIView alloc] init];
            CGFloat height =[self addSubViewsTo:headerView];
            headerView.frame = CGRectMake(0, -height, self.view.frame.size.width, height);
            [self.webView.scrollView addSubview:headerView];
            [self.contentView addSubview:self.webView];
            [self.contentView addSubview:self.functionView];
            [UIView animateWithDuration:1 animations:^{
                self.webView.scrollView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
            }];
            
            if ([self.obj.retData.isUserFav intValue] == 1) {
                self.collectBtn.selected = YES;
                self.collectBtnImge.image = [UIImage imageNamed:KCollectedBtnImg];
            }else{
                self.collectBtn.selected = NO;
                self.collectBtnImge.image = [UIImage imageNamed:KCollectBtnImg];
            }
            
            if ([self.obj.retData.isUserSubscribe intValue] == 1) {
                self.appointmentBtn.selected = YES;
                self.isShowConfirmationView = NO;
            }else{
                self.appointmentBtn.selected = NO;
                self.isShowConfirmationView = YES;
            }
            
            [self stopLoading];
        }
    }else if ([self.currentApiName isEqualToString:ServeSubscribe]){
    
        [self showAlterViewWithText:self.obj.retMsg];
        if ([self.obj.retCode intValue] == 0) {
            self.appointmentBtn.selected = YES;
        }
        [self stopLoading];
        
        
    }else if ([self.currentApiName isEqualToString:ActivityFav]){

        if ([self.obj.retCode intValue] == 0) {
            
            if (self.collectBtn.selected) {
                self.collectBtnImge.image = [UIImage imageNamed:KCollectedBtnImg];
                self.collectBtn.selected = YES;
            }else{
                self.collectBtnImge.image = [UIImage imageNamed:KCollectBtnImg];
                self.collectBtn.selected = NO;
            }
        }
        
        [self stopLoading];
        [self hiddenNotData];
        
    }else if ([self.currentApiName isEqualToString:ActivityShare]){
        
    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self stopLoading];
    
}

- (void) makeAppointmentImmediately{
    
    if (!self.appointmentBtn.selected) {
        
        self.isShowConfirmationView = YES;
        [self showShareViewWithShareModel];
        
    }else{
        
        [self showAlterViewWithText:@"已预订过！"];
    }
}


#pragma mark - collectCurrentInfo

- (void) collectCurrentInfo: (UIButton *) button {
    
    self.collectBtn.selected = !self.collectBtn.selected;
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.objId forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:3] forKey:@"objTypeId"];
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
                                                     [NSNumber numberWithInt:3],
                                                     reqTime,
                                                     [NSNumber numberWithInt:1],
                                                     skey]];
    }else{
        hashToken = [NSString getEncryptStringfrom:@[self.objId,
                                                     [NSNumber numberWithInt:3],
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
    
    UIImageView *topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          self.view.frame.size.width,
                                                                          DetailTopImageHeight*Proportion)];
    [view addSubview:topImage];
    
    [NetWorkTask setImageView:topImage
                      WithURL:[NSURL URLWithString:self.obj.retData.coverPic]
             placeholderImage: [UIImage imageNamed:KActivityPlaceholderImg]];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = self.obj.retData.title;
    title.font = KSystemBoldFontSize21;
    title.textAlignment = NSTextAlignmentCenter;
    title.numberOfLines = 0;
    CGRect rect = [title.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - DetailInfoLeftMargin*2*Proportion, 1000)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:KSystemBoldFontSize21}
                                           context:nil];
    title.frame =CGRectMake(DetailInfoLeftMargin*Proportion,
                            CGRectGetMaxY(topImage.frame) + DetailTitleTopMargin*Proportion,
                            self.view.frame.size.width - 2*DetailInfoLeftMargin*Proportion,
                            rect.size.height);
    title.textColor = [UIColor blackColor];
    [view addSubview:title];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = [NSString stringWithFormat:@"%@元起",self.obj.retData.totalAmount];
    priceLabel.textColor = [UIColor CMLTitleYellowColor];
    priceLabel.font = KSystemFontSize15;
    [priceLabel sizeToFit];
    priceLabel.frame = CGRectMake(self.view.frame.size.width/2.0 - priceLabel.frame.size.width/2.0,
                                  CGRectGetMaxY(title.frame) + DetailPriceTopMargin*Proportion,
                                  priceLabel.frame.size.width,
                                  priceLabel.frame.size.height);
    [view addSubview:priceLabel];
    
    /**收藏和分享*/
    UILabel *likeLabel = [[UILabel alloc] init];
    likeLabel.text = [NSString stringWithFormat:@"%d人喜欢",[self.obj.retData.hitNum intValue]];
    likeLabel.textColor = [UIColor grayColor];
    likeLabel.font = KSystemFontSize12;
    [likeLabel sizeToFit];
    likeLabel.frame = CGRectMake(self.view.frame.size.width/2.0 - likeLabel.frame.size.width/2.0,
                                 CGRectGetMaxY(priceLabel.frame) + DetailInfoSpace*Proportion,
                                 likeLabel.frame.size.width,
                                 likeLabel.frame.size.height);
    [view addSubview:likeLabel];
    
    CMLLine *line = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake(DetailInfoLeftMargin*Proportion, CGRectGetMaxY(likeLabel.frame) + DetailInfoSpace*Proportion);
    line.lineWidth = 0.3;
    line.lineLength = self.view.frame.size.width - DetailInfoLeftMargin*Proportion*2;
    line.LineColor = [UIColor CMLLineGrayColor];
    line.directionOfLine = HorizontalLine;
    [view addSubview:line];
    
    
    /**time**/
    
    NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:[self.obj.retData.projectBeginTime intValue]];
    NSString *beginTimeStr = [NSDate getStringDependOnFormatterAFromDate: beginDate];
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[self.obj.retData.projectEndTime intValue]];
    NSString *endTimeStr = [NSDate getStringDependOnFormatterAFromDate:endDate];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = [NSString stringWithFormat:@"%@--%@",beginTimeStr,endTimeStr];
    dateLabel.font = KSystemFontSize14;
    dateLabel.textColor = [UIColor CMLInputTextGrayColor];
    [dateLabel sizeToFit];
    
    UIImageView *dateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DetailInfoLeftMargin*Proportion,
                                                                               CGRectGetMaxY(likeLabel.frame) + DetailInfoSpace*Proportion*3 ,
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
    
    if ([self.obj.retData.isHasTimeZone intValue] == 2) {
        dateLabel.hidden = YES;
        dateImageView.hidden = YES;
    }
    
    /**address*/
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = self.obj.retData.projectAddress;
    addressLabel.textColor = [UIColor CMLInputTextGrayColor];
    addressLabel.font = KSystemFontSize14;
    addressLabel.numberOfLines = 0;
    [addressLabel sizeToFit];
    UIImageView *addressImage = [[UIImageView alloc] init];
    
    if ([self.obj.retData.isHasTimeZone intValue] == 2) {

        addressImage.frame = CGRectMake(DetailInfoLeftMargin*Proportion,
                                        CGRectGetMaxY(likeLabel.frame) + DetailInfoSpace*Proportion*3,
                                        addressLabel.frame.size.height,
                                        addressLabel.frame.size.height);
    }else{
        addressImage.frame = CGRectMake(DetailInfoLeftMargin*Proportion,
                                        CGRectGetMaxY(dateImageView.frame) + DetailInfoSpace*Proportion,
                                        addressLabel.frame.size.height,
                                        addressLabel.frame.size.height);

    }
    
    
    addressImage.image = [UIImage imageNamed:KActivityDetailAddressImg];
    addressImage.alpha = 0.6;
    [view addSubview:addressImage];
    
    CGRect rectOfAddressLbel = [addressLabel.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - ConfirmationImageLeftMargin*Proportion*2, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KSystemFontSize14} context:nil];
    addressLabel.frame = CGRectMake(CGRectGetMaxX(addressImage.frame) + DetailInfoSpace*Proportion,
                                    addressImage.frame.origin.y,
                                    rectOfAddressLbel.size.width,
                                    rectOfAddressLbel.size.height);
    [view addSubview:addressLabel];
    
    
    UILabel *introductionlabel = [[UILabel alloc] init];
    introductionlabel.text = self.obj.retData.briefIntro;
    introductionlabel.font = KSystemFontSize12;
    introductionlabel.numberOfLines = 0;
    CGRect introductionlabelRect =[introductionlabel.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - DetailInfoLeftMargin*Proportion*4, 10000)
                                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                                    attributes:@{NSFontAttributeName:KSystemFontSize12}
                                                                       context:nil];
    introductionlabel.frame = CGRectMake(DetailInfoLeftMargin*Proportion*2,
                                         CGRectGetMaxY(addressLabel.frame) + DetailInfoSpace*Proportion,
                                         self.view.frame.size.width - 4*DetailInfoLeftMargin*Proportion,
                                         introductionlabelRect.size.height );
    introductionlabel.textColor = [UIColor CMLLineGrayColor];
    [view addSubview:introductionlabel];
    
    UIView *endView = [[UIView alloc] init];
    endView.frame =CGRectMake(0,
                              CGRectGetMaxY(introductionlabel.frame) + DetailInfoSpace*Proportion,
                              self.view.frame.size.width,
                              DetailInfoSpace*Proportion*2);
    endView.backgroundColor = [UIColor CMLVIPGrayColor];
    [view addSubview:endView];

    if ([self.obj.retData.isHasTimeZone intValue] == 2) {
         return topImage.frame.size.height + priceLabel.frame.size.height + likeLabel.frame.size.height + addressLabel.frame.size.height + title.frame.size.height + DetailTitleTopMargin*Proportion +DetailPriceTopMargin*Proportion + DetailInfoLeftMargin*Proportion*6 + introductionlabel.frame.size.height;
    }else{
        
      return topImage.frame.size.height + priceLabel.frame.size.height + likeLabel.frame.size.height + dateLabel.frame.size.height + addressLabel.frame.size.height + title.frame.size.height + DetailTitleTopMargin*Proportion +DetailPriceTopMargin*Proportion + DetailInfoLeftMargin*Proportion*7 + introductionlabel.frame.size.height;
    
    }
    
}


- (void) shareCurrentPage{
    
    self.isShowConfirmationView = NO;
    [self showShareViewWithShareModel];
}


- (void) showShareViewWithShareModel{
    
    self.shareBigBGView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   self.view.frame.size.width,
                                                                   self.contentView.frame.size.height)];
    
    [self.contentView addSubview:self.shareBigBGView];
    [self.contentView bringSubviewToFront:self.shareBigBGView];
    
    /**分享信息*/
    self.shareMainBgView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    self.view.frame.size.height,
                                                                    self.view.frame.size.width,
                                                                    ShareMainViewHeight*Proportion)];
    self.shareMainBgView.backgroundColor = [UIColor whiteColor];
    [self.shareBigBGView addSubview:self.shareMainBgView];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, Proportion*(ShareMainViewHeight - CancelShareBtnHeight), self.view.frame.size.width, CancelShareBtnHeight*Proportion)];
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
    
    UIButton *converseBtn = [[UIButton alloc] initWithFrame:CGRectMake(FriendsShareLeftMargin*Proportion, ShareBtnTopMargin*Proportion, ShareBtnWidthAndHeight*Proportion, ShareBtnWidthAndHeight*Proportion)];
    [converseBtn addTarget:self action:@selector(shareToConverse) forControlEvents:UIControlEventTouchUpInside];
    [converseBtn setBackgroundImage:[UIImage imageNamed:KShareToConverImg] forState:UIControlStateNormal];
    [self.shareMainBgView addSubview:converseBtn];
    
    UILabel *converLabel = [[UILabel alloc] init];
    converLabel.font = KSystemFontSize9;
    converLabel.text = @"微信好友";
    converLabel.textColor = [UIColor CMLTabBarItemGrayColor];
    [converLabel sizeToFit];
    converLabel.frame = CGRectMake(converseBtn.center.x - converLabel.frame.size.width/2.0, CGRectGetMaxY(converseBtn.frame) + ShareTypeNameTopMargin*Proportion, converLabel.frame.size.width, converLabel.frame.size.height);
    [self.shareMainBgView addSubview:converLabel];
    
    UIButton *friendsBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(converseBtn.frame) + ShareBtnSpace*Proportion,ShareBtnTopMargin*Proportion , ShareBtnWidthAndHeight*Proportion, ShareBtnWidthAndHeight*Proportion)];
    [friendsBtn addTarget:self action:@selector(shareToCircleOfFriends) forControlEvents:UIControlEventTouchUpInside];
    [friendsBtn setBackgroundImage:[UIImage imageNamed:KShareToCircleImg] forState:UIControlStateNormal];
    [self.shareMainBgView addSubview:friendsBtn];
    
    UILabel *circleOfFriendsLabel = [[UILabel alloc] init];
    circleOfFriendsLabel.font = KSystemFontSize9;
    circleOfFriendsLabel.text = @"朋友圈";
    circleOfFriendsLabel.textColor = [UIColor CMLTabBarItemGrayColor];
    [circleOfFriendsLabel sizeToFit];
    circleOfFriendsLabel.frame = CGRectMake(friendsBtn.center.x - circleOfFriendsLabel.frame.size.width/2.0, CGRectGetMaxY(friendsBtn.frame) + ShareTypeNameTopMargin*Proportion, circleOfFriendsLabel.frame.size.width, circleOfFriendsLabel.frame.size.height);
    [self.shareMainBgView addSubview:circleOfFriendsLabel];
    
    
    UIButton *weiboBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(friendsBtn.frame) + ShareBtnSpace*Proportion,
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
    
    
    self.shareMainBgView.hidden = YES;
    
    /**预订信息确认*/
    
    self.informationConfirmationView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                               self.view.frame.size.height,
                                                                               self.view.frame.size.width ,
                                                                                ConfirmationViewHeight*Proportion)];
    self.informationConfirmationView.backgroundColor = [UIColor whiteColor];
    [self.shareBigBGView addSubview:self.informationConfirmationView];
    
    UIImageView *serveImage = [[UIImageView alloc] initWithFrame:CGRectMake(ConfirmationImageLeftMargin*Proportion,
                                                                            ConfirmationImageTopMargin*Proportion,
                                                                            ConfirmationImageWidth*Proportion,
                                                                            ConfirmationImageHeight*Proportion)];
    [NetWorkTask setImageView:serveImage WithURL:[NSURL URLWithString: self.obj.retData.coverPic] placeholderImage:nil];
    [self.informationConfirmationView addSubview:serveImage];
    
    UILabel *serveLabel = [[UILabel alloc] init];
    serveLabel.font = KSystemFontSize15;
    serveLabel.text = self.obj.retData.title;
    serveLabel.numberOfLines = 0;
    CGRect rect = [serveLabel.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 2*Proportion*ConfirmationImageLeftMargin - serveImage.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KSystemFontSize15} context:nil];
    
    serveLabel.frame =CGRectMake(CGRectGetMaxX(serveImage.frame) + ConfirmationImageLeftMargin*Proportion,
                                 ConfirmationImageTopMargin*Proportion,
                                 rect.size.width,
                                 rect.size.height);
    [self.informationConfirmationView addSubview:serveLabel];
    
    UILabel *servePriceLabel = [[UILabel alloc] init];
    servePriceLabel.font = KSystemFontSize12;
    servePriceLabel.text = [NSString stringWithFormat:@"%@/每人",self.obj.retData.totalAmount];
    [servePriceLabel sizeToFit];
    servePriceLabel.frame = CGRectMake(CGRectGetMaxX(serveImage.frame) + ConfirmationImageLeftMargin*Proportion,
                                       CGRectGetMaxY(serveImage.frame) - servePriceLabel.frame.size.height,
                                       servePriceLabel.frame.size.width,
                                       servePriceLabel.frame.size.height);
    servePriceLabel.textColor = [UIColor CMLInputTextGrayColor];
    [self.informationConfirmationView addSubview:servePriceLabel];
    
    CMLLine *serveLine = [[CMLLine alloc] init];
    serveLine.startingPoint = CGPointMake(0, CGRectGetMaxY(serveImage.frame) + ConfirmationImageTopMargin*Proportion);
    serveLine.lineWidth = 0.5;
    serveLine.LineColor = [UIColor CMLLineGrayColor];
    serveLine.lineLength = self.view.frame.size.width;
    [self.informationConfirmationView addSubview:serveLine];
    
    UILabel *serveContactlabel = [[UILabel alloc] init];
    serveContactlabel.text= @"联系人";
    serveContactlabel.font = KSystemFontSize13;
    [serveContactlabel sizeToFit];
    serveContactlabel.frame =CGRectMake(ConfirmationImageLeftMargin*Proportion,
                                        CGRectGetMaxY(serveImage.frame) + ConfirmationImageTopMargin*Proportion,
                                        serveContactlabel.frame.size.width,
                                        ConfimrationInfoHeight*Proportion);
    serveContactlabel.textAlignment = NSTextAlignmentLeft;
    [self.informationConfirmationView addSubview:serveContactlabel];
    
    UITextField *serveContactTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(serveContactlabel.frame),
                                                                                       serveContactlabel.frame.origin.y,
                                                                                       self.view.frame.size.width - 2*ConfirmationImageLeftMargin*Proportion - serveContactlabel.frame.size.width,
                                                                                       serveContactlabel.frame.size.height)];
    serveContactTextField.placeholder = @"请输入联系人姓名";
    serveContactTextField.font = KSystemFontSize13;
    serveContactTextField.textAlignment = NSTextAlignmentRight;
    serveContactTextField.text = [[DataManager lightData] readUserName];
    serveContactTextField.delegate = self;
    serveContactTextField.tag = 1;
    [serveContactTextField addTarget:self action:@selector(alterContact:) forControlEvents:UIControlEventEditingChanged];
    [self.informationConfirmationView addSubview:serveContactTextField];
    
    CMLLine *serveLineTwo = [[CMLLine alloc] init];
    serveLineTwo.startingPoint =CGPointMake(ConfirmationImageLeftMargin*Proportion, CGRectGetMaxY(serveContactlabel.frame));
    serveLineTwo.lineWidth = 0.5;
    serveLineTwo.lineLength = self.view.frame.size.width;
    serveLineTwo.LineColor = [UIColor CMLLineGrayColor];
    [self.informationConfirmationView addSubview:serveLineTwo];
    
    UILabel *servePhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(serveContactlabel.frame.origin.x,
                                                                         CGRectGetMaxY(serveContactlabel.frame),
                                                                         serveContactlabel.frame.size.width,
                                                                         serveContactlabel.frame.size.height)];
    servePhoneLabel.text = @"手机号";
    servePhoneLabel.font = KSystemFontSize13;
    servePhoneLabel.textAlignment = NSTextAlignmentLeft;
    [self.informationConfirmationView addSubview:servePhoneLabel];
    
    UITextField *servePhoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(serveContactTextField.frame.origin.x,
                                                                                     servePhoneLabel.frame.origin.y,
                                                                                     serveContactTextField.frame.size.width,
                                                                                     serveContactTextField.frame.size.height)];
    servePhoneTextField.placeholder = @"请输入手机号";
    servePhoneTextField.font = KSystemFontSize13;
    servePhoneTextField.textAlignment = NSTextAlignmentRight;
    servePhoneTextField.text = [[DataManager lightData] readPhone];
    servePhoneTextField.delegate = self;
    servePhoneTextField.tag = 2;
    [servePhoneTextField addTarget:self action:@selector(alterPhoneNum:) forControlEvents:UIControlEventEditingChanged];
    [self.informationConfirmationView addSubview:servePhoneTextField];
    
    CMLLine *serveLineThree = [[CMLLine alloc] init];
    serveLineThree.startingPoint = CGPointMake(0, CGRectGetMaxY(servePhoneLabel.frame));
    serveLineThree.lineWidth = 0.5;
    serveLineThree.lineLength = self.view.frame.size.width;
    serveLineThree.LineColor = [UIColor CMLLineGrayColor];
    [self.informationConfirmationView addSubview:serveLineThree];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(servePhoneLabel.frame), self.view.frame.size.width, self.informationConfirmationView.frame.size.height - CGRectGetMaxY(servePhoneLabel.frame))];
    confirmBtn.backgroundColor = [UIColor CMLVIPGrayColor];
    confirmBtn.titleLabel.font = KSystemFontSize15;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmAppointment) forControlEvents:UIControlEventTouchUpInside];
    [self.informationConfirmationView addSubview:confirmBtn];
    self.informationConfirmationView.hidden = YES;
    
    
    /**动画*/
    [UIView animateWithDuration:0.2 animations:^{
        
        self.shareBigBGView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }];
    
    if (self.isShowConfirmationView) {
      
        self.informationConfirmationView.hidden = NO;
        self.shareMainBgView.hidden = YES;
        [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.informationConfirmationView.frame = CGRectMake(0,
                                                    self.contentView.frame.size.height - ConfirmationViewHeight*Proportion,
                                                    self.view.frame.size.width,
                                                    ConfirmationViewHeight*Proportion);
        } completion:^(BOOL finished) {
            
            
        }];
    }else{
    
        self.informationConfirmationView.hidden = YES;
        self.shareMainBgView.hidden = NO;
        
        [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.shareMainBgView.frame = CGRectMake(0,
                                                    self.contentView.frame.size.height - ShareMainViewHeight*Proportion,
                                                    self.view.frame.size.width,
                                                    ShareMainViewHeight*Proportion);
        } completion:^(BOOL finished) {
            
            
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITextField *textFieldOfContact =  [self.informationConfirmationView viewWithTag:1];
    [textFieldOfContact resignFirstResponder];
    
    UITextField *textFieldOfPhone = [self.informationConfirmationView viewWithTag:2];
    [textFieldOfPhone resignFirstResponder];
    
    if (self.isShowConfirmationView) {
     
        if (self.isKeyBoardShow) {
          
            [UIView animateWithDuration:0.4 animations:^{
                self.informationConfirmationView.frame = CGRectMake(0,
                                                                    self.contentView.frame.size.height - ConfirmationViewHeight*Proportion,
                                                                    self.view.frame.size.width,
                                                                    ConfirmationViewHeight*Proportion);
            } completion:^(BOOL finished) {
                
            }];
        }else{
        
            [UIView animateWithDuration:0.4 animations:^{
                self.informationConfirmationView.frame = CGRectMake(0,
                                                                    self.contentView.frame.size.height,
                                                                    self.view.frame.size.width,
                                                                    ConfirmationViewHeight*Proportion);
            } completion:^(BOOL finished) {
                
            }];
        }

    }else{
    
        [UIView animateWithDuration:0.2 animations:^{
            self.shareMainBgView.frame = CGRectMake(0,
                                                    self.contentView.frame.size.height,
                                                    self.view.frame.size.width,
                                                    ShareMainViewHeight*Proportion);
        } completion:^(BOOL finished) {
            
        }];
    
    }
   
    if (!self.isKeyBoardShow) {
     
        [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.shareBigBGView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            
        } completion:^(BOOL finished) {
            
            
            [self.informationConfirmationView removeFromSuperview];
            [self.shareMainBgView removeFromSuperview];
            [self.shareBigBGView removeFromSuperview];
            
        }];
    }
    self.isKeyBoardShow = NO;
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
    
    [[UMSocialData defaultData].extConfig.wechatSessionData.urlResource setResourceType:UMSocialUrlResourceTypeWeb url:self.obj.retData.shareLink];
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

- (void) cancelShare {
    
    UITextField *textFieldOfContact =  [self.informationConfirmationView viewWithTag:1];
    [textFieldOfContact resignFirstResponder];
    
    UITextField *textFieldOfPhone = [self.informationConfirmationView viewWithTag:2];
    [textFieldOfPhone resignFirstResponder];

    if (self.isShowConfirmationView) {
      
        [UIView animateWithDuration:0.4 animations:^{
            self.informationConfirmationView.frame = CGRectMake(0,
                                                    self.contentView.frame.size.height,
                                                    self.view.frame.size.width,
                                                    ConfirmationViewHeight*Proportion);
        } completion:^(BOOL finished) {
            
        }];
    }else{
    
        [UIView animateWithDuration:0.2 animations:^{
            self.shareMainBgView.frame = CGRectMake(0,
                                                    self.contentView.frame.size.height,
                                                    self.view.frame.size.width,
                                                    ShareMainViewHeight*Proportion);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.shareBigBGView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        
        [self.informationConfirmationView removeFromSuperview];
        [self.shareMainBgView removeFromSuperview];
        [self.shareBigBGView removeFromSuperview];
        
    }];
    

}

- (void) sendShareAction{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.obj.retData.currentID forKey:@"objId"];
    [paraDic setObject:[NSNumber numberWithInt:3] forKey:@"objTypeId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.obj.retData.currentID,[NSNumber numberWithInt:3],skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:ActivityShare paraDic:paraDic delegate:delegate];
    self.currentApiName = ActivityShare;

}


#pragma mark - 监控键盘的高度
- (void)keyboardWasShown:(NSNotification*)aNotification{

    self.isKeyBoardShow = YES;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.25 animations:^{
        self.informationConfirmationView.frame =CGRectMake(0, self.contentView.frame.size.height -kbSize.height - ConfirmationViewHeight*Proportion , self.view.frame.size.width, ConfirmationViewHeight*Proportion);
    }];
}



-(void)keyboardWillBeHidden:(NSNotification*)aNotification{

    [UIView animateWithDuration:0.25 animations:^{
        self.informationConfirmationView.frame =CGRectMake(0, self.contentView.frame.size.height - ConfirmationViewHeight*Proportion , self.view.frame.size.width, ConfirmationViewHeight*Proportion);
    }];
    
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if (textField.tag == 1) {
        self.realUserName = textField.text;
    }else{
        self.phone =textField.text;
    }
}

- (void) alterPhoneNum:(UITextField*)textField{

    self.phone = textField.text;

}

- (void) alterContact:(UITextField*)textField{

    self.realUserName = textField.text;
}

#pragma mark - confirmAppointment

- (void) confirmAppointment{
    
    if (self.phone.length > 0) {
     
        if ((self.realUserName.length < 10) && (self.realUserName.length > 0)) {
            
            NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
            delegate.delegate = self;
            NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
            NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
            [paraDic setObject:self.obj.retData.currentID forKey:@"objId"];
            [paraDic setObject:self.obj.retData.typeId forKey:@"objType"];
            [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"actType"];
            [paraDic setObject:reqTime forKey:@"reqTime"];
            [paraDic setObject:reqTime forKey:@"order_time"];
            [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"clientId"];
            [paraDic setObject:[NSNumber numberWithInt:0] forKey:@"pay_amt_e2"];
            [paraDic setObject:self.phone forKey:@"contactPhone"];
            [paraDic setObject:self.realUserName forKey:@"contactUser"];
            NSString *skey = [[DataManager lightData] readSkey];
            [paraDic setObject:skey forKey:@"skey"];
            NSString *hashToken =[NSString getEncryptStringfrom:@[self.obj.retData.currentID,
                                                                  self.obj.retData.typeId,
                                                                  [NSNumber numberWithInt:1],
                                                                  [NSNumber numberWithInt:1],
                                                                  [NSNumber numberWithInt:0],
                                                                  self.realUserName,
                                                                  self.phone,
                                                                  reqTime,
                                                                  reqTime,
                                                                  skey]];
            [paraDic setObject:hashToken forKey:@"hashToken"];
            [NetWorkTask postResquestWithApiName:ServeSubscribe paraDic:paraDic delegate:delegate];
            self.currentApiName = ServeSubscribe;
            [self cancelShare];
            [self startLoading];
            
        }else{
        
            [self showAlterViewWithText:@"请规范输入您的姓名"];
        }
    }else{
    
        [self showAlterViewWithText:@"请输入电话"];
    }
}


#pragma mark - NavigationBarDelegate

- (void) didSelectedRightBarItem{

    [self showShareViewWithShareModel];
}

- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
    
}
@end
