//
//  NSString+CMLExspand.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "NSString+CMLExspand.h"
#import "CMLRSAModule.h"
#import "NetConfig.h"
@implementation NSString (CMLExspand)

/**获取字符串font下的CGsize*/
- (CGSize) sizeWithFontCompatible:(UIFont *) font{
    
    if([self respondsToSelector:@selector(sizeWithAttributes:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        CGSize stringSize = [self sizeWithAttributes:dictionaryAttributes];
        return CGSizeMake(ceil(stringSize.width), ceil(stringSize.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self sizeWithFont:font];
#pragma clang diagnostic pop
    }
}

/**rsa加密*/
+ (NSString *)getEncryptStringfrom:(NSArray*)objects;{

    NSMutableString *string = [NSMutableString string];
    
    for (int i = 0; i<objects.count; i++) {
        [string appendFormat:@"%@",objects[i]];
    }
    NSString *targetString = [CMLRSAModule encryptString:string publicKey:PUBKEY];
    return targetString;

}

+ (NSString *) getCityNameWithCityID:(NSNumber *) cityID{

    NSString *cityNAme;
    switch ([cityID intValue]) {
        case 1:
            cityNAme = @"北京";
            break;
        case 2:
            cityNAme = @"天津";
            break;
        case 3:
            cityNAme = @"河北";
            break;
        case 4:
            cityNAme = @"山西";
            break;
        case 5:
            cityNAme = @"内蒙古";
            break;
        case 6:
            cityNAme = @"辽宁";
            break;
        case 7:
            cityNAme = @"吉林";
            break;
        case 8:
            cityNAme = @"黑龙江";
            break;
        case 9:
            cityNAme = @"上海";
            break;
        case 10:
            cityNAme = @"江苏";
            break;
        case 11:
            cityNAme = @"浙江";
            break;
        case 12:
            cityNAme = @"安徽";
            break;
        case 13:
            cityNAme = @"福建";
            break;
        case 14:
            cityNAme = @"江西";
            break;
        case 15:
            cityNAme = @"山东";
            break;
        case 16:
            cityNAme = @"河南";
            break;
        case 17:
            cityNAme = @"湖北";
            break;
        case 18:
            cityNAme = @"湖南";
            break;
        case 19:
            cityNAme = @"广东";
            break;
        case 20:
            cityNAme = @"广西";
            break;
        case 21:
            cityNAme = @"海南";
            break;
        case 22:
            cityNAme = @"重庆";
            break;
            
        case 23:
            cityNAme = @"四川";
            break;
        case 24:
            cityNAme = @"贵州";
            break;
        case 25:
            cityNAme = @"云南";
            break;
        case 26:
            cityNAme = @"西藏";
            break;
        case 27:
            cityNAme = @"陕西";
            break;
        case 28:
            cityNAme = @"甘肃";
            break;
        case 29:
            cityNAme = @"青海";
            break;
        case 30:
            cityNAme = @"宁夏";
            break;
        case 31:
            cityNAme = @"新疆";
            break;
        case 32:
            cityNAme = @"台湾";
            break;
        case 33:
            cityNAme = @"香港";
            break;
        case 34:
            cityNAme = @"澳门";
            break;
            
        default:
            break;
    }

    return cityNAme;
}
@end
