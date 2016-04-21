//
//  CMLPersonInfoVC.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/29.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLPersonInfoVC.h"
#import "UIColor+SDExspand.h"
#import "VCManger.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "CMLLine.h"
#import "CMLPersonalCenterTVCell.h"
#import "NetConfig.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "AppGroup.h"
#import "DataManager.h"
#import "NSString+CMLExspand.h"
#import "BaseResultObj.h"
#import "CMLLoginInterfaceVC.h"
#import "NSDate+CMLExspand.h"
#import "CMLAlterCodeVC.h"
#import "UIImage+CMLExspand.h"
#import "QNUploadManager.h"
#import "CMLRSAModule.h"


#define LineAndTextSpace        28
#define LeftMargin              36
#define SectionAndSectionSpace  20
#define RightMargin             36
#define BackBtnLeftMarigin      92
#define FooterViewHeight        190
#define UserHeadAllSpace        20

#define RowEnterBtnWidth   12
#define RowEnterBtnHeight  22

typedef NS_ENUM(NSInteger, NSPUIImageType){
    NSPUIImageType_JPEG,
    NSPUIImageType_PNG,
    NSPUIImageType_Unknown
};
static inline NSPUIImageType NSPUIImageTypeFromData(NSData *imageData){
    if (imageData.length > 4) {
        const unsigned char * bytes = [imageData bytes];
        
        if (bytes[0] == 0xff &&
            bytes[1] == 0xd8 &&
            bytes[2] == 0xff)
        {
            return NSPUIImageType_JPEG;
        }
        
        if (bytes[0] == 0x89 &&
            bytes[1] == 0x50 &&
            bytes[2] == 0x4e &&
            bytes[3] == 0x47)
        {
            return NSPUIImageType_PNG;
        }
    }
    
    return NSPUIImageType_Unknown;
}

@interface CMLPersonInfoVC () <NavigationBarDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource,NetWorkProtocol,CMLPersonInfoDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) UIView *pickerBackgroundView;

@property (nonatomic,strong) NSArray *infoAttributeArray;

@property (nonatomic,strong) UIPickerView *pickerView;

@property (nonatomic,assign) NSInteger currentAttributeTag;

@property (nonatomic,strong) NSArray *pickerViewDataSoureOneArray;

@property (nonatomic,strong) NSArray *pickerViewDataSourceTwoArray;

@property (nonatomic,strong) NSMutableArray *pickerViewDataSourceThreeArray;

@property (nonatomic,strong) NSMutableDictionary *personalInfoDic;

@property (nonatomic,assign) CGFloat rowHeight;

@property (nonatomic,copy) NSString *sexText;

@property (nonatomic,copy) NSString *yearText;

@property (nonatomic,copy) NSString *monthText;

@property (nonatomic,copy) NSString *dayText;

@property (nonatomic,strong) UITextField *rowTextField;

@property (nonatomic,copy) NSString *currentApiName;

@property (nonatomic,strong) UIImageView *userHeadImage;

@property (nonatomic,strong) UIImage *uploadImage;

@property (nonatomic,assign) int imageSize;

@property (nonatomic,copy) NSString *qiniuKey;

@property (nonatomic,copy) NSString *qiniuBucket;

@property (nonatomic,strong) QNUploadManager *uploadManager;

@property (nonatomic,strong) NSData *uploaderData;

@property (nonatomic,strong) NSData *uploaderData2;

@property (nonatomic,strong) NSData *uploaderData3;

@property (nonatomic,assign) BOOL isUploaderSuccess;



@end

@implementation CMLPersonInfoVC

- (NSMutableDictionary *)personalInfoDic{

    if (!_personalInfoDic) {
        _personalInfoDic = [NSMutableDictionary dictionary];
    }
    return _personalInfoDic;
}

- (NSMutableArray *)pickerViewDataSourceThreeArray{

    if (!_pickerViewDataSourceThreeArray) {
        _pickerViewDataSourceThreeArray = [NSMutableArray array];
    }
    return _pickerViewDataSourceThreeArray;
}

