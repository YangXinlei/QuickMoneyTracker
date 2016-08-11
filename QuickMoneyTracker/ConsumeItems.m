//
//  ConsumeItems.m
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/12.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import "ConsumeItems.h"
#import "SimpleTime.h"

#define kConsumeItemArrayKey        @"kConsumeItemArrayKey"

@implementation ConsumeItems

+ (instancetype)sharedConsumeItems
{
    static ConsumeItems *consumeItems = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        consumeItems = [[ConsumeItems alloc] init];
    });
    return consumeItems;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _consumeItemArray = [[NSMutableArray alloc] initWithCapacity:42];
    }
    return self;
}

- (void) deleteItemAtIndex:(NSInteger)index
{
    if (index >= 0 && index < [_consumeItemArray count])
        [_consumeItemArray removeObjectAtIndex:index];
}

- (void) addItem:(ConsumeEventItem *)item
{
    [_consumeItemArray addObject:item];
}

- (ConsumeEventItem *) itemAtIndex:(NSInteger)index
{
    return [_consumeItemArray objectAtIndex:index];
}

- (NSInteger)itemCount
{
    return [_consumeItemArray count];
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"ConsumeItems : %@", [_consumeItemArray description]];
}
/**
 *  统计
 *
 *  @return 统计结果
 */
-(ConsumeEventItem *)addUp
{
    double totalCost = 0, tcForKing = 0, tcForQuene = 0;
    NSMutableDictionary *whatMap = [[NSMutableDictionary alloc] initWithCapacity:[_consumeItemArray count]];
    for (ConsumeEventItem *item in _consumeItemArray)
    {
        totalCost += item.howMuch;
        tcForKing += item.kingCost;
        tcForQuene += item.queneCost;
        NSNumber *countNum;
        double whatCount;
        if (nil != (countNum = [whatMap objectForKey:item.what]))
        {
            whatCount = [countNum doubleValue] + item.howMuch;
        }
        else
        {
            whatCount = item.howMuch;
        }
        [whatMap setObject:[NSNumber numberWithDouble:whatCount] forKey:item.what];
    }
    
    __block double maxCount = 0.0;
    __block NSString *maxWhat = @"";
    [whatMap enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *value, BOOL *stop) {
       if ([value intValue] > maxCount)
       {
           maxCount = [value doubleValue];
           maxWhat = key;
       }
    }];
    
    return [[ConsumeEventItem alloc] initWithDate:[NSDate distantFuture] what:[NSString stringWithFormat:@"%@(%.2f).", maxWhat, maxCount] howMuch:totalCost kingCost:tcForKing queueCost:tcForQuene];
}

/**
 *  根据创建时间计算推荐数据并返回给新创建的AddItemCell用于初始化
 *  推荐数据是通过现有数据中时间点相近（仅考虑创建时间点在某天中的时间，不考虑日期）的所有数据中出现次数最多的数据
 *  例如：我每天中午12：30左右会有一笔35元的吃饭支出，则当我在某天的中午12：23新建一个事项时，自动为我推荐为该笔支出
 *  @return 计算出的推荐数据
 */
- (ConsumeEventItem *)suggestNewItem
{
    
    return [self quickSuggestNewItem];

}

- (ConsumeEventItem *)quickSuggestNewItem
{
    SimpleTime *curTime = [[SimpleTime alloc] initWithDate:[NSDate date]];
    
    NSMutableDictionary *countMap = [[NSMutableDictionary alloc] initWithCapacity:[_consumeItemArray count]];
    
    for (ConsumeEventItem *item in _consumeItemArray)
    {
        NSNumber *curRate;
        NSNumber *suggestRate;  //推荐程度 = sum (每次时间相近程度)
        
        double nearRate = [curTime nearRateOf:item.when]; //时间相近程度
        
        if ( nil != (curRate = [countMap objectForKey:item]) )
        {
            suggestRate = [NSNumber numberWithDouble:[curRate doubleValue] + nearRate];
        }
        else
        {
            suggestRate = [NSNumber numberWithDouble:nearRate];
        }
        [countMap setObject:suggestRate forKey:item];
    }
    
    __block ConsumeEventItem *maxKey = nil;
    __block double maxRate = 0;
    
    [countMap enumerateKeysAndObjectsUsingBlock:^(ConsumeEventItem *key, NSNumber *value, BOOL *stop){
        if ( [value doubleValue] >= maxRate)
        {
            maxRate = [value doubleValue];
            maxKey = key;
        }
    }];
    
    NSLog(@"%@", countMap);
    
    return maxKey ? maxKey : [[ConsumeEventItem alloc] initWithDate:[NSDate date] what:@"其他" howMuch:0 kingCost:0 queueCost:0];
}

-(ColorType)suggestColor:(ConsumeEventItem *)item
{
    static const double maxCost = 1000;
    float rate = (item.howMuch / maxCost);
    if (rate < 0.2) rate = 0.2;
    if (rate > 1.0) rate = 1.0;
    
    ColorType color;
    color.red = rate;
    color.green = 1.0 - rate;
    color.blue = 0.8 - rate;
    color.alpha = 0.6;

    return color;
}

#pragma mark - Coding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _consumeItemArray = [aDecoder decodeObjectForKey:kConsumeItemArrayKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_consumeItemArray forKey:kConsumeItemArrayKey];
}

#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone
{
    ConsumeItems *copy = [[[self class] allocWithZone:zone] init];
    NSMutableArray *itemsCopy = [NSMutableArray array];
    for (id item in _consumeItemArray)
    {
        [itemsCopy addObject:item];
    }
    [copy setConsumeItemArray:itemsCopy];
    return copy;
}

@end
