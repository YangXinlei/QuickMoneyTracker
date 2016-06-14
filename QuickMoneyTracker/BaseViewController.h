//
//  BaseViewController.h
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/13.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftHistoryTableViewController.h"
#import "MainTableViewController.h"

@interface BaseViewController : UIViewController

@property(nonatomic, strong) LeftHistoryTableViewController *historyTableVC;
@property(nonatomic, strong) UINavigationController *mainNaviController;
@property(nonatomic, strong) MainTableViewController *mainTableVC;

@property(nonatomic, strong) UIView *mainViewMaskView;

-(void)openDrawer:(id)sender;
-(void)closeDrawer:(id)sender;

- (void)updateMainTableVC:(MainTableViewController *)newMainTableVC;
@end
