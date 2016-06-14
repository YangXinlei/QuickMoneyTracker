//
//  SimpleTime.h
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/12.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  只关心时分的time类
 */
@interface SimpleTime : NSObject

@property(nonatomic) NSInteger hour;
@property(nonatomic) NSInteger minute;

- (instancetype)initWithDate:(NSDate *)date;

/**
 *  判断该时刻与给定date是否临近
 *
 */
- (BOOL)isNearToDate:(NSDate *)date;

@end
