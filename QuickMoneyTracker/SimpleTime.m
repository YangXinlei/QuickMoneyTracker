//
//  SimpleTime.m
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/12.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import "SimpleTime.h"

#define kNearTimeInterval       30          //两个时间点相距多少视为接近

@implementation SimpleTime

-(instancetype)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self)
    {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponents = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
        
        _hour = dateComponents.hour;
        _minute = dateComponents.minute;
    }
    return self;
}

-(BOOL)isNearToDate:(NSDate *)date
{
    SimpleTime *givenTime = [[SimpleTime alloc] initWithDate:date];
    
    if (labs(givenTime.hour - _hour) > 1)
        return NO;
    
    if (givenTime.hour == _hour)
    {
        return labs(givenTime.minute - _minute) <= kNearTimeInterval;
    }
    else
    {
        assert((labs(givenTime.hour - _hour) == 1));
        
        NSInteger minuteForSmaller = (givenTime.hour > _hour) ? _minute : givenTime.minute;
        NSInteger minuteForBigger = (givenTime.hour < _hour) ? _minute : givenTime.minute;
        
        return ((60 - minuteForSmaller) + minuteForBigger <= kNearTimeInterval);
    }
    return NO;
}

@end
