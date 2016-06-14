//
//  ConsumeEventTableCell.h
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/10.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsumeEventItem.h"

@interface ConsumeEventTableCell : UITableViewCell

@property(nonatomic, strong) UILabel *howMuchLabel;
@property(nonatomic, strong) UILabel *kinCostLabel;
@property(nonatomic, strong) UILabel *queneCostLabel;
@property(nonatomic, strong) UILabel *whatLabel;

- (void)setWithConsumeItem:(ConsumeEventItem *)item;

@end
