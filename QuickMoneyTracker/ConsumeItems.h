//
//  ConsumeItems.h
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/12.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConsumeEventItem.h"

typedef struct ColorStruct {
    float red;
    float green;
    float blue;
    float alpha;
} ColorType;

@interface ConsumeItems : NSObject<NSCoding, NSCopying>

@property(nonatomic, strong) NSMutableArray *consumeItemArray;

+ (instancetype)sharedConsumeItems;

- (void) deleteItemAtIndex:(NSInteger)index;

- (void) addItem:(ConsumeEventItem *)item;

- (ConsumeEventItem *) itemAtIndex:(NSInteger)index;

- (NSInteger) itemCount;

- (ConsumeEventItem *) suggestNewItem;

-(ConsumeEventItem *) addUp;

-(ColorType)suggestColor:(ConsumeEventItem *)item;

@end
