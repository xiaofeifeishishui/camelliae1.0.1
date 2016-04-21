//
//  CMLFontLayout.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/30.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLFontLayout.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"

#define LabelLeftMargin        38
#define StageImageLeftMargin   18
#define StageWidthAndHeight    8

@implementation CMLFontLayout

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (CGFloat) setFontLayoutWith:(NSString *) text{

    self.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] init];
    label.font = KSystemFontSize10;
    label.numberOfLines = 0;
    label.text = text;
    CGSize LabelSize = [label.text boundingRectWithSize:CGSizeMake(self.frame.size.width - StageImageLeftMargin*Proportion, 1000)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:KSystemFontSize10} context:nil].size;
    
    CGSize setSize = [label.text sizeWithAttributes:@{NSFontAttributeName:KSystemFontSize10}];
    
    label.frame = CGRectMake(LabelLeftMargin*Proportion, 0, self.frame.size.width - LabelLeftMargin*Proportion, LabelSize.height);
    [self addSubview:label];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:KVIPDetailStageImg]];
    image.frame = CGRectMake(StageImageLeftMargin*Proportion, setSize.height/2.0 - StageWidthAndHeight*Proportion/2.0, StageWidthAndHeight*Proportion, StageWidthAndHeight*Proportion);
    [self addSubview:image];
    
    
    return LabelSize.height;
}

- (CGFloat) setFontLayoutWith:(NSString *) text dependFont:(UIFont *) font{
    
    self.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] init];
    label.font = KSystemFontSize12;
    label.numberOfLines = 0;
    label.text = text;
    CGSize LabelSize = [label.text boundingRectWithSize:CGSizeMake(self.frame.size.width - StageImageLeftMargin*Proportion, 1000)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:KSystemFontSize12} context:nil].size;
    
    CGSize setSize = [label.text sizeWithAttributes:@{NSFontAttributeName:KSystemFontSize12}];
    
    label.frame = CGRectMake(LabelLeftMargin*Proportion, 0, self.frame.size.width - LabelLeftMargin*Proportion, LabelSize.height);
    [self addSubview:label];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:KVIPDetailStageImg]];
    image.frame = CGRectMake(StageImageLeftMargin*Proportion, setSize.height/2.0 - StageWidthAndHeight*Proportion/2.0, StageWidthAndHeight*Proportion, StageWidthAndHeight*Proportion);
    [self addSubview:image];
    
    
    return LabelSize.height;
}
@end
