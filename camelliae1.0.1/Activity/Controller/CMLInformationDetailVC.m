//
//  CMLInformationDetailVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/4/9.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLInformationDetailVC.h"
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
#import "CMLShareModel.h"
#import "CMLLine.h"
#import "WXApi.h"
#import "UIImage+CMLExspand.h"
#import "UMSocial.h"

#define Duration                  0.5f
#define FunctionViewHeight        83
#define ButtonWidth               26
#define ShareBtnHeight            37
#define CollectBtnHeightAndWidth  37
#define ButtonTopMargin           20
#define ButonLabelTopMargin       5

#define DetailInfoSpace           15
#define DetailInfoLeftMargin      25

#define DetailTopImageHeight      304
#define DetailTitleTopMargin      20
#define DetailTitleBottomMargin   23

#define ShareMainViewHeight              195
#define CancelShareBtnHeight             60
#define FriendsShareLeftMargin           43
#define ShareBtnTopMargin                26
#define ShareBtnSpace                    62
#define ShareBtnWidthAndHeight           58
#define ShareTypeNameTopMargin           16

@interface CMLInformationDetailVC ()<NavigationBarDelegate,NetWorkProtocol,UIWebViewDelegate,UIScrollViewDelegate,WXApiDelegate,WKUIDelegate,WKNavigationDelegate>

@property(nonatomic,strong) WKWebView *webView;

@property (nonatomic,assign) CGFloat currentOffSetY;

@property (nonatomic,strong) UIView *webBrowserView;

@property (nonatomic,strong) UIButton *collectBtn;

@property (nonatomic,strong) BaseResultObj *obj;

@property (nonatomic,assign) BOOL isShow;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UIView *shareBigBGView;

@property (nonatomic,strong) UIView *shareMainBgView;

@property (nonatomic,strong) UIImage *shareImage;

@property (nonatomic,strong) UIImage *shareToSinaImage;


@end

@implementation CMLInformationDetailVC

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
    
    [self loadViews];
    [self setNetWork];
    
}

- (void) loadViews{
    
    CGFloat screenW = self.view.frame.size.width - 20;
    
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
                                                               self.view.frame.size.width,
                                                               self.contentView.frame.size.height - self.navBar.frame.size.height) configuration:config];
    self.webView.UIDelegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.bounces = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
    
}

- (void) setNetWork{
    
    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSNumber *objId = self.objId;
    if (self.objId) {
      [paraDic setObject:objId forKey:@"objId"];
    }
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[objId,reqTime,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    if (objId) {
        [NetWorkTask postResquestWithApiName:NewsInfo paraDic:paraDic delegate:delegate];
        self.currentApiName = NewsInfo;
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

#pragma mark - NavigationBarDelegate

- (void) didSelectedLeftBarItem{
    
    [[VCManger mainVC] dismissCurrentVC];
    
}

- (void) didSelectedRightBarItem{

    [self showShareViewWithShareModel];
    
}


#pragma mark - UIWebViewDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    [self stopLoading];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{

    [self stopLoading];
    [self showAlterViewWithText:@"加载失败"];

}
#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{
   
    if ([self.currentApiName isEqualToString:NewsInfo]) {
        
        self.obj =[BaseResultObj getBaseObjFrom:responseResult];
        
        NSData *imageNata = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.obj.retData.coverPic]];
        UIImage *image = [UIImage imageWithData:imageNata];
        self.shareToSinaImage = image;
        UIImage *transitImage = [UIImage scaleToRect:image];
        self.shareImage = [UIImage scaleToSize:transitImage size:CGSizeMake(60, 60)];
        
        if ([self.obj.retCode intValue] == 0) {
            
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
            [UIView animateWithDuration:1 animations:^{
                self.webView.scrollView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
            }];
        
            if (self.obj.retData.isUserFav) {
                self.collectBtn.selected = YES;
            }else{
                self.collectBtn.selected = NO;
            }
            
            [self stopLoading];
        }
    }else if ([self.currentApiName isEqualToString:ActivityFav]){
        
        [self stopLoading];
        [self showAlterViewWithText:self.obj.retMsg];
        
    }else if ([self.currentApiName isEqualToString:ActivityShare]){
        

    }
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{
    
    [self showAlterViewWithText:@"失败"];
    [self stopLoading];
    [self showNotData];
    
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
    
    /**time**/
    NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:[self.obj.retData.publishDate intValue]];
    NSString *beginTimeStr = [NSDate getStringDependOnFormatterAFromDate: beginDate];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = [NSString stringWithFormat:@"%@",beginTimeStr];
    dateLabel.font = KSystemFontSize14;
    dateLabel.textColor = [UIColor CMLInputTextGrayColor];
    [dateLabel sizeToFit];
    dateLabel.frame =CGRectMake(DetailInfoLeftMargin*Proportion*2,
                                CGRectGetMaxY(title.frame) + DetailInfoSpace*Proportion,
                                dateLabel.frame.size.width,
                                dateLabel.frame.size.height);
    [view addSubview:dateLabel];

    
    UILabel *introductionlabel = [[UILabel alloc] init];
    introductionlabel.backgroundColor = [UIColor CMLVIPGrayColor];
    introductionlabel.text = self.obj.retData.briefIntro;
    introductionlabel.font = KSystemFontSize12;
    introductionlabel.numberOfLines = 0;
    CGRect introductionlabelRect =[introductionlabel.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - DetailInfoLeftMargin*Proportion*4, 10000)
                                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                                    attributes:@{NSFontAttributeName:KSystemFontSize12}
                                                                       context:nil];
    introductionlabel.frame = CGRectMake(DetailInfoLeftMargin*Proportion*2,
                                         CGRectGetMaxY(dateLabel.frame) + DetailInfoSpace*Proportion,
                                         self.view.frame.size.width - 4*DetailInfoLeftMargin*Proportion,
                                         introductionlabelRect.size.height );
    introductionlabel.textColor = [UIColor CMLLineGrayColor];
    [view addSubview:introductionlabel];
    

    
    
    return topImage.frame.size.height + title.frame.size.height + dateLabel.frame.size.height +introductionlabel.frame.size.height + DetailTitleTopMargin*Proportion + DetailInfoSpace*Proportion*4;
    
    
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
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.obj.retData.shareLink;
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
    [paraDic setObject:[NSNumber numberWithInt:1] forKey:@"objTypeId"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    
    NSString *hashToken = [NSString getEncryptStringfrom:@[self.obj.retData.currentID,[NSNumber numberWithInt:1],skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:ActivityShare paraDic:paraDic delegate:delegate];
    self.currentApiName = ActivityShare;
    
}
-(void) onReq:(BaseReq*)req{



}


-(void) onResp:(BaseResp*)resp{


}

@end
