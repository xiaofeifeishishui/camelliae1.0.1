//
//  CMLSysNoticeTVCell.m
//  CAMELLIAE
//
//  Created by 张越 on 16/4/10.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLSysNoticeTVCell.h"
#import "CommonFont.h"
#import "CommonNumber.h"
#import "UIColor+SDExspand.h"


#define TitleTopMargin          33
#define TextBottomMargin        33
#define TitleAndTextSpace       30
#define TitleAndTextLeftMargin  36


@interface CMLSysNoticeTVCell ()

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *briefIntroLabel;

@end

@implementation CMLSysNoticeTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
     
        [self loadViews];
    }
    return self;
}


- (void) loadViews{

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = KSystemFontSize15;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor CMLInputTextGrayColor];
    [self addSubview:self.titleLabel];
    
    self.briefIntroLabel = [[UILabel alloc] init];
    self.briefIntroLabel.font = KSystemFontSize13;
    self.briefIntroLabel.textAlignment = NSTextAlignmentLeft;
    self.briefIntroLabel.textColor = [UIColor CMLInputTextGrayColor];
    [self addSubview:self.briefIntroLabel];
    

}

- (CGFloat) getRowHeight{

    self.titleLabel.text = self.currentTitle;
    [self.titleLabel sizeToFit];
    self.titleLabel.frame =CGRectMake(TitleAndTextLeftMargin*Proportion,
                                      TitleTopMargin*Proportion,
                                      self.titleLabel.frame.size.width,
                                      self.titleLabel.frame.size.height);
    
    self.briefIntroLabel.text = self.currentText;
    [self.briefIntroLabel sizeToFit];
    self.briefIntroLabel.frame = CGRectMake(TitleAndTextLeftMargin*Proportion,
                                      CGRectGetMaxY(self.titleLabel.frame) + TitleAndTextSpace*Proportion,
                                      self.briefIntroLabel.frame.size.width,
                                      self.briefIntroLabel.frame.size.height);
    
    return (TitleTopMargin*Proportion + TitleAndTextSpace *Proportion + TextBottomMargin*Proportion + self.titleLabel.frame.size.height + self.briefIntroLabel.frame.size.height);

}
@end
