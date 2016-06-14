//
//  BaseViewController.m
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/13.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import "BaseViewController.h"

#define kDrawerLength               300

@implementation BaseViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _historyTableVC = [[LeftHistoryTableViewController alloc] init];
    [self.view addSubview:[_historyTableVC view]];
    [self addChildViewController:[self historyTableVC]];
    
    _mainTableVC = [[MainTableViewController alloc] initWithSimpleDate:[[SimpleDate alloc] initWithDate:[NSDate date]]];
    _mainNaviController = [[UINavigationController alloc] initWithRootViewController:_mainTableVC];
    [[[_mainNaviController view] layer] setShadowColor:[UIColor darkGrayColor].CGColor];
    [[[_mainNaviController view] layer] setShadowOffset:CGSizeMake(-3, 0)];
    [[[_mainNaviController view] layer] setShadowOpacity:0.8];
    [[[_mainNaviController view] layer] setShadowRadius:4.0];
    
    [self.view addSubview:[_mainNaviController view]];
    [self addChildViewController:_mainNaviController];
}

#pragma mark - getter and setter

-(UIView *)mainViewMaskView
{
    if (_mainViewMaskView == nil)
    {
        _mainViewMaskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        UITapGestureRecognizer *gestureRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeDrawer:)];
        [_mainViewMaskView addGestureRecognizer:gestureRecoginzer];
    }
    return _mainViewMaskView;
}

#pragma mark -

/**
 *  替换视图
 *
 *  @param newMainTableVC <#newMainTableVC description#>
 */
-(void)updateMainTableVC:(MainTableViewController *)newMainTableVC
{
    CGAffineTransform curTransform = [[_mainNaviController view] transform];
    
    [[_mainTableVC view] removeFromSuperview];
    [_mainTableVC removeFromParentViewController];
    _mainTableVC = nil;
    
    [[_mainNaviController view] removeFromSuperview];
    [_mainNaviController removeFromParentViewController];
    _mainNaviController = nil;
    
    
    _mainTableVC = newMainTableVC;
    _mainNaviController = [[UINavigationController alloc] initWithRootViewController:_mainTableVC];
    [[[_mainNaviController view] layer] setShadowColor:[UIColor darkGrayColor].CGColor];
    [[[_mainNaviController view] layer] setShadowOffset:CGSizeMake(-3, 0)];
    [[[_mainNaviController view] layer] setShadowOpacity:0.8];
    [[[_mainNaviController view] layer] setShadowRadius:4.0];
    
    [[_mainNaviController view] setTransform:curTransform];
    
    [self.view addSubview:[_mainNaviController view]];
    [self addChildViewController:_mainNaviController];
}

/**
 *  打开抽屉：显示出左侧视图
 *
 */
-(void)openDrawer:(id)sender
{
    [[_mainNaviController view] addSubview:[self mainViewMaskView]];
    
    [_historyTableVC.tableView reloadData];
    
    [self startMovingDrawerWithOffset:kDrawerLength];
}


/**
 *  关闭抽屉
 */
-(void)closeDrawer:(id)sender
{
    [_mainViewMaskView removeFromSuperview];
    
    [self startMovingDrawerWithOffset:0.0];
}

/**
 *  执行抽屉开关动画
 *
 *  @param offset 指定打开程度（相对0，0点）
 */
-(void)startMovingDrawerWithOffset:(CGFloat)offset
{
    if (offset > kDrawerLength) offset = kDrawerLength;
    else if (offset < 0) offset = 0;
    
    [UIView beginAnimations:@"movingDrawer" context:nil];
    
    // set animation props
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [[_mainNaviController view] setTransform:CGAffineTransformMakeTranslation(offset, 0)];
    
    [UIView commitAnimations];
}

@end
