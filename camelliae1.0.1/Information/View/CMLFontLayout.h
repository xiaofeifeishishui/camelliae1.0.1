//
//  CMLFontLayout.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/30.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLFontLayout : UIView

- (CGFloat) setFontLayoutWith:(NSString *) text;

- (CGFloat) setFontLayoutWith:(NSString *) text dependFont:(UIFont *) font;
@end
