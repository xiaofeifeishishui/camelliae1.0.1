//
//  CMLVIPDetailVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/30.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLVIPDetailVC.h"
#import "CommonImg.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "UIColor+SDExspand.h"
#import "CMLFontLayout.h"
#import "VCManger.h"
#import "CMLIntroduceUpgradeVC.h"


#define VIPLOGOHeight             144
#define VIPLOGOWidth              228
#define VIPLOGOBackgroundHeight   304
#define VIPStageLeftMargin        36
#define VIPStageTopMargin         35
#define VIPTitleOneTopMagin       20
#define VIPTitleAndTitleMagin     11
#define VIPUpgradeHeight          46
#define VIPUpgradeWidth           149
#define VIPUpgradeBottomMargin    61
#define VIPCamelliaHeight         178
#define VIPCamelliaWidth          279
#define VIPCamelliaTopMargin      17

@interface CMLVIPDetailVC()<NavigationBarDelegate>

@property (nonatomic,strong) UIImageView *bgImg;

@property (nonatomic,strong) UILabel *VIPStage;

@end

@implementation CMLVIPDetailVC

- (void)viewDidLoad{

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *camellia = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - VIPCamelliaWidth*Proportion,
                                                                          self.contentView.frame.size.height - VIPCamelliaHeight*Proportion,
                                                                          VIPCamelliaWidth*Proportion,
                                                                          VIPCamelliaHeight*Proportion)];
    camellia.image = [UIImage imageNamed:KVIPDetailCamelliaImg];
    [self.contentView addSubview:camellia];
    
    [self.navBar setLeftBarItem];
    self.navBar.navigationBarDelegate = self;
    
    switch (self.currentRank) {
        case VIPRankOfPink:
            [self loadPinkViews];
            break;
        case VIPRankOfPurple:
            [self loadPurpleViews];
            break;
        case VIPRankGold:
            [self loadGoldViews];
            break;
        case VIPRankLnk:
            [self loadLnkViews];
            break;
            
        default:
            break;
    }
    
}



