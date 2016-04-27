//
//  CMLCommentListTVCell.h
//  camelliae1.0.1
//
//  Created by 张越 on 16/4/26.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLCommentListTVCell : UITableViewCell

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,copy) NSString *publishTime;

@property (nonatomic,copy) NSString *commentContent;

- (CGFloat) refreshTableViewCell;
@end
