//
//  ViewController.h
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/10.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsumeItems.h"
#import "SimpleDate.h"

@interface MainTableViewController : UITableViewController

//保存所有消费记录
@property(nonatomic, strong) ConsumeItems     *consumeItems;

//显示某年某月的数据
@property(nonatomic, strong) SimpleDate *ymDate;


-(instancetype)initWithSimpleDate:(SimpleDate *)ymDate;

@end

