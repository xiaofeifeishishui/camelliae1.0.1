//
//  CMLInfomationTVCell.h
//  camelliae1.0.1
//
//  Created by 张越 on 16/4/21.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLInfomationTVCell : UITableViewCell

@property (nonatomic,copy) NSString *imageUrl;

- (void) refreshTableViewCell;

- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view;
@end
