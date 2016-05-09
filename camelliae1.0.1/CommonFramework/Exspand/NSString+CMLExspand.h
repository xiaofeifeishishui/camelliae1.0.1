//
//  NSString+CMLExspand.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (CMLExspand)

- (NSString *)md5;
/**获取字符串font下的CGsize*/
- (CGSize) sizeWithFontCompatible:(UIFont *) font;

/**rsa加密(顺序填写)*/
+ (NSString *)getEncryptStringfrom:(NSArray*)objects;

+ (NSString *) getCityNameWithCityID:(NSNumber *) cityID;

+ (NSString *)getImagePlistPath;
@end
