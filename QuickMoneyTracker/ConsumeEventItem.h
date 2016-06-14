//
//  ConsumeEventItem.h
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/10.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsumeEventItem : NSObject<NSCoding, NSCopying>

@property(nonatomic, copy)  NSDate      *when;
@property(nonatomic, copy)  NSString    *what;
@property(nonatomic)        double       howMuch;
@property(nonatomic)        double       kingCost;
@property(nonatomic)        double       queneCost;

- (instancetype)initWithDate:(NSDate *)date what:(NSString *)whatStr howMuch:(double)howMuchStr kingCost:(double)kingCostStr queueCost:(double)queueCostStr;

@end