- (void) loadPinkViews{
    
    self.navBar.titleContent= @"粉色会员";
    [self loadLOGO:KVIPLOGOImg AndLOGOBackground:KVIPDetailPinkImg];
    
    self.VIPStage = [[UILabel alloc] init];
    self.VIPStage .text = @"粉色会员";
    self.VIPStage .font = KSystemFontSize15;
    [self.VIPStage  sizeToFit];
    self.VIPStage .frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                CGRectGetMaxY(self.bgImg.frame)+ VIPStageTopMargin*Proportion,
                                self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                self.VIPStage .frame.size.height);
    self.VIPStage .backgroundColor = [UIColor CMLVIPGrayColor];
    [self.contentView addSubview:self.VIPStage ];
    
    
    /*****/
    UILabel *titleOne = [[UILabel alloc] init];
    titleOne.text = @"主动申请卡枚连会员，真实完整地填写《会员申请表》，提交后取得会员编号，即加入卡枚连，成为粉色会员可享受：";
    titleOne.font = KSystemFontSize10;
    titleOne.numberOfLines = 0;

    CGSize setSize = [titleOne.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion, 1000)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:KSystemFontSize10}
                                                 context:nil].size;
    titleOne.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                CGRectGetMaxY(self.VIPStage .frame)+VIPTitleOneTopMagin*Proportion,
                                CGRectGetWidth(self.VIPStage .frame),
                                setSize.height);
    
    titleOne.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:titleOne];
    
    /**1*/
    CMLFontLayout *fontLayoutOne = [[CMLFontLayout alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                                   0,
                                                                                   self.view.frame.size.width -VIPStageLeftMargin*Proportion*2,
                                                                                   0)];
    CGFloat fontLayoutOneHeight = [fontLayoutOne setFontLayoutWith:@"免费活动资讯，线上自由选择喜欢的粉色活动，免费报名参加；"];
    fontLayoutOne.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                     CGRectGetMaxY(titleOne.frame) + VIPTitleAndTitleMagin*Proportion,
                                     self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                     fontLayoutOneHeight);
    [self.contentView addSubview:fontLayoutOne];

    
    /**2*/
    CMLFontLayout *fontLayoutTwo = [[CMLFontLayout alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                                   0,
                                                                                   self.view.frame.size.width -VIPStageLeftMargin*Proportion*2,
                                                                                   0)];
    CGFloat fontLayoutTwoHeight = [fontLayoutTwo setFontLayoutWith:@"粉色会员其它福利（不定期惊喜）。"];
    fontLayoutTwo.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                     CGRectGetMaxY(fontLayoutOne.frame) + VIPTitleAndTitleMagin*Proportion,
                                     self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                     fontLayoutTwoHeight);
    [self.contentView addSubview:fontLayoutTwo];
    
    UILabel *describeLabel = [[UILabel alloc] init];
    describeLabel.text =@"说明";
    CGSize describeSize = [describeLabel.text sizeWithAttributes:@{NSFontAttributeName:KSystemFontSize10}];
    describeLabel.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                     CGRectGetMaxY(fontLayoutTwo.frame) + VIPStageTopMargin*Proportion,
                                     self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                     describeSize.height);
    describeLabel.textAlignment =NSTextAlignmentLeft;
    describeLabel.font = KSystemFontSize10;
    describeLabel.backgroundColor = [UIColor CMLVIPGrayColor];
    [self.contentView addSubview:describeLabel];
    
    /**3*/
    CMLFontLayout *fontLayoutThree = [[CMLFontLayout alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                                     CGRectGetMaxY(describeLabel.frame) + VIPTitleOneTopMagin*Proportion,
                                                                                     self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                                                                     0)];
    CGFloat fontLayoutHeight = [fontLayoutThree setFontLayoutWith:@"粉色活动是指由其他品牌或机构举办的活动，不是由卡枚连组织策划的活动，包括其它品牌或机构的发布会、服装秀、推介会、展览会等，活动现场结识商界精英、设计师、时尚达人等，了解社会潮流、时尚动态、文化艺术等；"];
    fontLayoutThree.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                       CGRectGetMaxY(describeLabel.frame) + VIPTitleOneTopMagin*Proportion,
                                       self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                       fontLayoutHeight);
    [self.contentView addSubview:fontLayoutThree];
    
    /**4*/
    CMLFontLayout *fontLayoutFour = [[CMLFontLayout alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                                    CGRectGetMaxY(describeLabel.frame) + VIPTitleOneTopMagin*Proportion,
                                                                                    self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                                                                    0)];
    CGFloat fontLayoutFourHeight = [fontLayoutFour setFontLayoutWith:@"卡枚连作为活动发布平台，为其他品牌或机构发布活动资讯，卡枚连对粉色活动享有所有免责权益。"];
    fontLayoutFour.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                      CGRectGetMaxY(fontLayoutThree.frame) + VIPTitleAndTitleMagin*Proportion,
                                      self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                      fontLayoutFourHeight);
    [self.contentView addSubview:fontLayoutFour];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                  self.contentView.frame.size.height - VIPUpgradeHeight*Proportion - VIPUpgradeBottomMargin*Proportion,
                                                                  VIPUpgradeWidth*Proportion,
                                                                  VIPUpgradeHeight*Proportion)];
    [button setImage:[UIImage imageNamed:KVIPUpgradeImg] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(enterUpgradeVC) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    




}

