//
//  CMLBaseVC.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLNavigationBar.h"

typedef enum{

    LeftMovementDirection,
    rightMovementDirection

} MovementDirection;

@interface CMLBaseVC : UIViewController<NavigationBarDelegate>

/**自定义导航头*/
@property (nonatomic,strong) CMLNavigationBar *navBar;

/**底层*/
@property (nonatomic,strong) UIView *contentView;


/**移动content*/
- (void) moveContentViewWith:(MovementDirection) direction;
- (void) reductionContentPlace;


/**没有数据*/
- (void) showNotData;
- (void) hiddenNotData;

/**loading*/
- (void)startLoading;
- (void)stopLoading;

- (void) showAlterViewWithText:(NSString *) text;

@end
