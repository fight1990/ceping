//
//  NSDate+Extention.m
//  CourseReservation
//
//  Created by Mac on 17/6/9.
//  Copyright © 2017年 Zz. All rights reserved.
//

#import "NSDate+Extention.h"

@implementation NSDate (Extention)

-(NSString *)dateToMothDayStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}

-(NSString *)dateToYearMothDayStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}

-(NSString *)dateToYear{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}

+(NSDate *)JSDateFromString:(NSString*)string{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    //    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    //    [inputFormatter setTimeZone:timeZone];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate* inputDate = [inputFormatter dateFromString:string];
    //
    //    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //    NSInteger interval = [zone secondsFromGMTForDate: inputDate];
    //    NSDate *localeDate = [inputDate  dateByAddingTimeInterval: interval];
    
    return inputDate;
}


@end
