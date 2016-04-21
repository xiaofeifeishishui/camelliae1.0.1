//
//  CMLServeTVCell.m
//  camelliae1.0.1
//
//  Created by 张越 on 16/4/20.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLServeTVCell.h"
#import "CMLLine.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NSString+CMLExspand.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "CommonImg.h"


#define BackGroundImageHeight     304
#define TableViewVellHeight       260
#define LineBoxLeftMargin         23
#define LineBoxTopMargin          101
#define LineBoxVerticalLineLength 16
#define TravelTopMargin           15
#define LineAndTravelNameMargin   6
#define LineWidth                 0.5
#define FineTune                  1

#define CharaterSpace             4

@interface CMLServeTVCell ()

@property (nonatomic,strong) UIView *imageCoveView;

@property (nonatomic,strong) UIImageView *BGImage;

@end

@implementation CMLServeTVCell

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

- (void) refreshTableViewCell{

    self.BGImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                 -(BackGroundImageHeight - TableViewVellHeight)*Proportion/2.0,
                                                                 [UIScreen mainScreen].bounds.size.width,
                                                                 BackGroundImageHeight*Proportion)];
    self.BGImage.userInteractionEnabled = YES;
    [self.contentView addSubview:self.BGImage];
    
    self.imageCoveView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  [UIScreen mainScreen].bounds.size.width,
                                                                  TableViewVellHeight*Proportion)];
    [self.contentView addSubview:self.imageCoveView];
    /**旅游标题*/
    UILabel *tourNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    tourNameLabel.font = KSpecialBoldFontSize;
    tourNameLabel.textColor = [UIColor CMLServeGrayColor];
    tourNameLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    tourNameLabel.shadowOffset =CGSizeMake(0,0);
    
    /**设置字距*/
    
    NSMutableAttributedString *tourNameAttributeStr = [[NSMutableAttributedString alloc]
                                                       initWithString:self.serveName];
    
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
    textBcakgroundView.center = self.imageCoveView.center;
    [self.imageCoveView addSubview:textBcakgroundView];
    [textBcakgroundView addSubview:tourNameLabel];
    
    
    /**顶线*/
    CMLLine *topLine = [[CMLLine alloc] init];
    topLine.startingPoint = CGPointMake(textBcakgroundView.frame.origin.x - LineBoxLeftMargin*Proportion ,
                                        textBcakgroundView.frame.origin.y - TravelTopMargin*Proportion );
    topLine.directionOfLine = HorizontalLine;
    topLine.lineLength = CGRectGetWidth(textBcakgroundView.frame) + 2*LineBoxLeftMargin*Proportion - CharaterSpace;
    topLine.LineColor = [UIColor CMLServeGrayColor];
    topLine.lineWidth = LineWidth;
    [self.imageCoveView addSubview:topLine];
    
    /**左线1*/
    CMLLine *leftLineOne = [[CMLLine alloc] init];
    leftLineOne.startingPoint = topLine.startingPoint;
    leftLineOne.directionOfLine = VerticalLine;
    leftLineOne.lineLength = LineBoxVerticalLineLength*Proportion;
    leftLineOne.LineColor = [UIColor CMLServeGrayColor];
    leftLineOne.lineWidth = LineWidth;
    [self.imageCoveView addSubview:leftLineOne];
    
    /**右线1*/
    CMLLine *RightLineOne = [[CMLLine alloc] init];
    RightLineOne.startingPoint = CGPointMake(leftLineOne.startingPoint.x + topLine.lineLength ,
                                             topLine.startingPoint.y);
    RightLineOne.directionOfLine = VerticalLine;
    RightLineOne.lineLength = LineBoxVerticalLineLength*Proportion;
    RightLineOne.lineWidth = LineWidth;
    RightLineOne.LineColor = [UIColor CMLServeGrayColor];
    [self.imageCoveView addSubview:RightLineOne];
    
    /**底线*/
    CMLLine *bottomLine = [[CMLLine alloc] init];
    bottomLine.startingPoint = CGPointMake(topLine.startingPoint.x,
                                           CGRectGetMaxY(textBcakgroundView.frame) + TravelTopMargin*Proportion - FineTune);
    bottomLine.directionOfLine = HorizontalLine;
    bottomLine.lineWidth =LineWidth;
    bottomLine.lineLength = topLine.lineLength;
    bottomLine.LineColor = [UIColor CMLServeGrayColor];
    [self.imageCoveView addSubview:bottomLine];
    
    /**左线2*/
    CMLLine *leftLineTwo = [[CMLLine alloc] init];
    leftLineTwo.startingPoint = CGPointMake(leftLineOne.startingPoint.x,
                                            bottomLine.startingPoint.y - LineBoxVerticalLineLength*Proportion);
    leftLineTwo.directionOfLine = VerticalLine;
    leftLineTwo.LineColor = [UIColor CMLServeGrayColor];
    leftLineTwo.lineLength = LineBoxVerticalLineLength*Proportion;
    leftLineTwo.lineWidth = LineWidth;
    [self.imageCoveView addSubview:leftLineTwo];
    
    /**右线2*/
    CMLLine *rightLineTwo = [[CMLLine alloc] init];
    rightLineTwo.startingPoint = CGPointMake(RightLineOne.startingPoint.x,
                                             bottomLine.startingPoint.y  - LineBoxVerticalLineLength*Proportion);
    rightLineTwo.directionOfLine = VerticalLine;
    rightLineTwo.LineColor = [UIColor CMLServeGrayColor];
    rightLineTwo.lineLength = LineBoxVerticalLineLength*Proportion;
    rightLineTwo.lineWidth =LineWidth;
    [self.imageCoveView addSubview:rightLineTwo];
    
    [NetWorkTask setImageView:self.BGImage
                      WithURL:[NSURL URLWithString:self.imageUrl]
             placeholderImage:[UIImage imageNamed:KActivityPlaceholderImg]];

}

- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view{
    
    CGRect rectInSuperview = [tableView convertRect:self.frame toView:view];
    
    float distanceFromCenter = CGRectGetHeight(view.frame)/2 - CGRectGetMinY(rectInSuperview);
    float difference = CGRectGetHeight(self.BGImage.frame) - CGRectGetHeight(self.frame);
    float move = (distanceFromCenter / CGRectGetHeight(view.frame)) * difference;
    
    CGRect imageRect = self.BGImage.frame;
    imageRect.origin.y = -(difference/2)+move;
    self.BGImage.frame = imageRect;
}
@end