- (void) loadPurpleViews{
    self.navBar.titleContent= @"黛色会员";
    [self loadLOGO:KVIPLOGOImg AndLOGOBackground:KVIPDetailPurpleImg];
    
    self.VIPStage = [[UILabel alloc] init];
    self.VIPStage .text = @"黛色会员";
    self.VIPStage .font = KSystemFontSize15;
    [self.VIPStage  sizeToFit];
    self.VIPStage .frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                      CGRectGetMaxY(self.bgImg.frame)+ VIPStageTopMargin*Proportion,
                                      self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                      self.VIPStage .frame.size.height);
    self.VIPStage .backgroundColor = [UIColor CMLVIPGrayColor];
    [self.contentView addSubview:self.VIPStage ];
    
    /*****/
    UILabel *titleOne = [[UILabel alloc] init];
    titleOne.text = @"会员通过卡枚连APP线上服务板块消费满20万（2000积分），即成为黛色会员，可尊享：";
    titleOne.font = KSystemFontSize10;
    titleOne.numberOfLines = 0;
    
    CGSize setSize = [titleOne.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion, 1000)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:KSystemFontSize10}
                                                 context:nil].size;
    titleOne.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                CGRectGetMaxY(self.VIPStage .frame)+VIPTitleOneTopMagin*Proportion,
                                CGRectGetWidth(self.VIPStage .frame),
                                setSize.height);
    
    titleOne.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:titleOne];
    
    /**1*/
    CMLFontLayout *fontLayoutOne = [[CMLFontLayout alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                                   0,
                                                                                   self.view.frame.size.width -VIPStageLeftMargin*Proportion*2,
                                                                                   0)];
    CGFloat fontLayoutOneHeight = [fontLayoutOne setFontLayoutWith:@"卡枚连APP免费会员形象图文展示；"];
    fontLayoutOne.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                     CGRectGetMaxY(titleOne.frame) + VIPTitleAndTitleMagin*Proportion,
                                     self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                     fontLayoutOneHeight);
    [self.contentView addSubview:fontLayoutOne];
    
    
    /**2*/
    CMLFontLayout *fontLayoutTwo = [[CMLFontLayout alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                                   0,
                                                                                   self.view.frame.size.width -VIPStageLeftMargin*Proportion*2,
                                                                                   0)];
    CGFloat fontLayoutTwoHeight = [fontLayoutTwo setFontLayoutWith:@"选择更多权益的活动，如：卡枚连主办的精品下午茶、读书会、试吃品鉴活动、演唱会、音乐会、歌剧会、话剧等丰富多彩的高端活动；"];
    fontLayoutTwo.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                     CGRectGetMaxY(fontLayoutOne.frame) + VIPTitleAndTitleMagin*Proportion,
                                     self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                     fontLayoutTwoHeight);
    [self.contentView addSubview:fontLayoutTwo];
    
    /**3*/
    CMLFontLayout *fontLayoutThree = [[CMLFontLayout alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                                   0,
                                                                                   self.view.frame.size.width -VIPStageLeftMargin*Proportion*2,
                                                                                   0)];
    CGFloat fontLayoutThreeHeight = [fontLayoutThree setFontLayoutWith:@"黛色会员其它福利（不定期送积分及礼品惊喜）。"];
    fontLayoutThree.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                     CGRectGetMaxY(fontLayoutTwo.frame) + VIPTitleAndTitleMagin*Proportion,
                                     self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                     fontLayoutThreeHeight);
    [self.contentView addSubview:fontLayoutThree];
    
    UILabel *describeLabel = [[UILabel alloc] init];
    describeLabel.text =@"说明";
    CGSize describeSize = [describeLabel.text sizeWithAttributes:@{NSFontAttributeName:KSystemFontSize10}];
    describeLabel.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                     CGRectGetMaxY(fontLayoutThree.frame) + VIPStageTopMargin*Proportion,
                                     self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                     describeSize.height);
    describeLabel.textAlignment =NSTextAlignmentLeft;
    describeLabel.font = KSystemFontSize10;
    describeLabel.backgroundColor = [UIColor CMLVIPGrayColor];
    [self.contentView addSubview:describeLabel];
    
    /**4*/
    CMLFontLayout *fontLayoutFour = [[CMLFontLayout alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                                     CGRectGetMaxY(describeLabel.frame) + VIPTitleOneTopMagin*Proportion,
                                                                                     self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                                                                     0)];
    CGFloat fontLayoutFourHeight = [fontLayoutFour setFontLayoutWith:@"黛色活动是指由卡枚连组织策划的专场活动；"];
    fontLayoutFour.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                       CGRectGetMaxY(describeLabel.frame) + VIPTitleOneTopMagin*Proportion,
                                       self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                       fontLayoutFourHeight);
    [self.contentView addSubview:fontLayoutFour];
    
    /**5*/
    CMLFontLayout *fontLayoutFive = [[CMLFontLayout alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                                    CGRectGetMaxY(describeLabel.frame) + VIPTitleOneTopMagin*Proportion,
                                                                                    self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                                                                    0)];
    CGFloat fontLayoutFiveHeight = [fontLayoutFive setFontLayoutWith:@"活动现场尊享特别优惠折扣，会员专属福利及礼品。"];
    fontLayoutFive.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                      CGRectGetMaxY(fontLayoutFour.frame) + VIPTitleAndTitleMagin*Proportion,
                                      self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                      fontLayoutFiveHeight);
    [self.contentView addSubview:fontLayoutFive];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                  self.contentView.frame.size.height - VIPUpgradeHeight*Proportion - VIPUpgradeBottomMargin*Proportion,
                                                                  VIPUpgradeWidth*Proportion,
                                                                  VIPUpgradeHeight*Proportion)];
    [button setImage:[UIImage imageNamed:KVIPUpgradeImg] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(enterUpgradeVC) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    
}

