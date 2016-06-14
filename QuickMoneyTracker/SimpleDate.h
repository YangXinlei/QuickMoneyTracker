//
//  SimpleDate.h
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/13.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  只关心年月的Date类
 */
@interface SimpleDate : NSObject

@property(nonatomic) NSInteger year;
@property(nonatomic) NSInteger month;

- (instancetype)initWithDate:(NSDate *)date;

-(instancetype)initWithYear:(NSInteger)year AndMonth:(NSInteger)month;

@end
