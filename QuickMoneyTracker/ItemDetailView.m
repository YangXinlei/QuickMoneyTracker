//
//  ItemDetailView.m
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/13.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import "ItemDetailView.h"

#define kMarginLeft         70
#define kMarginRight        kMarginLeft / 2
#define kMarginTop          200
#define kMarginBottom       200

#define kTextHeight         50
#define kTextGap            10

#define kRowNum             5

@implementation ItemDetailView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        CGFloat spaceXStart = kMarginLeft;
        CGFloat spaceYStart = kMarginTop;
        
        CGFloat textVerticalGap = (frame.size.height - kMarginTop - kMarginBottom - kRowNum * kTextHeight) / (kRowNum - 1);
        CGFloat textLabelWidth = (frame.size.width - kMarginLeft - kMarginRight - kTextGap) / 3;
        CGFloat valueLableWidth = textLabelWidth * 2;
        
        // 初始化左边一列标签
        _whenLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, spaceYStart, textLabelWidth, kTextHeight)];
        spaceYStart += kTextHeight + textVerticalGap;
        _howMuchLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, spaceYStart, textLabelWidth, kTextHeight)];
        spaceYStart += kTextHeight + textVerticalGap;
        _kingCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, spaceYStart, textLabelWidth, kTextHeight)];
        spaceYStart += kTextHeight + textVerticalGap;
        _queneCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, spaceYStart, textLabelWidth, kTextHeight)];
        spaceYStart += kTextHeight + textVerticalGap;
        _whatLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, spaceYStart, textLabelWidth, kTextHeight)];
        
        spaceXStart += textLabelWidth + kTextGap;
        spaceYStart = kMarginTop;
        
        //初始化右边一列标签
        _whenValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, spaceYStart, valueLableWidth, kTextHeight)];
        spaceYStart += kTextHeight + textVerticalGap;
        _howMuchValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, spaceYStart, valueLableWidth, kTextHeight)];
        spaceYStart += kTextHeight + textVerticalGap;
        _kingCostValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, spaceYStart, valueLableWidth, kTextHeight)];
        spaceYStart += kTextHeight + textVerticalGap;
        _queneCostValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, spaceYStart, valueLableWidth, kTextHeight)];
        spaceYStart += kTextHeight + textVerticalGap;
        _whatValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, spaceYStart, valueLableWidth, kTextHeight)];
        
        
        // 设置左列标签
        [_whenLabel setText:@"日期："];                    [_whenLabel setTextAlignment:NSTextAlignmentRight];
        [_howMuchLabel setText:@"消费总额："];              [_howMuchLabel setTextAlignment:NSTextAlignmentRight];
        [_kingCostLabel setText:@"我分摊："];               [_kingCostLabel setTextAlignment:NSTextAlignmentRight];
        [_queneCostLabel setText:@"对方分摊："];             [_queneCostLabel setTextAlignment:NSTextAlignmentRight];
        [_whatLabel setText:@"用途："];                     [_whatLabel setTextAlignment:NSTextAlignmentRight];
        
        // 添加到view
        [self addSubview:_whenLabel];               [self addSubview:_whenValueLabel];
        [self addSubview:_howMuchLabel];            [self addSubview:_howMuchValueLabel];
        [self addSubview:_kingCostLabel];           [self addSubview:_kingCostValueLabel];
        [self addSubview:_queneCostLabel];          [self addSubview:_queneCostValueLabel];
        [self addSubview:_whatLabel];               [self addSubview:_whatValueLabel];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    
}

@end
