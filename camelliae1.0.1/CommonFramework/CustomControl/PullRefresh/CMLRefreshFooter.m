//
//  CMLRefreshFooter.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/28.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "CMLRefreshFooter.h"
#import "CommonFont.h"

@interface CMLRefreshFooter (){
    UILabel *endLabel;
}
/**滑动的高度*/
@property (assign,nonatomic) int scrollFrameHeight;
/**底部视图高度*/
@property (assign,nonatomic) CGFloat footerHeight;
/**tableView的宽度*/
@property (assign,nonatomic) CGFloat scrollWidth;
/**是否正在刷新*/
@property (assign,nonatomic) BOOL isRefresh;
/**内容高度*/
@property (assign,nonatomic) int contentHeight;
/**是否添加footer*/
@property (assign,nonatomic) BOOL isAdd;
/**底部视图*/
@property (strong,nonatomic) UIView *footerView;
/**加载圈*/
@property (strong,nonatomic) UIActivityIndicatorView *activityView;
/**第一次的高度*/
@property (assign,nonatomic) int firstHeight;
/**每次的高度*/
@property (assign,nonatomic) int tempHeight;
@end

@implementation CMLRefreshFooter

- (void)footer{
    
    self.scrollWidth=self.scrollView.frame.size.width;
    self.footerHeight=35;
    self.scrollFrameHeight=self.scrollView.frame.size.height;
    self.isAdd=NO;
    self.isRefresh=NO;
    self.firstHeight = 0;
    
    
    self.footerView=[[UIView alloc] init];
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    endLabel = [[UILabel alloc] init];
    endLabel.backgroundColor=[UIColor whiteColor];
    endLabel.textAlignment=NSTextAlignmentCenter;
//    endLabel.text=@"没有更多了";
    endLabel.textColor=[UIColor grayColor];
    endLabel.font=KSystemFontSize12;
    [self.footerView addSubview:endLabel];
    
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![@"contentOffset" isEqualToString:keyPath]) return;
    self.contentHeight=self.scrollView.contentSize.height;
    
    
    if (!self.isAdd) {
        self.isAdd=YES;
        
        self.footerView.frame=CGRectMake(0,
                                         self.contentHeight,
                                         self.scrollWidth,
                                         self.footerHeight);
        [_scrollView addSubview:self.footerView];
        self.activityView.frame=CGRectMake((self.scrollWidth-self.footerHeight)/2,
                                           0,
                                           self.footerHeight,
                                           self.footerHeight);
        [self.footerView addSubview:self.activityView];
    }
    
    self.footerView.frame=CGRectMake(0,
                                     self.contentHeight,
                                     self.scrollWidth,
                                     self.footerHeight);
    self.activityView.frame=CGRectMake((self.scrollWidth-self.footerHeight)/2,
                                       0,
                                       self.footerHeight,
                                       self.footerHeight);
    int currentPostion = (int)self.scrollView.contentOffset.y;
    
    if (self.firstHeight == 0) {
        self.firstHeight = (int)self.contentHeight;
    }
    
    self.tempHeight = (int)self.contentHeight;
    
    
    // 进入刷新状态
    if ((currentPostion>(self.contentHeight-self.scrollFrameHeight))&&(self.contentHeight>self.scrollFrameHeight)) {
        
        [self beginRefreshing];
    }
}

/**开始刷新操作  如果正在刷新则不做操作*/
- (void)beginRefreshing{
    if (!self.isRefresh) {
        endLabel.hidden = YES;
        self.isRefresh=YES;
        self.activityView.hidden = NO;
        [self.activityView startAnimating];
        self.footerView.hidden = NO;
        
        //        设置刷新状态_scrollView的位置
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.contentInset=UIEdgeInsetsMake(0, 0, self.footerHeight, 0);
        }];
        
        //        block回调
        self.beginRefreshingBlock();
    }
}

/**关闭刷新操作  请加在UIScrollView数据刷新后，如[tableView reloadData]*/
- (void)endRefreshing{
    
    self.isRefresh=NO;
    [self.activityView stopAnimating];
    self.activityView.hidden = YES;
    endLabel.hidden = NO;
    endLabel.frame =CGRectMake(0, 0, self.scrollView.frame.size.width, self.footerHeight);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            _scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
            self.footerView.frame=CGRectMake(0,
                                             self.contentHeight,
                                             [[UIScreen mainScreen] bounds].size.width,
                                             self.footerHeight);
            
        }];
    });
}

- (void)dealloc{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
