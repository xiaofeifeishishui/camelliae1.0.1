//
//  CMLNavigationBar.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/25.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLNavigationBar.h"
#import "CommonImg.h"
#import "CommonFont.h"
#import "CommonNumber.h"

#define NAVBARHEIGHT              88
#define LeftBarItemletfMargin     36
#define BackBtnWidth              15
#define BackBtnHeight             28

@implementation CMLNavigationBar

- (instancetype)init{

    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, NAVBARHEIGHT*Proportion);
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = self.backgroundColor;
    titleLabel.text = self.titleContent;
    titleLabel.font = KSystemFontSize15;
    [titleLabel sizeToFit];
    titleLabel.center = self.center;
    if (!self.titleColor) {
        titleLabel.textColor = [UIColor blackColor];
    }else{
        titleLabel.textColor = self.titleColor;
    }
    
    [self addSubview:titleLabel];
    
}

- (void) setLeftBarItem{
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  NAVBARHEIGHT*Proportion,
                                                                  NAVBARHEIGHT*Proportion)];
    [button setImage:[UIImage imageNamed:BlackBackBtnImg] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissCurrentVController) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    

}

- (void) setWhiteLeftBarItem{
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  NAVBARHEIGHT*Proportion,
                                                                  NAVBARHEIGHT*Proportion)];
    [button setImage:[UIImage imageNamed:WhiteBackBtnImg] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissCurrentVController) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];

}

- (void)setCancelBarItem{

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  NAVBARHEIGHT*Proportion,
                                                                  NAVBARHEIGHT*Proportion)];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.titleLabel.font = KSystemFontSize12;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissCurrentVController) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
}

- (void)setRightBarItem{
        
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - NAVBARHEIGHT*Proportion,
                                                                  0,
                                                                  NAVBARHEIGHT*Proportion,
                                                                  NAVBARHEIGHT*Proportion)];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    button.titleLabel.font = KSystemFontSize12;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(determineChoose) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];

}

- (void) setCertainBarItem{

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - NAVBARHEIGHT*Proportion,
                                                                  0,
                                                                  NAVBARHEIGHT*Proportion,
                                                                  NAVBARHEIGHT*Proportion)];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.titleLabel.font = KSystemFontSize12;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(determineChoose) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    

}

- (void) setShareBarItem{

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - NAVBARHEIGHT*Proportion,
                                                                  0,
                                                                  NAVBARHEIGHT*Proportion,
                                                                  NAVBARHEIGHT*Proportion)];

    [button setImage:[UIImage imageNamed:KWhiteShareImg] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(determineChoose) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    

}
#pragma mark - dismissCurrentVC

- (void) dismissCurrentVController{

    if ([self.navigationBarDelegate respondsToSelector:@selector(didSelectedLeftBarItem)]) {
        [self.navigationBarDelegate didSelectedLeftBarItem];
    }
}

#pragma mark - determineChoose

- (void) determineChoose{

    if ([self.navigationBarDelegate respondsToSelector:@selector(didSelectedRightBarItem)]) {
        [self.navigationBarDelegate didSelectedRightBarItem];
    }

}
@end
