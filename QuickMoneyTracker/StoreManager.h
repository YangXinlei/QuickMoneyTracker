//
//  StoreManager.h
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/12.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConsumeItems.h"
#import "SimpleDate.h"

@interface StoreManager : NSObject

+ (instancetype)sharedStoreManager;

- (void)writeConsumeItems:(ConsumeItems *)dataArray;

- (ConsumeItems *)readConsumeItems;


- (void)writeConsumeItems:(ConsumeItems *)dataArray withSimpleDate:(SimpleDate *)ymDate;

- (ConsumeItems *)readConsumeItemsWithSimpleDate:(SimpleDate *)ymDate;


- (ConsumeItems *)readConsumeItemsWithDataFilePath:(NSString *)filePath;

- (NSArray *)allArchiveFiles;

@end
