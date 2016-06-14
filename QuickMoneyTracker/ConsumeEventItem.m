//
//  ConsumeEventItem.m
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/10.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import "ConsumeEventItem.h"
#import "SimpleTime.h"

#define kWhenKey        @"kWhenKey"
#define kWhatKey        @"kWhatKey"
#define kHowMuchKey     @"khowMuchKey"
#define kKingCostKey    @"kKingCostKey"
#define kQueneCostKey   @"kQueneCostKey"

@implementation ConsumeEventItem

- (instancetype)initWithDate:(NSDate *)date what:(NSString *)what howMuch:(double)howMuch kingCost:(double)kingCost queueCost:(double)queueCost
{
    self = [super init];
    if (self) {
        _when = date;
        _what = what;
        _howMuch = howMuch;
        _kingCost = kingCost;
        _queneCost = queueCost;
    }
    return self;
}

-(NSUInteger)hash
{
    return 0;
}

-(BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[ConsumeEventItem class]])
          return NO;
    
    ConsumeEventItem *tmp = (ConsumeEventItem *)object;
    return ([_what isEqualToString:tmp.what]) && (_howMuch == tmp.howMuch) && (_kingCost == tmp.kingCost) && (_queneCost == tmp.queneCost);
}

#pragma mark - Coding

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _when = [aDecoder decodeObjectForKey:kWhenKey];
        _what = [aDecoder decodeObjectForKey:kWhatKey];
        _howMuch = [aDecoder decodeDoubleForKey:kHowMuchKey];
        _kingCost = [aDecoder decodeDoubleForKey:kKingCostKey];
        _queneCost = [aDecoder decodeDoubleForKey:kQueneCostKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_when forKey:kWhenKey];
    [aCoder encodeObject:_what forKey:kWhatKey];
    [aCoder encodeDouble:_howMuch forKey:kHowMuchKey];
    [aCoder encodeDouble:_kingCost forKey:kKingCostKey];
    [aCoder encodeDouble:_queneCost forKey:kQueneCostKey];
}

#pragma mark - Copying

- (instancetype)copyWithZone:(NSZone *)zone
{
    ConsumeEventItem *copy = [[[self class] allocWithZone:zone] init];
    [copy setWhen:[_when copyWithZone:zone]];
    [copy setWhat:[_what copyWithZone:zone]];
    [copy setHowMuch:_howMuch];
    [copy setKingCost:_kingCost];
    [copy setQueneCost:_queneCost];
    
    return copy;
}

@end
