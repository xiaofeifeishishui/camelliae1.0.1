//
//  CMLCityChooseVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/29.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLCityChooseVC.h"
#import "CommonNumber.h"
#import "CommonFont.h"
#import "CommonImg.h"
#import "CMLLine.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "BaseResultObj.h"
#import "CMLCityObj.h"
#import "NSString+CMLExspand.h"
#import "DataManager.h"
#import "VCManger.h"
#import "UIColor+SDExspand.h"


#define CityPickerHeight        400
#define CityPicekerLeftMargin   40

#define CloseVCButtonLeftMargin  30
#define CloseVCButtonTopMargin   80
#define CloseVCButtonHeight      80

#define LineTopMargin            20


@interface CMLCityChooseVC () <UIPickerViewDataSource,UIPickerViewDelegate,NetWorkProtocol,NavigationBarDelegate>

@property (nonatomic,strong) NSArray *cityArray;

@property (nonatomic,strong) NSMutableDictionary *cityID;

@property (nonatomic,strong) UIPickerView *pickerView;

@property (nonatomic,strong) NSNumber *currentCityID;

@end
@implementation CMLCityChooseVC


- (void)viewDidLoad{

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navBar.backgroundColor = [UIColor blackColor];
    self.contentView.backgroundColor =[UIColor lightGrayColor];
    self.navBar.titleContent = @"选择城市";
    self.navBar.titleColor = [UIColor CMLTitleYellowColor];
    self.navBar.navigationBarDelegate = self;
    [self.navBar setCancelBarItem];
    [self.navBar setCertainBarItem];
    
    self.cityArray = @[@"北京",
                       @"天津",
                       @"河北",
                       @"山西",
                       @"内蒙古",
                       @"辽宁",
                       @"吉林",
                       @"黑龙江",
                       @"上海",
                       @"江苏",
                       @"浙江",
                       @"安徽",
                       @"福建",
                       @"江西",
                       @"山东",
                       @"河南",
                       @"湖北",
                       @"湖南",
                       @"广东",
                       @"广西",
                       @"海南",
                       @"重庆",
                       @"四川",
                       @"贵州",
                       @"云南",
                       @"西藏",
                       @"陕西",
                       @"甘肃",
                       @"青海",
                       @"宁夏",
                       @"新疆",
                       @"台湾",
                       @"香港",
                       @"澳门"];
    
    [self loadViews];

}

- (void) loadViews{
    
    /**选择器*/
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(CityPicekerLeftMargin*Proportion,
                                                                            self.view.frame.size.height/2.0 - CityPickerHeight*Proportion/2.0,
                                                                            self.view.frame.size.width - CityPicekerLeftMargin*Proportion*2 ,
                                                                            CityPickerHeight*Proportion)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    self.pickerView = pickerView;
    NSNumber *currentCityNum = [[DataManager lightData] readCityID];
    [self.pickerView selectRow:([currentCityNum intValue] - 1 ) inComponent:0 animated:YES];
    [self.contentView addSubview:self.pickerView];
    
}

#pragma mark - UIPickerViewDataSource


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;

}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return self.cityArray.count;

}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    return self.cityArray[row];

}


#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    self.currentCityID = [NSNumber numberWithInteger:(row + 1)];
    
}

#pragma mark - backMainVC

- (void) backMainVC{

    [self dismissViewControllerAnimated:YES completion:^{
        if (self.currentCityID) {
          [[DataManager lightData] saveCityID:self.currentCityID];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refershActivityViewAndCity" object:nil userInfo:nil];
    }];
}

- (void) didSelectedLeftBarItem{

    [self dismissViewControllerAnimated:YES completion:^{

    }];

}
- (void) didSelectedRightBarItem{

    [self backMainVC];

}
@end
