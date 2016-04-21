//
//  CMLAppointmentTVCell.m
//  CAMELLIAE
//
//  Created by 张越 on 16/4/8.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLAppointmentTVCell.h"
#import "NetWorkTask.h"
#import "NetWorkDelegate.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"


#define MainImageHeight      170
#define MainImageWidth       238
#define MainImageLeftMargin  36
#define MainImageTopMargin   16
#define SignImageHeight      23
#define SignImageWidth       74

@interface CMLAppointmentTVCell ()

@property (nonatomic,strong) UIImageView *image;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) UIImageView *signImage;

@end

@implementation CMLAppointmentTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self loadViews];
    }
    return self;
}

- (void) loadViews{

    self.image = [[UIImageView alloc] init];
    self.image.frame =CGRectMake(MainImageLeftMargin*Proportion,
                            MainImageTopMargin*Proportion,
                            MainImageWidth*Proportion,
                            MainImageHeight*Proportion);
    [self addSubview:self.image];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = KSystemFontSize13;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font =KSystemFontSize11;
    self.contentLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.contentLabel];
    
    self.signImage = [[UIImageView alloc] init];
    self.signImage.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - MainImageLeftMargin*Proportion - SignImageWidth*Proportion,
                                      CGRectGetMaxY(self.image.frame) - SignImageHeight*Proportion,
                                      SignImageWidth*Proportion,
                                      SignImageHeight*Proportion);
    self.signImage.hidden = YES;
    [self addSubview:self.signImage];
    

}


- (void) refreshTableViewCell{

    self.titleLabel.text =self.title;
    CGRect titleLabelRect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width - self.image.frame.size.width - MainImageLeftMargin*Proportion*3, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KSystemFontSize13} context:nil];
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.image.frame) + MainImageLeftMargin*Proportion , self.image.frame.origin.y, titleLabelRect.size.width , titleLabelRect.size.height);
    self.contentLabel.text = self.content;
    CGRect rect = [self.content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - self.image.frame.size.width - 3*MainImageLeftMargin*Proportion, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KSystemFontSize11} context:nil];
    self.contentLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, CGRectGetMaxY(self.titleLabel.frame) + MainImageTopMargin*Proportion, rect.size.width, rect.size.height);
    
    [NetWorkTask setImageView:self.image WithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:KActivityPlaceholderImg]];
    
    if (self.isShowExpire == YES) {
        self.signImage.hidden = NO;
        if ([self.showExpire intValue] == 1) {
            
            self.signImage.image = [UIImage imageNamed:KNotExpiredImg];
        }else{
            self.signImage.image = [UIImage imageNamed:KExpiredImg];
        }
        
    }else{
        self.signImage.hidden = YES;
    }
    
    if ([self.showDelegate intValue] == 2) {
        self.backgroundColor = [UIColor grayColor];
    }

}
@end
