//
//  CMLSysNoticeTVCell.h
//  CAMELLIAE
//
//  Created by 张越 on 16/4/10.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLSysNoticeTVCell : UITableViewCell

@property (nonatomic,copy) NSString *currentTitle;

@property (nonatomic,copy) NSString *currentText;


- (CGFloat) getRowHeight;

@end
