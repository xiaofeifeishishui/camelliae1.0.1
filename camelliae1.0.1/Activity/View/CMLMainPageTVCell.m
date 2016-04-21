//
//  CMLMainPageTVCell.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/28.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLMainPageTVCell.h"
#import "NetWorkTask.h"
#import "CommonNumber.h"
#import "CommonImg.h"
#import "CMLLine.h"
#import "UIColor+SDExspand.h"
#import "CommonFont.h"

#define CMLPageTVCellHeight   260
#define CMLBGImageHeight      304
#define CMLVIPLevelLeftMargin 36
#define CMLVIPLevelHeight     44
#define CMLVIPLevelWidth      32


#define LineBoxLeftMargin         23
#define LineBoxTopMargin          101
#define LineBoxVerticalLineLength 16
#define TravelTopMargin           15
#define LineAndTravelNameMargin   6
#define LineWidth                 0.5
#define FineTune                  1

#define CharaterSpace             4

@interface CMLMainPageTVCell ()

@property (nonatomic,strong) UIView *imageCoverView;

@end

@implementation CMLMainPageTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self loadViews];
    }
    return self;
}


- (void) loadViews{

    self.clipsToBounds = YES;
    
}

- (void) reloadTableViewCell{
   
    /**设置背景图片*/
    self.backgroundImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                       -(CMLBGImageHeight - CMLPageTVCellHeight)*Proportion/2.0,
                                                                       [UIScreen mainScreen].bounds.size.width,
                                                                       CMLBGImageHeight*Proportion)];
    self.backgroundImg.userInteractionEnabled = YES;
    [self.contentView addSubview:self.backgroundImg];
    
    self.imageCoverView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   [UIScreen mainScreen].bounds.size.width,
                                                                   CMLPageTVCellHeight*Proportion)];
    [self.contentView addSubview:self.imageCoverView];
    
    
    /**设置VIP级别*/
    self.VIPView = [[UIImageView alloc] initWithFrame:CGRectMake(CMLVIPLevelLeftMargin*Proportion,
                                                                 0,
                                                                 CMLVIPLevelWidth*Proportion,
                                                                 CMLVIPLevelHeight*Proportion)];
    [self.contentView addSubview:self.VIPView];
    
    if (self.shortTitle.length > 0) {
    
        /**旅游标题*/
        UILabel *tourNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        tourNameLabel.font = KSpecialBoldFontSize;
        tourNameLabel.textColor = [UIColor CMLServeGrayColor];
        tourNameLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        tourNameLabel.shadowOffset =CGSizeMake(0,0);
        
        /**设置字距*/
        
        NSMutableAttributedString *tourNameAttributeStr = [[NSMutableAttributedString alloc]
                                                           initWithString:self.shortTitle];
        
        long spaceNum = CharaterSpace;
        CFNumberRef charaterSpaceNum = CFNumberCreate(kCFAllocatorDefault,
                                                      kCFNumberSInt8Type,
                                                      &spaceNum);
        
        [tourNameAttributeStr addAttribute:(id)NSKernAttributeName
                                     value:(__bridge id)charaterSpaceNum
                                     range:NSMakeRange(0,[tourNameAttributeStr length])];
        
        CFRelease(charaterSpaceNum);
        
        tourNameLabel.attributedText = tourNameAttributeStr;
        [tourNameLabel sizeToFit];
        tourNameLabel.frame = CGRectMake(0, 0,tourNameLabel.frame.size.width, tourNameLabel.frame.size.height);
        
        
        UIView *textBcakgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tourNameLabel.frame.size.width, tourNameLabel.frame.size.height+ LineAndTravelNameMargin*Proportion)];
        textBcakgroundView.center = self.backgroundImg.center;
        [self.imageCoverView addSubview:textBcakgroundView];
        [textBcakgroundView addSubview:tourNameLabel];
        
        
        /**顶线*/
        CMLLine *topLine = [[CMLLine alloc] init];
        topLine.startingPoint = CGPointMake(textBcakgroundView.frame.origin.x - LineBoxLeftMargin*Proportion ,
                                            textBcakgroundView.frame.origin.y - TravelTopMargin*Proportion );
        topLine.directionOfLine = HorizontalLine;
        topLine.lineLength = CGRectGetWidth(textBcakgroundView.frame) + 2*LineBoxLeftMargin*Proportion - CharaterSpace;
        topLine.LineColor = [UIColor CMLServeGrayColor];
        topLine.lineWidth = LineWidth;
        [self.imageCoverView addSubview:topLine];
        
        /**左线1*/
        CMLLine *leftLineOne = [[CMLLine alloc] init];
        leftLineOne.startingPoint = topLine.startingPoint;
        leftLineOne.directionOfLine = VerticalLine;
        leftLineOne.lineLength = LineBoxVerticalLineLength*Proportion;
        leftLineOne.LineColor = [UIColor CMLServeGrayColor];
        leftLineOne.lineWidth = LineWidth;
        [self.imageCoverView addSubview:leftLineOne];
        
        /**右线1*/
        CMLLine *RightLineOne = [[CMLLine alloc] init];
        RightLineOne.startingPoint = CGPointMake(leftLineOne.startingPoint.x + topLine.lineLength ,
                                                 topLine.startingPoint.y);
        RightLineOne.directionOfLine = VerticalLine;
        RightLineOne.lineLength = LineBoxVerticalLineLength*Proportion;
        RightLineOne.lineWidth = LineWidth;
        RightLineOne.LineColor = [UIColor CMLServeGrayColor];
        [self.imageCoverView addSubview:RightLineOne];
        
        /**底线*/
        CMLLine *bottomLine = [[CMLLine alloc] init];
        bottomLine.startingPoint = CGPointMake(topLine.startingPoint.x,
                                               CGRectGetMaxY(textBcakgroundView.frame) + TravelTopMargin*Proportion - FineTune);
        bottomLine.directionOfLine = HorizontalLine;
        bottomLine.lineWidth =LineWidth;
        bottomLine.lineLength = topLine.lineLength;
        bottomLine.LineColor = [UIColor CMLServeGrayColor];
        [self.imageCoverView addSubview:bottomLine];
        
        /**左线2*/
        CMLLine *leftLineTwo = [[CMLLine alloc] init];
        leftLineTwo.startingPoint = CGPointMake(leftLineOne.startingPoint.x,
                                                bottomLine.startingPoint.y - LineBoxVerticalLineLength*Proportion);
        leftLineTwo.directionOfLine = VerticalLine;
        leftLineTwo.LineColor = [UIColor CMLServeGrayColor];
        leftLineTwo.lineLength = LineBoxVerticalLineLength*Proportion;
        leftLineTwo.lineWidth = LineWidth;
        [self.imageCoverView addSubview:leftLineTwo];
        
        /**右线2*/
        CMLLine *rightLineTwo = [[CMLLine alloc] init];
        rightLineTwo.startingPoint = CGPointMake(RightLineOne.startingPoint.x,
                                                 bottomLine.startingPoint.y  - LineBoxVerticalLineLength*Proportion);
        rightLineTwo.directionOfLine = VerticalLine;
        rightLineTwo.LineColor = [UIColor CMLServeGrayColor];
        rightLineTwo.lineLength = LineBoxVerticalLineLength*Proportion;
        rightLineTwo.lineWidth =LineWidth;
        [self.imageCoverView addSubview:rightLineTwo];

    }
    
    
    if (!self.memberLevel) {
        self.memberLevel = 1;
    }
    switch (self.memberLevel) {
        case 1:
            self.VIPView.image = [UIImage imageNamed:KPinkImg];
            break;
        case 2:
            self.VIPView.image = [UIImage imageNamed:KVIPBlackPigmentImg];
            break;
        case 3:
            self.VIPView.image = [UIImage imageNamed:KGoldImg];
            break;
        case 4:
            self.VIPView.image = [UIImage imageNamed:KBlackImg];
            break;
            
        default:
            break;
    }
    
    [NetWorkTask setImageView:self.backgroundImg
                      WithURL:[NSURL URLWithString:self.imgUrl]
             placeholderImage:[UIImage imageNamed:KActivityPlaceholderImg]];
}

- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view{
    
    CGRect rectInSuperview = [tableView convertRect:self.frame toView:view];
    
    float distanceFromCenter = CGRectGetHeight(view.frame)/2 - CGRectGetMinY(rectInSuperview);
    float difference = CGRectGetHeight(self.backgroundImg.frame) - CGRectGetHeight(self.frame);
    float move = (distanceFromCenter / CGRectGetHeight(view.frame)) * difference;
    
    CGRect imageRect = self.backgroundImg.frame;
    imageRect.origin.y = -(difference/2)+move;
    self.backgroundImg.frame = imageRect;
}
@end