- (void) viewDidLoad{

    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor CMLVIPGrayColor];
    self.navBar.titleContent = @"个人信息";
    self.navBar.titleColor = [UIColor CMLTitleYellowColor];
    self.navBar.navigationBarDelegate = self;
    self.navBar.backgroundColor = [UIColor blackColor];
    [self.navBar setWhiteLeftBarItem];
    self.isUploaderSuccess = NO;
    
    
    [self loadData];
    
    [self loadViews];
    
    [self setChooseView];
    
    //注册键盘出现的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void) loadData{

    self.infoAttributeArray = @[@"头像",
                                @"用户名",
                                @"性别",
                                @"生日",
                                @"地区",
                                @"会员等级",
                                @"手机号",
                                @"真实姓名",
                                @"修改密码"];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"测试";
    label.font = KSystemFontSize12;
    [label sizeToFit];
    self.rowHeight = label.frame.size.height + 2*LineAndTextSpace*Proportion;
    
    /**数据初始化*/
    
    int sexNum = [self.userInfo.gender intValue];
    if (sexNum == 1) {
       self.sexText = @"男";
    }else{
       self.sexText = @"女";
    }

    if ([self.userInfo.birthday intValue] <= 0) {

        self.yearText = @"1970";
        self.monthText = @"01";
        self.dayText = @"01";
        [self.personalInfoDic setObject:[NSString stringWithFormat:@"%@-%@-%@",self.yearText,self.monthText,self.dayText] forKey:@"生日"];
        
    }else{

        NSDate *date =[NSDate dateWithTimeIntervalSince1970:[self.userInfo.birthday intValue]];
        
        NSString *dateStr = [NSDate getStringDependOnFormatterCFromDate:date];
        
        NSArray *array = [dateStr componentsSeparatedByString:@"-"];
        
        self.yearText = [array firstObject];
        
        self.monthText = array[1];
        
        self.dayText =[array lastObject];
        
        [self.personalInfoDic setObject:[NSString stringWithFormat:@"%@-%@-%@",self.yearText,self.monthText,self.dayText] forKey:@"生日"];
        
    }
    if (self.userInfo.userRealName) {
        [self.personalInfoDic setObject:self.userInfo.userRealName forKey:@"真实姓名"];
    }else{
    [self.personalInfoDic setObject:@"未填写" forKey:@"真实姓名"];
    }
    
    if (self.userInfo.nickName) {
      [self.personalInfoDic setObject:self.userInfo.nickName forKey:@"用户名"];
    }else{
    [self.personalInfoDic setObject:@"未填写" forKey:@"用户名"];
    }
    
    if (self.userInfo.address) {
     [self.personalInfoDic setObject:self.userInfo.address forKey:@"地区"];
    }else{
      [self.personalInfoDic setObject:@"未填写" forKey:@"地区"];
    }
    
}

