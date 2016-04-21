//
//  CMLAppointmentTVCell.h
//  CAMELLIAE
//
//  Created by 张越 on 16/4/8.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLAppointmentTVCell : UITableViewCell

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,assign) BOOL isShowExpire;

@property (nonatomic,strong) NSNumber *showExpire;

@property (nonatomic,strong) NSNumber *showDelegate;

- (void) refreshTableViewCell;

@end
