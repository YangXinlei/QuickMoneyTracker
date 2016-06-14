//
//  ConsumeEventTableCell.m
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/10.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import "ConsumeEventTableCell.h"
#import "Defs.h"

@interface ConsumeEventTableCell ()

@property(nonatomic, strong) ConsumeEventItem *item;

@end

@implementation ConsumeEventTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        double kSpaceXStart = 0;
        
        _howMuchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kHowMuchColumnWidth, kCellHeight)];
        kSpaceXStart += kHowMuchColumnWidth + kGapWidth;
        _kinCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceXStart, 0, kKingCostColumnWidth, kCellHeight)];
        kSpaceXStart += kKingCostColumnWidth + kGapWidth;
        _queneCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceXStart, 0, kQueneCostColumnWidth, kCellHeight)];
        kSpaceXStart += kQueneCostColumnWidth + kGapWidth;
        _whatLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceXStart, 0, kWhatColumnWidth, kCellHeight)];
        
        [self addSubview:_howMuchLabel];
        [self addSubview:_kinCostLabel];
        [self addSubview:_queneCostLabel];
        [self addSubview:_whatLabel];
        
        [self setupLabels];
    }
    return self;
}

- (void)setupLabels
{
    for (UIView *subView in [self subviews])
    {
        if ([subView isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel *)subView;
            [label setTextAlignment:NSTextAlignmentCenter];
            
            //竖直分割线
            UIView *oneLineView = [[UIView alloc] initWithFrame:CGRectMake(label.frame.size.width, 0, 0.5f, label.frame.size.height)];
            [oneLineView setBackgroundColor:[UIColor lightGrayColor]];
            [label addSubview:oneLineView];
        }
    }
}

/**
 *  根据ConsumeEventItem设置Label
 *
 *  @param item 与cell对应的数据
 */
- (void)setWithConsumeItem:(ConsumeEventItem *)item
{
    [_howMuchLabel setText:[NSString stringWithFormat:@"%.1f", [item howMuch]]];
    [_kinCostLabel setText:[NSString stringWithFormat:@"%.1f", [item kingCost]]];
    [_queneCostLabel setText:[NSString stringWithFormat:@"%.1f", [item queneCost]]];
    [_whatLabel setText:[NSString stringWithFormat:@"%@", [item what]]];
}

@end