- (void) loadViews{
    
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(self.navBar.frame),
                                                                       self.view.frame.size.width,
                                                                       self.contentView.frame.size.height - CGRectGetHeight(self.navBar.frame))];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    self.mainTableView.backgroundColor = [UIColor CMLVIPGrayColor];
    [self.contentView addSubview:self.mainTableView];
    

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 6;
    }else if (section == 1){
    
        return 3;
    }
    return 0;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return self.rowHeight;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return 0;
    }
    return SectionAndSectionSpace*Proportion;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"tableViewCell";
    CMLPersonalCenterTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CMLPersonalCenterTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = KSystemFontSize12;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        if (indexPath.section == 0) {
         cell.tag = indexPath.row;
        }else{
            cell.tag = 6 + indexPath.row;
        }
    }
    
    /**attribute*/
    if (indexPath.section == 0) {
        cell.textLabel.text = self.infoAttributeArray[indexPath.row];
    }else{
        cell.textLabel.text = self.infoAttributeArray[indexPath.row +6];
    }
    
    if ((indexPath.section == 0)&&(indexPath.row == 0)) {
        CGRect rect;
        for (int i = 0; i < [cell subviews].count; i++) {
            if ([[cell subviews][i] isKindOfClass:[UIImageView class]]) {
                rect = [cell subviews][i].frame;
                break;
            }
        }
        self.userHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake(rect.origin.x - cell.frame.size.height + UserHeadAllSpace*Proportion,
                                                                           UserHeadAllSpace*Proportion,
                                                                           cell.frame.size.height - 2*UserHeadAllSpace*Proportion,
                                                                           cell.frame.size.height - 2*UserHeadAllSpace*Proportion)];
        self.userHeadImage.layer.cornerRadius = self.userHeadImage.frame.size.height/2;
        self.userHeadImage.layer.masksToBounds=YES;
        
        [NetWorkTask setImageView:self.userHeadImage
                          WithURL:[NSURL URLWithString:self.userInfo.gravatar]
                 placeholderImage:nil];
        [cell addSubview:self.userHeadImage];
        
    }else if ((indexPath.section == 0)&&(indexPath.row == 1)){
        cell.hiddenIndicate = YES;
        cell.isTextField = YES;
        cell.attributeContent = self.userInfo.nickName;
    }else if ((indexPath.section == 0)&&(indexPath.row == 2)){
        cell.attributeContent = self.sexText;
        [self.personalInfoDic setObject:self.sexText forKey:@"性别"];
    }else if ((indexPath.section == 0)&&(indexPath.row == 3)){
        cell.attributeContent = [NSString stringWithFormat:@"%@-%@-%@",self.yearText,self.monthText,self.dayText];
    }else if ((indexPath.section == 0)&&(indexPath.row == 4)){
        cell.hiddenIndicate = YES;
        if (self.userInfo.address) {
            cell.attributeContent = self.userInfo.address;
        }else{
            cell.attributeContent = @"未填写";
        }
        
        cell.isTextField = YES;
    }else if ((indexPath.section == 0)&&(indexPath.row == 5)){
        cell.hiddenIndicate = YES;
        NSString *level;
        switch ([self.userInfo.memberLevel intValue]) {
            case 1:
                level = @"粉";
                break;
            case 2:
                level = @"黛";
                break;
            case 3:
                level = @"金";
                break;
            case 4:
                level = @"墨";
                break;
                
            default:
                break;
        }
        cell.attributeContent = level;
    }else if ((indexPath.section == 1)&&(indexPath.row == 0)){
        cell.hiddenIndicate = YES;
        cell.attributeContent = [NSString stringWithFormat:@"%@",self.userInfo.mobile];
    }else if ((indexPath.section == 1)&&(indexPath.row == 1)){
        cell.isTextField = YES;
        cell.hiddenIndicate = YES;
        cell.attributeContent = self.userInfo.userRealName;
    }else if ((indexPath.section == 1)&&(indexPath.row == 2)){
        
    }
    [cell refreshCell];
    
    return cell;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [self.rowTextField resignFirstResponder];

}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ((indexPath.section == 0)&&(indexPath.row == 0)) {
        
        [self.rowTextField resignFirstResponder];
        [self setPersonImage];
        
    }else if ((indexPath.section == 0)&&(indexPath.row == 1)){

    }else if ((indexPath.section == 0)&&(indexPath.row == 2)){
        
        [self.rowTextField resignFirstResponder];
        self.currentAttributeTag = 1;
        self.pickerViewDataSoureOneArray = @[@"女",
                                             @"男"];
        [self showPickerView];
        [self.pickerView reloadAllComponents];
    }else if ((indexPath.section == 0)&&(indexPath.row == 3)){
        
        [self.rowTextField resignFirstResponder];
        self.currentAttributeTag = 2;
        self.pickerViewDataSoureOneArray =@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
        self.pickerViewDataSourceTwoArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
        for (int i = 1970; i <= 2016; i++) {
            [self.pickerViewDataSourceThreeArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [self showPickerView];
        [self.pickerView reloadAllComponents];

        
    }else if ((indexPath.section == 0)&&(indexPath.row == 4)){
        self.currentAttributeTag = 3;
       
    }else if ((indexPath.section == 0)&&(indexPath.row == 5)){

    }else if ((indexPath.section == 1)&&(indexPath.row == 0)){

    }else if ((indexPath.section == 1)&&(indexPath.row == 1)){
        NSLog(@"修改姓名");

    }else if ((indexPath.section == 1)&&(indexPath.row == 2)){

        [self.rowTextField resignFirstResponder];
        CMLAlterCodeVC *vc = [[CMLAlterCodeVC alloc] init];
        [[VCManger mainVC] pushVC:vc animate:YES];
    }
    
}


- (void) setChooseView{

    self.pickerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height, self.view.frame.size.width, self.contentView.frame.size.height)];
    self.pickerBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.contentView addSubview:self.pickerBackgroundView];

}


