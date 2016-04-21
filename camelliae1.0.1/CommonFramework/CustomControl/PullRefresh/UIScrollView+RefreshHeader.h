//
//  UIScrollView+RefreshHeader.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/28.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshCoreTextView.h"

#define DefaultTextColor    [UIColor blackColor]
#define DefaultTextFont     [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30]

@interface UIScrollView (PullToRefreshCoreText)

@property (nonatomic, strong) PullToRefreshCoreTextView *pullToRefreshView;


- (void)addPullToRefreshWithPullText:(NSString *)pullText
                       pullTextColor:(UIColor *)pullTextColor
                        pullTextFont:(UIFont *)pullTextFont
                      refreshingText:(NSString *)refreshingText
                 refreshingTextColor:(UIColor *)refreshingTextColor
                  refreshingTextFont:(UIFont *)refreshingTextFont
                              action:(pullToRefreshAction)action;


- (void)finishLoading;


@end
