//
//  SimpleDate.m
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/13.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import "SimpleDate.h"

@implementation SimpleDate

- (instancetype)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self)
    {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:date];
        
        _year = dateComponents.year;
        _month = dateComponents.month;
    }
    return self;
}

- (instancetype)initWithYear:(NSInteger)year AndMonth:(NSInteger)month
{
    self = [super init];
    if (self)
    {
        _year = year;
        _month = month;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[self class]])
        return NO;
    SimpleDate *sdObj = (SimpleDate *)object;
    return (_year == sdObj.year) && (_month == sdObj.month);
}

@end