- (void) setPickerView{

    UIView *btnBGView = [[UIView alloc] initWithFrame:CGRectMake(0, self.pickerBackgroundView.frame.size.height/3.0*2.0, self.view.frame.size.width, self.pickerBackgroundView.frame.size.height/12)];
    btnBGView.backgroundColor = [UIColor CMLVIPGrayColor];
    [self.pickerBackgroundView addSubview:btnBGView];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width/5, self.pickerBackgroundView.frame.size.height/12)];
    cancelBtn.titleLabel.font = KSystemFontSize14;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(hiddenPickerView) forControlEvents:UIControlEventTouchUpInside];
    [btnBGView addSubview:cancelBtn];
    UIButton *certainBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/5*4, 0, self.view.frame.size.width/5, self.pickerBackgroundView.frame.size.height/12)];
    certainBtn.titleLabel.font = KSystemFontSize14;
    [certainBtn addTarget:self action:@selector(certainAlterAttribute) forControlEvents:UIControlEventTouchUpInside];
    [certainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [certainBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    CMLLine *line = [[CMLLine alloc] init];
    line.startingPoint = CGPointMake(0, CGRectGetMaxY(btnBGView.frame)-1);
    line.lineWidth = 1;
    line.lineLength = self.view.frame.size.width;
    line.LineColor = [UIColor CMLLineGrayColor];
    [btnBGView addSubview:line];
    [btnBGView addSubview:certainBtn];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(btnBGView.frame), self.view.frame.size.width,self.pickerBackgroundView.frame.size.height/3.0 - CGRectGetHeight(btnBGView.frame))];
    pickerView.backgroundColor = [UIColor CMLVIPGrayColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    if (self.currentAttributeTag == 1) {
    
        for (int i = 0; i < self.pickerViewDataSoureOneArray.count; i++) {
            
            if ([self.pickerViewDataSoureOneArray[i] isEqualToString:self.sexText]) {
                [pickerView selectRow:i inComponent:0 animated:YES];
                
            }
        }
    
    }else if (self.currentAttributeTag == 2){
    
        for (int i = 0; i < self.pickerViewDataSoureOneArray.count; i++) {
            if ([self.pickerViewDataSoureOneArray[i] isEqualToString:self.monthText]) {
                [pickerView selectRow:i inComponent:0 animated:YES];
            }
        }
        for (int i = 0; i < self.pickerViewDataSourceTwoArray.count; i++) {
            if ([self.pickerViewDataSourceTwoArray[i] isEqualToString:self.dayText]) {
                [pickerView selectRow:i inComponent:1 animated:YES];
            }
        }
    }
    self.pickerView = pickerView;
    [self.pickerBackgroundView addSubview:pickerView];
    
}

#pragma mark - NavigationBarDelegate
- (void) didSelectedLeftBarItem{

    NSString *nickName = [self.personalInfoDic valueForKey:@"用户名"];
    NSString *sex = [self.personalInfoDic valueForKey:@"性别"];
    int sexNum;
    if ([sex isEqualToString:@"男"]) {
        sexNum = 1;
    }else{
        sexNum =2;
    }
    NSString *birth = [self.personalInfoDic valueForKey:@"生日"];
    NSString *address = [self.personalInfoDic valueForKey:@"地区"];
    NSString *realName = [self.personalInfoDic valueForKey:@"真实姓名"];
    
    if ([nickName isEqualToString:self.userInfo.nickName] && (sexNum == [self.userInfo.gender intValue]) && ([realName isEqualToString:self.userInfo.userRealName]) && ([birth isEqualToString:[NSString stringWithFormat:@"%@-%@-%@",self.yearText,self.monthText,self.dayText]]) && ([address isEqualToString:@"未填写"]|[address isEqualToString:self.userInfo.address])) {
    
        
        [[VCManger mainVC] dismissCurrentVC];
        
        if (self.isUploaderSuccess) {
            [[VCManger homeVC] viewDidLoad];
        }
        
    }else{
    
        /**时间转换*/
        NSDate *date =[NSDate getDateDependOnFormatterCFromString:[NSString stringWithFormat:@"%@-%@-%@",
                                                                   self.yearText,
                                                                   self.monthText,
                                                                   self.dayText]];
        
        NSTimeInterval timeInterval = [date timeIntervalSince1970];
        double reqTime = timeInterval;
        int time = reqTime;
        
        NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
        delegate.delegate = self;
        
        /**配置参数*/
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        
        if (time > 0) {
         [paraDic setObject:[NSNumber numberWithInt:time] forKey:@"birthday"];
        }
        
        if ([self.personalInfoDic valueForKey:@"地区"]) {
         [paraDic setObject:[self.personalInfoDic valueForKey:@"地区"] forKey:@"address"];
        }
        
        if ([self.personalInfoDic valueForKey:@"真实姓名"]) {
          [paraDic setObject:[self.personalInfoDic valueForKey:@"真实姓名"] forKey:@"userRealName"];
        }
        
        if ([self.personalInfoDic valueForKey:@"用户名"]) {
            [paraDic setObject:[self.personalInfoDic valueForKey:@"用户名"] forKey:@"nickName"];
        }
        if (sexNum) {
            [paraDic setObject:[NSNumber numberWithInt:sexNum] forKey:@"gender"];
        }
        
        [paraDic setObject:[NSNumber numberWithInt:[AppGroup getCurrentDate]] forKey:@"reqTime"];
        NSString *skey = [[DataManager lightData] readSkey];
        [paraDic setObject:skey forKey:@"skey"];
        NSString *hashToken = [NSString getEncryptStringfrom:@[[NSNumber numberWithInt:[AppGroup getCurrentDate]],skey]];
        [paraDic setObject:hashToken forKey:@"hashToken"];
        [NetWorkTask postResquestWithApiName:UpdateUser paraDic:paraDic delegate:delegate];
        self.currentApiName = UpdateUser;
        
        [self startLoading];
    }
}

