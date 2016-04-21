//
//  UIScrollView+RefreshHeader.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/28.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "UIScrollView+RefreshHeader.h"

#import <objc/runtime.h>

@implementation UIScrollView (PullToRefreshCoreText)


#pragma mark - Lifecycle

- (void)addPullToRefreshWithPullText:(NSString *)pullText
                       pullTextColor:(UIColor *)pullTextColor
                        pullTextFont:(UIFont *)pullTextFont
                      refreshingText:(NSString *)refreshingText
                 refreshingTextColor:(UIColor *)refreshingTextColor
                  refreshingTextFont:(UIFont *)refreshingTextFont
                              action:(pullToRefreshAction)action {
    
    if (self.pullToRefreshView) return;
    
    float ptrH = [self labelHeightForString:pullText
                                 labelWidth:self.bounds.size.width
                                    andFont:pullTextFont];
    CGRect ptrRect = CGRectMake(0, -ptrH, self.bounds.size.width, ptrH);
    
    self.pullToRefreshView = [[PullToRefreshCoreTextView alloc] initWithFrame:ptrRect
                                                                     pullText:pullText
                                                                pullTextColor:pullTextColor
                                                                 pullTextFont:pullTextFont
                                                               refreshingText:refreshingText
                                                          refreshingTextColor:refreshingTextColor
                                                           refreshingTextFont:refreshingTextFont
                                                                       action:action];
    [self.pullToRefreshView setScrollView:self];
    
    [self addSubview:self.pullToRefreshView];
}


#pragma mark - Loading

- (void)finishLoading {
    [self.pullToRefreshView endLoading];
}


#pragma mark - Utils

- (CGFloat)labelHeightForString:(NSString*)string labelWidth:(float)width andFont:(UIFont*)font {
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return rect.size.height;
}


#pragma mark - Properties

- (void)setPullToRefreshView:(PullToRefreshCoreTextView *)pullToRefreshView {
    objc_setAssociatedObject(self, @selector(pullToRefreshView), pullToRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (PullToRefreshCoreTextView *)pullToRefreshView {
    return objc_getAssociatedObject(self, @selector(pullToRefreshView));
}

@end

