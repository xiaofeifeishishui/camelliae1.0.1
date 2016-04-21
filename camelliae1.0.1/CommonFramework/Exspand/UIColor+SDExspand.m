//
//  UIColor+SDExspand.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/23.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "UIColor+SDExspand.h"

@implementation UIColor (SDExspand)

+ (UIColor *)colorWithHex:(NSString *)color{
    
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6){
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"]){
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]){
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6){
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:1.0];
}

+ (UIColor *)CMLLineGrayColor{
    return [self colorWithHex:@"#C6C6C6"];
}

/**服务板块颜色设置*/
+ (UIColor *)CMLServeGrayColor{
    return [self colorWithHex:@"bebebe"];
}
/**会员灰色*/
+ (UIColor *)CMLVIPGrayColor{
   return [self colorWithHex:@"f8f8f8"];
}
/**标头黄色*/
+ (UIColor *)CMLTitleYellowColor{
    return [self colorWithHex:@"efc28a"];
}
/**找回密码字体颜色*/
+ (UIColor *)CMLInputTextGrayColor{
    return [self colorWithHex:@"#979797"];
}
+ (UIColor *)CMLTabBarItemGrayColor{
    return [self colorWithHex:@"#878787"];
}
@end
