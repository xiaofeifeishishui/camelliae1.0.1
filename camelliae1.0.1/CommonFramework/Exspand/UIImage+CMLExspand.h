//
//  UIImage+CMLExspand.h
//  camelliae1.0
//
//  Created by 张越 on 16/4/14.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CMLExspand)

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

+ (UIImage *)scaleToRect:(UIImage *)img;

+ (UIImage*) scaleToSizeOfHeight280:(UIImage *) img;
@end
