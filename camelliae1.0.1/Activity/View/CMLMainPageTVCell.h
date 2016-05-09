//
//  CMLMainPageTVCell.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/28.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLMainPageTVCell : UITableViewCell

@property (nonatomic,copy) NSString *imgUrl;

@property (nonatomic,strong) UIImageView *VIPView;

@property (nonatomic,strong) UIButton *button;

@property (nonatomic,strong) UIImageView *backgroundImg;

@property (nonatomic,assign) NSInteger memberLevel;

@property (nonatomic,copy) NSString *shortTitle;

@property (nonatomic,copy) NSString *imageID;

- (void) reloadTableViewCell;

- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view;

@end
