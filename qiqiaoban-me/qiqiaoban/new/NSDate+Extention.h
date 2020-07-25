//
//  NSDate+Extention.h
//  CourseReservation
//
//  Created by Mac on 17/6/9.
//  Copyright © 2017年 Zz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extention)
//值得年份
-(NSString *)dateToYear;

//转变成 03/15 这种格式。
-(NSString *)dateToMothDayStr;


//转变成 1888-05-22 这种格式。
-(NSString *)dateToYearMothDayStr;


+(NSDate *)JSDateFromString:(NSString*)string;
@end
