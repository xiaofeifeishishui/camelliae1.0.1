//
//  CMLNavigationBar.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/25.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLNavigationBarItem.h"


@protocol NavigationBarDelegate <NSObject>

@optional

- (void) didSelectedLeftBarItem;
- (void) didSelectedRightBarItem;


@end

@interface CMLNavigationBar : UIView

/**标题内容*/
@property (nonatomic,copy) NSString *titleContent;
/**标题颜色*/
@property (nonatomic,strong) UIColor *titleColor;

@property (nonatomic,strong) id<NavigationBarDelegate>navigationBarDelegate;

- (void) setLeftBarItem;

- (void) setWhiteLeftBarItem;

- (void)setCancelBarItem;

- (void)setRightBarItem;

- (void) setShareBarItem;

- (void) setCertainBarItem;
@end
