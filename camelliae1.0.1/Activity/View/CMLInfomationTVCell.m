//
//  CMLInfomationTVCell.m
//  camelliae1.0.1
//
//  Created by 张越 on 16/4/21.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLInfomationTVCell.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "NSString+CMLExspand.h"
#import "UIColor+SDExspand.h"
#import "NetWorkTask.h"
#import "CommonImg.h"


#define BackGroundImageHeight     304
#define TableViewVellHeight       260


@interface CMLInfomationTVCell ()

@property (nonatomic,strong) UIImageView *BGImage;

@end

@implementation CMLInfomationTVCell

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