#pragma mark - UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    if (self.currentAttributeTag == 1) {
        return 1;
    }else if (self.currentAttributeTag == 2){
        return 3;
    }else if (self.currentAttributeTag == 3){
        return 2;
    }
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    if (self.currentAttributeTag == 1) {
        return self.pickerViewDataSoureOneArray.count;
    }else if (self.currentAttributeTag == 2){
        if (component == 0) {
            return self.pickerViewDataSourceThreeArray.count;
        }else if (component == 1){
            return self.pickerViewDataSoureOneArray.count;
        }else{
           return self.pickerViewDataSourceTwoArray.count;
        }
    }else if (self.currentAttributeTag == 3){
        if (component == 0) {
            return self.pickerViewDataSoureOneArray.count;
        }else{
            return self.pickerViewDataSourceTwoArray.count;
        }
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (self.currentAttributeTag == 1) {
        return self.pickerViewDataSoureOneArray[row];
    }else if (self.currentAttributeTag == 2){
        if (component == 0) {
            return self.pickerViewDataSourceThreeArray[row];
        }else if (component == 1){
            return self.pickerViewDataSoureOneArray[row];
        }else{
            return self.pickerViewDataSourceTwoArray[row];
        }
    }else if (self.currentAttributeTag == 3){
        
    }
    return nil;
    
}

#pragma mark -

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if (self.currentAttributeTag == 1) {
        self.sexText = self.pickerViewDataSoureOneArray[row];
        
    }else if (self.currentAttributeTag == 2){
    
        if (component == 0) {
            self.yearText = self.pickerViewDataSourceThreeArray[row];
        }else if (component == 1){
            self.monthText = self.pickerViewDataSoureOneArray[row];
        }else{
            self.dayText = self.pickerViewDataSourceTwoArray[row];
        }
    }
}


#pragma mark - showAndHiddenPickerView

