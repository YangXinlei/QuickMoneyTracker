//
//  AddItemCell.h
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/10.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsumeEventItem.h"

@interface AddItemCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic, strong) UITextField *howMuchTextField;
@property(nonatomic, strong) UITextField *kingCostTextField;
@property(nonatomic, strong) UITextField *queneCostTextField;
@property(nonatomic, strong) UITextField *whatTextField;

- (BOOL)canSave;

- (instancetype)initWithConsumeEventItem:(ConsumeEventItem *)item;

@end