- (void) loadGoldViews{
    self.navBar.titleContent= @"金色会员";
    [self loadLOGO:KVIPDetailGoldLOGOImg AndLOGOBackground:KVIPDetailGoldImg];
    
    self.VIPStage = [[UILabel alloc] init];
    self.VIPStage .text = @"金色会员";
    self.VIPStage .font = KSystemFontSize15;
    [self.VIPStage  sizeToFit];
    self.VIPStage .frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                      CGRectGetMaxY(self.bgImg.frame)+ VIPStageTopMargin*Proportion,
                                      self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                      self.VIPStage .frame.size.height);
    self.VIPStage .backgroundColor = [UIColor CMLVIPGrayColor];
    [self.contentView addSubview:self.VIPStage ];
    
    /*****/
    UILabel *titleOne = [[UILabel alloc] init];
    titleOne.text = @"会员通过卡枚连APP线上消费满200万元（20000积分），即成为金色会员，可尊享：";
    titleOne.font = KSystemFontSize10;
    titleOne.numberOfLines = 0;
    
    CGSize setSize = [titleOne.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion, 1000)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:KSystemFontSize10}
                                                 context:nil].size;
    titleOne.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                CGRectGetMaxY(self.VIPStage .frame)+VIPTitleOneTopMagin*Proportion,
                                CGRectGetWidth(self.VIPStage .frame),
                                setSize.height);
    
    titleOne.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:titleOne];
    
    /**1*/
    CMLFontLayout *fontLayoutOne = [[CMLFontLayout alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                                   0,
                                                                                   self.view.frame.size.width -VIPStageLeftMargin*Proportion*2,
                                                                                   0)];
    CGFloat fontLayoutOneHeight = [fontLayoutOne setFontLayoutWith:@"金色会员升级礼品；"];
    fontLayoutOne.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                     CGRectGetMaxY(titleOne.frame) + VIPTitleAndTitleMagin*Proportion,
                                     self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                     fontLayoutOneHeight);
    [self.contentView addSubview:fontLayoutOne];
    
    
    /**2*/
    CMLFontLayout *fontLayoutTwo = [[CMLFontLayout alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                                   0,
                                                                                   self.view.frame.size.width -VIPStageLeftMargin*Proportion*2,
                                                                                   0)];
    CGFloat fontLayoutTwoHeight = [fontLayoutTwo setFontLayoutWith:@"选择更多活动权益，如大型晚宴、慈善晚宴、年终盛典、社交舞会、精品旅游等顶级活动体验；"];
    fontLayoutTwo.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                     CGRectGetMaxY(fontLayoutOne.frame) + VIPTitleAndTitleMagin*Proportion,
                                     self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                     fontLayoutTwoHeight);
    [self.contentView addSubview:fontLayoutTwo];
    
    /**3*/
    CMLFontLayout *fontLayoutThree = [[CMLFontLayout alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                                     0,
                                                                                     self.view.frame.size.width -VIPStageLeftMargin*Proportion*2,
                                                                                     0)];
    CGFloat fontLayoutThreeHeight = [fontLayoutThree setFontLayoutWith:@"金色会员生日当月APP线上消费，获得双倍积分；"];
    fontLayoutThree.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                       CGRectGetMaxY(fontLayoutTwo.frame) + VIPTitleAndTitleMagin*Proportion,
                                       self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                       fontLayoutThreeHeight);
    [self.contentView addSubview:fontLayoutThree];
    
    /**4*/
    CMLFontLayout *fontLayoutFour = [[CMLFontLayout alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                                     0,
                                                                                     self.view.frame.size.width -VIPStageLeftMargin*Proportion*2,
                                                                                     0)];
    CGFloat fontLayoutFourHeight = [fontLayoutFour setFontLayoutWith:@"有机会在卡枚连年终盛典上获得奖项并登台领奖；"];
    fontLayoutFour.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                       CGRectGetMaxY(fontLayoutThree.frame) + VIPTitleAndTitleMagin*Proportion,
                                       self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                       fontLayoutFourHeight);
    [self.contentView addSubview:fontLayoutFour];
    
    /**5*/
    CMLFontLayout *fontLayoutFive = [[CMLFontLayout alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                                     0,
                                                                                     self.view.frame.size.width -VIPStageLeftMargin*Proportion*2,
                                                                                     0)];
    CGFloat fontLayoutFiveHeight = [fontLayoutFive setFontLayoutWith:@"策划会员形象定位及媒体包装；"];
    fontLayoutFive.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                       CGRectGetMaxY(fontLayoutFour.frame) + VIPTitleAndTitleMagin*Proportion,
                                       self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                       fontLayoutFiveHeight);
    [self.contentView addSubview:fontLayoutFive];
    
    /**6*/
    CMLFontLayout *fontLayoutSix = [[CMLFontLayout alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                                     0,
                                                                                     self.view.frame.size.width -VIPStageLeftMargin*Proportion*2,
                                                                                     0)];
    CGFloat fontLayoutSixHeight = [fontLayoutSix setFontLayoutWith:@"金色会员其它福利（不定期送积分及礼品惊喜）。"];
    fontLayoutSix.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                       CGRectGetMaxY(fontLayoutFive.frame) + VIPTitleAndTitleMagin*Proportion,
                                       self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                       fontLayoutSixHeight);
    [self.contentView addSubview:fontLayoutSix];
    
    UILabel *describeLabel = [[UILabel alloc] init];
    describeLabel.text =@"说明";
    CGSize describeSize = [describeLabel.text sizeWithAttributes:@{NSFontAttributeName:KSystemFontSize10}];
    describeLabel.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                     CGRectGetMaxY(fontLayoutSix.frame) + VIPStageTopMargin*Proportion,
                                     self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                     describeSize.height);
    describeLabel.textAlignment =NSTextAlignmentLeft;
    describeLabel.font = KSystemFontSize10;
    describeLabel.backgroundColor = [UIColor CMLVIPGrayColor];
    [self.contentView addSubview:describeLabel];
    
    /**7*/
    CMLFontLayout *fontLayoutSeven = [[CMLFontLayout alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                                    CGRectGetMaxY(describeLabel.frame) + VIPTitleOneTopMagin*Proportion,
                                                                                    self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                                                                    0)];
    CGFloat fontLayoutSevenHeight = [fontLayoutSeven setFontLayoutWith:@"金色活动是指由卡枚连特别举办或邀请的顶级活动，包括：卡枚连年终盛典、卡枚连&芭莎公益慈善晚宴、一线品牌晚宴、明星名流政要见面会，与海外名人、国家政要等成功人士友好结识，亲密交流，合影留念；"];
    fontLayoutSeven.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                      CGRectGetMaxY(describeLabel.frame) + VIPTitleOneTopMagin*Proportion,
                                      self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                      fontLayoutSevenHeight);
    [self.contentView bringSubviewToFront:fontLayoutSeven];
    [self.contentView addSubview:fontLayoutSeven];
    
    /**8*/
    CMLFontLayout *fontLayoutEight = [[CMLFontLayout alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                                    CGRectGetMaxY(describeLabel.frame) + VIPTitleOneTopMagin*Proportion,
                                                                                    self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                                                                    0)];
    CGFloat fontLayoutEightHeight = [fontLayoutEight setFontLayoutWith:@"活动所产生的机票、住宿、捐赠等相关费用，须由金色会员本人自行承担。"];
    fontLayoutEight.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                      CGRectGetMaxY(fontLayoutSeven.frame) + VIPTitleAndTitleMagin*Proportion,
                                      self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                      fontLayoutEightHeight);
    fontLayoutEight.backgroundColor = [UIColor clearColor];
    [self.contentView bringSubviewToFront:fontLayoutEight];
    [self.contentView addSubview:fontLayoutEight];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(VIPStageLeftMargin*Proportion,
                                                                  CGRectGetMaxY(fontLayoutEight.frame) + VIPCamelliaTopMargin*Proportion,
                                                                  VIPUpgradeWidth*Proportion,
                                                                  VIPUpgradeHeight*Proportion)];
    [button setImage:[UIImage imageNamed:KVIPUpgradeImg] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(enterUpgradeVC) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];


    
    
    
    
}