- (void) showPickerView{

    [self setPickerView];
    [UIView animateWithDuration:0.3 animations:^{
    
        self.pickerBackgroundView.frame = CGRectMake(0,
                                                     0,
                                                     self.contentView.frame.size.width,
                                                     self.contentView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void) hiddenPickerView{

    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.pickerBackgroundView.frame = CGRectMake(0,
                                                     self.contentView.frame.size.height,
                                                     self.view.frame.size.width,
                                                     self.contentView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        NSArray *array = [self.pickerBackgroundView subviews];
        
        for (int i = 0; i < array.count; i++) {
            [array[i] removeFromSuperview];
        }
        
        
    }];

}

#pragma mark - certainAlterAttribute

- (void) certainAlterAttribute{

    [self hiddenPickerView];
    [self.mainTableView reloadData];
}


#pragma mark -chooseOfimage

- (void) setPersonImage{

    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"图片库选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"摄像头拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [vc addAction:action1];
    [vc addAction:action2];
    [vc addAction:action3];
    [self presentViewController:vc animated:YES completion:^{
        [self certainAlterAttribute];
    }];

}

#pragma mark - NetWorkProtocol
/**网络请求回调*/
- (void) requestSucceedBack:(id)responseResult
                withApiName:(NSString *)apiName{

    BaseResultObj *obj = [BaseResultObj getBaseObjFrom:responseResult];
    
    if ([self.currentApiName isEqualToString:UpdateUser]){
    
        if ([obj.retCode intValue] == 0) {
        
                [[VCManger mainVC] dismissCurrentVC];
                [[VCManger homeVC] viewDidLoad];
        
        }else{
        
            [self showAlterViewWithText:obj.retMsg];
        }
    }else if ([self.currentApiName isEqualToString:UpGravatar]){
    
        
        self.qiniuKey = obj.retData.uploadKeyName;
        self.qiniuBucket = obj.retData.uploadBucket;
        
        NSString *token = [CMLRSAModule decryptString:obj.retData.upToken publicKey:PUBKEY];
       /**上传图片*/
        
        self.uploadManager = [[QNUploadManager alloc] init];
        
        __block CMLPersonInfoVC *vc = self;
        [self.uploadManager putData:self.uploaderData key:self.qiniuKey token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            vc.isUploaderSuccess = YES;
            
        } option:nil];
        
        
//        [self.uploadManager putData:self.uploaderData2 key:self.qiniuKey token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//            NSLog(@"2****%@",info);
//            
//        } option:nil];
//        [self.uploadManager putData:self.uploaderData3 key:self.qiniuKey token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//            NSLog(@"3****%@",info);
//            
//        } option:nil];
        
    
    }
    
    [self stopLoading];
}

- (void) requestFailBack:(id)errorResult
             withApiName:(NSString *)apiName{

    [self stopLoading];
    
}

#pragma mark - 监控键盘的高度
- (void)keyboardWasShown:(NSNotification*)aNotification{

    
}



-(void)keyboardWillBeHidden:(NSNotification*)aNotification{
    
    
}

#pragma mark - CMLPersonInfoDelegate

- (void) selectedTextField:(UITextField *)textField{

    self.rowTextField = textField;

}

- (void) alterTextOfTextField:(UITextField *) textField{
    
    if (textField.tag == 1) {
        [self.personalInfoDic setObject:textField.text forKey:@"用户名"];
    }else if (textField.tag == 4){
        [self.personalInfoDic setObject:textField.text forKey:@"地区"];
    }else if (textField.tag == 7){
        [self.personalInfoDic setObject:textField.text forKey:@"真实姓名"];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.rowTextField resignFirstResponder];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]){
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.userHeadImage.image = image;
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil){
            data = UIImageJPEGRepresentation(image, 1.0);
        }else{
            data = UIImagePNGRepresentation(image);
        }
        
        /**压缩并获取大小*/
        self.uploadImage = [UIImage scaleToSize:image size:CGSizeMake(300, 300)];
        UIImage *image2 = [UIImage scaleToSize:image size:CGSizeMake(200, 200)];
        UIImage *image3 = [UIImage scaleToSize:image size:CGSizeMake(500, 500)];
        NSData *compressImageData = UIImageJPEGRepresentation(self.uploadImage, 1.0);
        self.imageSize = (int)compressImageData.length;
        
        NSPUIImageType imageType = NSPUIImageTypeFromData(data);
        
        if (imageType == NSPUIImageType_JPEG) {
        
            self.uploaderData = UIImageJPEGRepresentation(self.uploadImage, 1.0);
            self.uploaderData2 = UIImageJPEGRepresentation(image2, 1.0);
            self.uploaderData3 = UIImageJPEGRepresentation(image3, 1.0);
            NSLog(@"该图片格式为jpeg");
            [self sendImageWithType:@"jpg"];
        }else{
            NSLog(@"该图片格式为png");
            self.uploaderData = UIImagePNGRepresentation(self.uploadImage);
            self.uploaderData2 = UIImagePNGRepresentation(image2);
            self.uploaderData3 = UIImagePNGRepresentation(image3);
            [self sendImageWithType:@"png"];
        
        }
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) sendImageWithType:(NSString*) type{

    NetWorkDelegate *delegate = [[NetWorkDelegate alloc] init];
    delegate.delegate = self;
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    [paraDic setObject:[NSNumber numberWithInt:300] forKey:@"imgWidth"];
    [paraDic setObject:[NSNumber numberWithInt:300] forKey:@"imgHeight"];
    [paraDic setObject:type forKey:@"imgType"];
    NSNumber *reqTime = [NSNumber numberWithInt:[AppGroup getCurrentDate]];
    [paraDic setObject:reqTime forKey:@"reqTime"];
    [paraDic setObject:[NSNumber numberWithInt:self.imageSize] forKey:@"fileSize"];
    NSString *skey = [[DataManager lightData] readSkey];
    [paraDic setObject:skey forKey:@"skey"];
    NSString *hashToken = [NSString getEncryptStringfrom:@[reqTime,type,skey]];
    [paraDic setObject:hashToken forKey:@"hashToken"];
    
    [NetWorkTask postResquestWithApiName:UpGravatar paraDic:paraDic delegate:delegate];
    self.currentApiName = UpGravatar;
    

}

@end
