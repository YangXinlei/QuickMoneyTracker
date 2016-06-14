//
//  ItemDetailView.h
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/13.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemDetailView : UIView

@property(nonatomic, strong) UILabel *whenLabel;
@property(nonatomic, strong) UILabel *whenValueLabel;


@property(nonatomic, strong) UILabel *howMuchLabel;
@property(nonatomic, strong) UILabel *howMuchValueLabel;


@property(nonatomic, strong) UILabel *kingCostLabel;
@property(nonatomic, strong) UILabel *kingCostValueLabel;


@property(nonatomic, strong) UILabel *queneCostLabel;
@property(nonatomic, strong) UILabel *queneCostValueLabel;


@property(nonatomic, strong) UILabel *whatLabel;
@property(nonatomic, strong) UILabel *whatValueLabel;

@end
