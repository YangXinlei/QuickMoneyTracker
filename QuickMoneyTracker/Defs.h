//
//  Defs.h
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/10.
//  Copyright © 2016年 qunar. All rights reserved.
//

#ifndef Defs_h
#define Defs_h


#define kCellHeight             50

#define kGapWidth               0

#define kScreenWidth            ([[UIScreen mainScreen] bounds].size.width)

#define kOneFifthWidth          (kScreenWidth - 3 * kGapWidth) / 5

#define kWhatColumnWidth        2 * kOneFifthWidth

#define kHowMuchColumnWidth     kOneFifthWidth
#define kQueneCostColumnWidth   kOneFifthWidth
#define kKingCostColumnWidth    kOneFifthWidth


#define kSaveItemNotification   @"kSaveItemNotification"

#endif /* Defs_h */
