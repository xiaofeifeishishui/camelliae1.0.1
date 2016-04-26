//
//  NSDate+CMLExspand.m
//  CAMELLIAE
//
//  Created by 张越 on 16/3/17.
//  Copyright © 2016年 张越. All rights reserved.
//

#import "NSDate+CMLExspand.h"

@implementation NSDate (CMLExspand)

+ (NSDate *) getDateDependONFormatterFromString:(NSString *) string{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:s"];
    
    NSDate *date = [formatter dateFromString:string];
    
    return date;
}

/**输入格式为yyyy-MM-dd 输出日期*/
+ (NSDate *)getDateDependOnFormatterCFromString:(NSString *) string{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [formatter dateFromString:string];
    
    return date;

}

+ (NSString *)getStringDependOnFormatterCFromDate:(NSDate *) date{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *string=[formatter stringFromDate:date];
    
    return string;


}

+ (NSString*) getStringDependOnFormatterAFromDate:(NSDate*) date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *string=[formatter stringFromDate:date];
    
    return string;
}

+ (NSDate*) getDateDependOnFormatterBFromString:(NSString *)string{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy:MM:dd HH:mm:s"];
    
    NSDate *date=[formatter dateFromString:string];
    
    return date;
}

+ (NSString*) getStringDependOnFormatterBFromDate:(NSDate*) date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy:MM:dd HH:mm:s"];
    
    NSString *string=[formatter stringFromDate:date];
    
    return string;
    
}

+ (NSString*) getFormatterStringBFromFormatterStringA:(NSString*)string{
    
    NSDateFormatter *formatterA = [[NSDateFormatter alloc] init];
    
    [formatterA setDateFormat:@"yyyy-MM-dd HH:mm:s"];
    
    NSDate *date = [formatterA dateFromString:string];
    
    NSDateFormatter *formatterB = [[NSDateFormatter alloc] init];
    
    [formatterB setDateFormat:@"yyyy:MM:dd HH:mm:s"];
    
    NSString *newString = [formatterB stringFromDate:date];
    
    return newString;
}

+ (NSString*) getFormatterStringAFromFormatterStringB:(NSString*)string{
    
    NSDateFormatter *formatterB = [[NSDateFormatter alloc] init];
    
    [formatterB setDateFormat:@"yyyy:MM:dd HH:mm:s"];
    
    NSDate *date = [formatterB dateFromString:string];
    
    NSDateFormatter *formatterA = [[NSDateFormatter alloc] init];
    
    [formatterA setDateFormat:@"yyyy-MM-dd HH:mm:s"];
    
    NSString *newString = [formatterA stringFromDate:date];
    
    return newString;
}

+ (NSString*) getFormatterStringAFromFormatterStringC:(NSString*)string{
    
    NSDateFormatter *formatterA = [[NSDateFormatter alloc] init];
    
    [formatterA setDateFormat:@"yyyy-MM-dd HH:mm:s"];
    
    NSDate *date = [formatterA dateFromString:string];
    
    NSDateFormatter *formatterB = [[NSDateFormatter alloc] init];
    
    [formatterB setDateFormat:@"yyyy-MM-dd"];
    
    NSString *newString = [formatterB stringFromDate:date];
    
    return newString;
}

//多少天之后，返回MM-dd格式
+ (NSString *) getStringFromDate:(NSDate *)date afterDays:(NSInteger)dayNum
{
    
    NSDate *dateTemp = [date dateByAddingTimeInterval:dayNum*24*3600];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"MM-dd"];
    
    NSString *newString = [formatter stringFromDate:dateTemp];
    
    return newString;
}

