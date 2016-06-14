//
//  ItemDetailVC.m
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/13.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import "ItemDetailVC.h"
#import "ItemDetailView.h"
#import "ConsumeEventItem.h"

@implementation ItemDetailVC

-(instancetype)initWithItem:(ConsumeEventItem *)item
{
    self = [super init];
    if (self)
    {
        [self setItem:item];
    }
    return self;
}

- (void)setItem:(ConsumeEventItem *)item
{
    _item = item;
    [self setupViewWithItem:_item];
}

- (ItemDetailView *)detailView
{
    if (_detailView == nil)
        _detailView = [[ItemDetailView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return _detailView;
}

- (void)setupViewWithItem:(ConsumeEventItem *)item
{
    NSDate *correctDate = [item.when dateByAddingTimeInterval:8 * 60 * 60];  //+8小时
    NSString *dateStr = [NSString stringWithFormat:@"%@", correctDate];
    
    NSRange spaceRange = [dateStr rangeOfString:@" " options:NSBackwardsSearch];
    dateStr = [dateStr substringToIndex:spaceRange.location];
    [[[self detailView] whenValueLabel] setText:dateStr];
    [[[self detailView] howMuchValueLabel] setText:[NSString stringWithFormat:@"%.1f", item.howMuch]];
    [[[self detailView] kingCostValueLabel] setText:[NSString stringWithFormat:@"%.1f", item.kingCost]];
    [[[self detailView] queneCostValueLabel] setText:[NSString stringWithFormat:@"%.1f", item.queneCost]];
    [[[self detailView] whatValueLabel] setText:item.what];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"详情"];
    
    self.view = self.detailView;
}
@end
