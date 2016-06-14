//
//  ItemDetailVC.h
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/13.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConsumeEventItem;
@class ItemDetailView;


@interface ItemDetailVC : UIViewController

@property(nonatomic, strong) ConsumeEventItem *item;
@property(nonatomic, strong) ItemDetailView *detailView;

-(instancetype)initWithItem:(ConsumeEventItem *)item;

@end
