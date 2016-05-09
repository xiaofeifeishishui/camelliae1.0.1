//
//  CMLServeTVCell.h
//  camelliae1.0.1
//
//  Created by 张越 on 16/4/20.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLServeTVCell : UITableViewCell

@property (nonatomic,copy) NSString *serveName;

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,copy) NSString *imageID;

- (void) refreshTableViewCell;

- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view;
@end