+ (NSString*) getDayOfTheWeek{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy年MM月dd日#EEEE"];
    
    NSDate * date = [NSDate date];
    
    NSString *firString=[formatter stringFromDate:date];
    
    NSMutableString * secstring = [NSMutableString stringWithString:firString];
    
    NSArray* array=[secstring componentsSeparatedByString:@"#"];
    
    NSString *weak = [array lastObject];
    
    if ([weak isEqualToString:@"Monday"]) {
        
        return @"星期一";
        
    }else if ([weak isEqualToString:@"Tuesday"]){
        
        return @"星期二";
        
    }else if ([weak isEqualToString:@"Wednesday"]){
        
        return @"星期三";
        
    }else if ([weak isEqualToString:@"Thursday"]){
        
        return @"星期四";
        
    }else if ([weak isEqualToString:@"Friday"]){
        
        return @"星期五";
        
    }else if ([weak isEqualToString:@"Saturday"]){
        
        return @"星期六";
        
    }else if ([weak isEqualToString:@"Sunday"]){
        
        return @"星期日";
        
    }
    return @"";
    
}

+ (NSInteger) getTimeIntervalBetweenDateA:(NSDate*) dateA andDateB:(NSDate*)dateB{
    
    NSTimeInterval  time = [dateA timeIntervalSinceDate:dateB];
    
    NSInteger m= fabs(time);
    
    NSInteger d =m/(1*24*60*60);
    
    return d;
}

+ (NSDate*) getFirstDayOfPresentMonth{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy年MM"];
    
    NSDate * date = [NSDate date];
    
    NSString * str = [formatter stringFromDate:date];
    
    NSArray * array = [str componentsSeparatedByString:@"年"];
    
    NSString *targetDay=[NSString stringWithFormat:@"%@:%@:01",[array firstObject],[array lastObject]];
    
    NSDateFormatter * targetFormatter =[[NSDateFormatter alloc] init];
    
    [targetFormatter setDateFormat:@"yyyy:MM:dd"];
    
    NSDate *targetDate = [targetFormatter dateFromString:targetDay];
    
    return targetDate;
}

+ (NSDate*) getLastDayOfPresentMonth{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy年MM"];
    
    NSDate * date = [NSDate date];
    
    NSString * str = [formatter stringFromDate:date];
    
    NSArray * array = [str componentsSeparatedByString:@"年"];
    
    NSInteger year = [[array firstObject] integerValue];
    
    NSInteger month = [[array lastObject] integerValue];
    
    
    if ((month==/* DISABLES CODE */ (1))&&(month==3)&&(month==5)&&(month==7)&&(month==8)&&(month==10)&&(month==12)) {
        NSString *targetDay=[NSString stringWithFormat:@"%@:%@:31",[array firstObject],[array lastObject]];
        
        NSDateFormatter * targetFormatter =[[NSDateFormatter alloc] init];
        
        [targetFormatter setDateFormat:@"yyyy:MM:dd"];
        
        NSDate *targetDate = [targetFormatter dateFromString:targetDay];
        
        return targetDate;
        
    }else if (month==2){
        
        if ((year%4==0)&&(year%100==0||year%400==0)) {
            NSString *targetDay=[NSString stringWithFormat:@"%@:%@:29",[array firstObject],[array lastObject]];
            
            NSDateFormatter * targetFormatter =[[NSDateFormatter alloc] init];
            
            [targetFormatter setDateFormat:@"yyyy:MM:dd"];
            
            NSDate *targetDate = [targetFormatter dateFromString:targetDay];
            
            return targetDate;
        }else{
            NSString *targetDay=[NSString stringWithFormat:@"%@:%@:28",[array firstObject],[array lastObject]];
            
            NSDateFormatter * targetFormatter =[[NSDateFormatter alloc] init];
            
            [targetFormatter setDateFormat:@"yyyy:MM:dd"];
            
            NSDate *targetDate = [targetFormatter dateFromString:targetDay];
            
            return targetDate;
            
            
        }
    }else{
        
        NSString *targetDay=[NSString stringWithFormat:@"%@:%@:30",[array firstObject],[array lastObject]];
        
        NSDateFormatter * targetFormatter =[[NSDateFormatter alloc] init];
        
        [targetFormatter setDateFormat:@"yyyy:MM:dd"];
        
        NSDate *targetDate = [targetFormatter dateFromString:targetDay];
        
        return targetDate;
    }
    return nil;
}
@end