- (void) loadLnkViews{
 
    self.navBar.titleContent= @"墨色会员";
    [self loadLOGO:KVIPDetailLnkLOGOImg AndLOGOBackground:KVIPDetailLnkImg];
    
    self.VIPStage = [[UILabel alloc] init];
    self.VIPStage .text = @"墨色会员";
    self.VIPStage .font = KSystemFontSize15;
    [self.VIPStage  sizeToFit];
    self.VIPStage .frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                      CGRectGetMaxY(self.bgImg.frame)+ VIPStageTopMargin*Proportion,
                                      self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion,
                                      self.VIPStage .frame.size.height);
    self.VIPStage .backgroundColor = [UIColor CMLVIPGrayColor];
    [self.contentView addSubview:self.VIPStage ];
    
    
    /*****/
    UILabel *titleOne = [[UILabel alloc] init];
    titleOne.text = @"墨色会员是卡枚连最高等级会员，为实名制邀请制，会员名单浮动、不固定，每年由卡枚连从金色会员中选取。";
    titleOne.font = KSystemFontSize10;
    titleOne.numberOfLines = 0;
    
    CGSize setSize = [titleOne.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 2*VIPStageLeftMargin*Proportion, 1000)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:KSystemFontSize10}
                                                 context:nil].size;
    titleOne.frame = CGRectMake(VIPStageLeftMargin*Proportion,
                                CGRectGetMaxY(self.VIPStage .frame)+VIPTitleOneTopMagin*Proportion,
                                CGRectGetWidth(self.VIPStage .frame),
                                setSize.height);
    
    titleOne.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:titleOne];

    
    
    
    
}

- (void) loadLOGO:(NSString*)logo AndLOGOBackground:(NSString *) background{

    self.bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:background]];
    self.bgImg.frame = CGRectMake(0, CGRectGetMaxY(self.navBar.frame), self.view.frame.size.width, VIPLOGOBackgroundHeight*Proportion);
    [self.contentView addSubview:self.bgImg];
    
    UIImageView *logoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:logo]];
    logoImg.frame = CGRectMake(self.bgImg.frame.size.width/2.0 - VIPLOGOWidth*Proportion/2.0,
                               self.bgImg.frame.size.height/2.0 - VIPLOGOHeight*Proportion/2.0,
                               VIPLOGOWidth*Proportion,
                               VIPLOGOHeight*Proportion);
    [self.bgImg addSubview:logoImg];
    

}

#pragma mark - enterUpgradeVC

- (void) enterUpgradeVC{

    CMLIntroduceUpgradeVC *vc = [[CMLIntroduceUpgradeVC alloc] init];
    
    [[VCManger mainVC] pushVC:vc animate:YES];
    
}


- (void) didSelectedLeftBarItem{

    [[VCManger mainVC] popViewControllerAnimated:YES];

}
@end
