//
//  CMLExerciseTopView.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/26.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLActivityTopView.h"
#import "CommonImg.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "DataManager.h"
#import "NSString+CMLExspand.h"

#define LOGOTopMargin              30
#define LOGOWidth                  218
#define LOGOHeight                 28

#define PersonalCenterRightMargin  36
#define PersonalCenterHeight       34
#define PersonalCenterWidth        29

#define CurrentPlaceRightMargin    36
#define CurrentPlaceHeight         34
#define CurrentPlaceWidth          29    

@interface CMLActivityTopView ()

@property (nonatomic,strong) UIButton *currentPlaceBtn;

@property (nonatomic,strong) UIImageView *logoImg;

@end

@implementation CMLActivityTopView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:KNavcImg]];
        [self loadViews];
    }
    return self;
}


- (void) loadViews{

    /**设置LOGO的位置*/
    self.logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0 - LOGOWidth*Proportion/2.0,
                                                                 LOGOTopMargin*Proportion,
                                                                 LOGOWidth*Proportion,
                                                                 LOGOHeight*Proportion)];
    self.logoImg.image = [UIImage imageNamed:KLOGOImg];
    [self addSubview:self.logoImg];
    
    /**个人中心*/
    UIButton *personalCenterBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - self.frame.size.height, 0, self.frame.size.height, self.frame.size.height)];
    [personalCenterBtn setImage:[UIImage imageNamed:KPersonalImg] forState:UIControlStateNormal];
    [personalCenterBtn addTarget:self action:@selector(showPersonCenterInterface) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:personalCenterBtn];
    
    /**位置*/
    self.currentPlaceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      self.logoImg.frame.origin.x,
                                                                      self.frame.size.height)];
    [self addSubview:self.currentPlaceBtn];

}


#pragma mark - showPersonCenterInterface

- (void) showPersonCenterInterface{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPersonCenterInterface" object:nil];
}

#pragma mark - chooseCity

- (void) chooseCity{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseCity" object:nil];
}

-(void) refreshCity{

    [self.currentPlaceBtn setImage :[UIImage imageNamed:KPlaceImg] forState:UIControlStateNormal];
    self.currentPlaceBtn.titleLabel.font = KSystemFontSize12;
    NSNumber *cityID = [[DataManager lightData] readCityID];
    [self.currentPlaceBtn setTitle:[NSString getCityNameWithCityID:cityID] forState:UIControlStateNormal];
    [self.currentPlaceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-60*Proportion, 0,0)];
    [self.currentPlaceBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-80*Proportion, 0 ,0)];
    [self.currentPlaceBtn addTarget:self action:@selector(chooseCity) forControlEvents:UIControlEventTouchUpInside];

}
@end
