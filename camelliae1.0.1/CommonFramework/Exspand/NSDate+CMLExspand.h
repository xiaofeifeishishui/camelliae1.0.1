//
//  NSDate+CMLExspand.h
//  CAMELLIAE
//
//  Created by 张越 on 16/3/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CMLExspand)

/**输入格式为yyyy-MM-dd HH:mm:s 输出日期*/
+ (NSDate *) getDateDependONFormatterFromString:(NSString *) string;

/**输入格式为yyyy-MM-dd 输出日期*/
+ (NSDate *)getDateDependOnFormatterCFromString:(NSString *) string;

+ (NSString *)getStringDependOnFormatterCFromDate:(NSDate *) date;

/**输入日期 输出格式yyyy-MM-dd HH:mm:s*/
+ (NSString*) getStringDependOnFormatterAFromDate:(NSDate*) date;

/**输入格式为yyyy:MM:dd HH:mm:s 输出日期*/
+ (NSDate*) getDateDependOnFormatterBFromString:(NSString *)string;

/**输入日期 输出格式yyyy:MM:dd HH:mm:s*/
+ (NSString*) getStringDependOnFormatterBFromDate:(NSDate*) date;

/**输入日期格式yyyy-MM-dd HH:mm:s输出日期格式yyyy:MM:dd HH:mm:s*/
+ (NSString*) getFormatterStringBFromFormatterStringA:(NSString*)string;

/**输入日期格式yyyy:MM:dd HH:mm:s输出日期格式yyyy-MM-dd HH:mm:s*/
+ (NSString*) getFormatterStringAFromFormatterStringB:(NSString*)string;

/**输入日期格式yyyy-MM-dd HH:mm:s输出日期格式yyyy-MM-dd*/
+ (NSString*) getFormatterStringAFromFormatterStringC:(NSString*)string;

/**获得星期数*/
+ (NSString*) getDayOfTheWeek;

/**获得两个日期相隔的天数*/
+ (NSInteger) getTimeIntervalBetweenDateA:(NSDate*) dateA andDateB:(NSDate*)dateB;

/**获得当前月份的第一天*/
+ (NSDate*) getFirstDayOfPresentMonth;

/**获得当前月份的最后一天*/
+ (NSDate*) getLastDayOfPresentMonth;

//多少天之后，返回MM-dd格式
+ (NSString *) getStringFromDate:(NSDate *)date afterDays:(NSInteger)dayNum;


@end
