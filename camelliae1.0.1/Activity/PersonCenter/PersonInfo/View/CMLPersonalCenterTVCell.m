//
//  CMLPersonalCenterTVCell.m
//  CAMELLIAE
//
//  Created by 张越 on 16/4/2.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLPersonalCenterTVCell.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"

#define RightMargin             36
#define LabelAndImageSpace      12

#define RowEnterBtnWidth   12
#define RowEnterBtnHeight  22

@interface CMLPersonalCenterTVCell () <UITextFieldDelegate>

@property (nonatomic,strong) UIImageView *image;

@property (nonatomic,strong) UILabel *attributeContentLabel;

@property (nonatomic,strong) UITextField *textFiled;

@end

@implementation CMLPersonalCenterTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadViews];
    }
    return self;
}


- (void) loadViews{

    self.image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BlackBackBtnOfRowImg]];
    self.image.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - (RightMargin + RowEnterBtnWidth)*Proportion, self.frame.size.height/2.0 - RowEnterBtnHeight*Proportion/2.0, RowEnterBtnWidth*Proportion, RowEnterBtnHeight*Proportion);
    [self addSubview:self.image];
    
    self.attributeContentLabel = [[UILabel alloc] init];
    self.attributeContentLabel.font = KSystemFontSize12;
    [self addSubview:self.attributeContentLabel];
    
    self.textFiled = [[UITextField alloc] init];
    self.textFiled.placeholder = @"未填写";
    self.textFiled.font = KSystemFontSize12;
    self.textFiled.textAlignment = NSTextAlignmentRight;
    self.textFiled.delegate = self;
    [self addSubview:self.textFiled];
    

}

- (void) refreshCell{

    
    self.image.hidden = self.hiddenIndicate;
    
    if (self.isTextField) {
        self.textFiled.tag = self.tag;
        self.image.hidden = YES;
        self.textFiled.text = self.attributeContent;
        self.textFiled.frame = CGRectMake(CGRectGetMaxX(self.attributeContentLabel.frame),
                                          0,
                                          [UIScreen mainScreen].bounds.size.width - CGRectGetMaxX(self.attributeContentLabel.frame) - RightMargin*Proportion,
                                          self.frame.size.height);
    }else{
    
        self.attributeContentLabel.text = self.attributeContent;
        [self.attributeContentLabel sizeToFit];
        if (self.hiddenIndicate) {
            
            self.attributeContentLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - RightMargin*Proportion - self.attributeContentLabel.frame.size.width,
                                                          self.frame.size.height/2.0 - self.attributeContentLabel.frame.size.height/2.0,
                                                          self.attributeContentLabel.frame.size.width,
                                                          self.attributeContentLabel.frame.size.height);
        }else{
            self.attributeContentLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - (RightMargin + RowEnterBtnWidth + LabelAndImageSpace)*Proportion - self.attributeContentLabel.frame.                  size.width ,
                                                          self.frame.size.height/2.0 - self.attributeContentLabel.frame.size.height/2.0,
                                                          self.attributeContentLabel.frame.size.width,
                                                          self.attributeContentLabel.frame.size.height);
            
        }
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    [self.delegate selectedTextField:textField];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{

   [self.delegate alterTextOfTextField:textField];
}
@end
