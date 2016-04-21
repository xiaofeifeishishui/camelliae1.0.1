//
//  CMLRefreshFooter.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/28.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^BeginRefreshingBlock)(void);

@interface CMLRefreshFooter : NSObject

@property(nonatomic,strong) UIScrollView *scrollView;

/**正在刷新的回调*/
@property(nonatomic,copy) BeginRefreshingBlock beginRefreshingBlock;

/**footer的初始化*/
-(void)footer;

/**开始刷新操作  如果正在刷新则不做操作*/
-(void)beginRefreshing;

/**关闭刷新操作  请加在UIScrollView数据刷新后，如[tableView reloadData]*/
-(void)endRefreshing;

@end