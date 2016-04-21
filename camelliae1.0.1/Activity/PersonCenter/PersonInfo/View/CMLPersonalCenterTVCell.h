//
//  CMLPersonalCenterTVCell.h
//  CAMELLIAE
//
//  Created by 张越 on 16/4/2.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMLPersonInfoDelegate <NSObject>

- (void) selectedTextField:(UITextField *)textField;

- (void) alterTextOfTextField:(UITextField *) textField;

@end

@interface CMLPersonalCenterTVCell : UITableViewCell

@property (nonatomic,copy) NSString *attributeContent;

@property (nonatomic,assign) BOOL isTextField;

@property (nonatomic,assign) BOOL hiddenIndicate;

@property (nonatomic,strong) id <CMLPersonInfoDelegate> delegate;

- (void) refreshCell;
@end
