//
//  ViewController.m
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/10.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import "MainTableViewController.h"
#import "ConsumeEventTableCell.h"
#import "AddItemCell.h"
#import "ConsumeEventItem.h"
#import "StoreManager.h"
#import "ItemDetailVC.h"
#import "Defs.h"

#define kConsumeEventCellResueId        @"ConsumeEventTableCellResuseId"
#define kUserDefaultKeyForConsumeItem   @"UserDefaultKeyForConsumeItem"

@interface MainTableViewController ()

@property(nonatomic) BOOL showAddCell;
@property(nonatomic, strong) AddItemCell *addItemCell;
@end

@implementation MainTableViewController

-(instancetype)initWithSimpleDate:(SimpleDate *)ymDate
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        _ymDate = ymDate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //设置navigationBar
    // 左侧抽屉按钮
    UIBarButtonItem *showDrawerButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"回顾" style:UIBarButtonItemStylePlain target:[[[UIApplication  sharedApplication] keyWindow] rootViewController] action:@selector(openDrawer:)];
    [[self navigationItem] setLeftBarButtonItem:showDrawerButtonItem];
    
    self.tableView.bounces = NO;
    // 右侧+按钮   如果不是当月，则不显示
    if ([_ymDate isEqual:[[SimpleDate alloc] initWithDate:[NSDate date]]])
    {
        [self setTitle:@"QMT"];
        UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        [[self navigationItem] setRightBarButtonItem:addButtonItem];
    }
    else
    {
        [self setTitle:[NSString stringWithFormat:@"%ld年%ld月", (long)_ymDate.year, (long)_ymDate.month]];
        [showDrawerButtonItem setTitle:@"返回"];
    }
    
    //读取本地已有记录
    _consumeItems = [[StoreManager sharedStoreManager] readConsumeItemsWithSimpleDate:_ymDate];
    if (_consumeItems == nil)
        _consumeItems = [ConsumeItems sharedConsumeItems];
    
    [self.tableView registerClass:[ConsumeEventTableCell class] forCellReuseIdentifier:kConsumeEventCellResueId];
    [self.tableView setTableFooterView:[self createAndSetupFooterView]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveItem:) name:kSaveItemNotification object:[UIApplication sharedApplication]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view data source method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _showAddCell ? [_consumeItems itemCount] + 1 : [_consumeItems itemCount];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_showAddCell && indexPath.row == [_consumeItems itemCount])
    {
        if (nil == _addItemCell)
            _addItemCell = [[AddItemCell alloc] initWithConsumeEventItem:[_consumeItems suggestNewItem]];
        return _addItemCell;
    }
    
    ConsumeEventTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kConsumeEventCellResueId forIndexPath:indexPath];
    
    [cell setWithConsumeItem:[_consumeItems itemAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if ([indexPath row] < [_consumeItems itemCount])
        {
            UIAlertController *deleteAlertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
                [_consumeItems deleteItemAtIndex:[indexPath row]];
                [[StoreManager sharedStoreManager] writeConsumeItems:_consumeItems withSimpleDate:_ymDate];
                
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
                
                [self updateFooterView];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                [self.tableView setEditing:NO animated:YES];
            }];
            
            [deleteAlertController addAction:deleteAction];
            [deleteAlertController addAction:cancelAction];
            [self presentViewController:deleteAlertController animated:YES completion:nil];
        }
        else    //删除addCell行
        {
            _addItemCell = nil;
            _showAddCell = NO;
            
            [self.tableView  reloadData];
            UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
            [[self navigationItem] setRightBarButtonItem:addButtonItem];
        }
    }
}

#pragma mark - table view delegete

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

#pragma header and footer

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kCellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat spaceXStart = 0;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCellHeight)];
    [headerView setBackgroundColor:[UIColor colorWithRed:100 / 255.0 green:180 / 255.0 blue:90 / 255.0 alpha:0.4]];
    
    UILabel *howMuchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kHowMuchColumnWidth, kCellHeight)];
    [howMuchLabel setText:@"总额"];
    [howMuchLabel setTextAlignment:NSTextAlignmentCenter];
    [howMuchLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:howMuchLabel];
    spaceXStart += kHowMuchColumnWidth + kGapWidth;
    
    UILabel *kingCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, 0, kKingCostColumnWidth, kCellHeight)];
    [kingCostLabel setText:@"A"];
    [kingCostLabel setBackgroundColor:[UIColor clearColor]];
    [kingCostLabel setTextAlignment:NSTextAlignmentCenter];
    [headerView addSubview:kingCostLabel];
    spaceXStart += kKingCostColumnWidth + kGapWidth;
    
    UILabel *queneCostlabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, 0, kQueneCostColumnWidth, kCellHeight)];
    [queneCostlabel setText:@"B"];
    [queneCostlabel setBackgroundColor:[UIColor clearColor]];
    [queneCostlabel setTextAlignment:NSTextAlignmentCenter];
    [headerView addSubview:queneCostlabel];
    spaceXStart += kQueneCostColumnWidth + kGapWidth;
    
    UILabel *whatLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, 0, kWhatColumnWidth, kCellHeight)];
    [whatLabel setText:@"用途"];
    [whatLabel setBackgroundColor:[UIColor clearColor]];
    [whatLabel setTextAlignment:NSTextAlignmentCenter];
    [headerView addSubview:whatLabel];
    
    return headerView;
}

-(UIView *)createAndSetupFooterView
{
    ConsumeEventItem *addUpItem = [_consumeItems addUp];
    
    CGFloat spaceXStart = 0;

    ColorType bgc = [_consumeItems suggestColor:addUpItem];
    UIColor *curColor = [UIColor colorWithRed:bgc.red green:bgc.green blue:bgc.blue alpha:bgc.alpha];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCellHeight)];
    [footerView setBackgroundColor:curColor];
    
    UILabel *howMuchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kHowMuchColumnWidth, kCellHeight)];
    [howMuchLabel setText:[NSString stringWithFormat:@"%.2f", addUpItem.howMuch]];
    [howMuchLabel setTextAlignment:NSTextAlignmentCenter];
    [howMuchLabel setBackgroundColor:[UIColor clearColor]];
    [footerView addSubview:howMuchLabel];
    spaceXStart += kHowMuchColumnWidth + kGapWidth;
    
    UILabel *kingCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, 0, kKingCostColumnWidth, kCellHeight)];
    [kingCostLabel setText:[NSString stringWithFormat:@"%.2f", addUpItem.kingCost]];
    [kingCostLabel setBackgroundColor:[UIColor clearColor]];
    [kingCostLabel setTextAlignment:NSTextAlignmentCenter];
    [footerView addSubview:kingCostLabel];
    spaceXStart += kKingCostColumnWidth + kGapWidth;
    
    UILabel *queneCostlabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, 0, kQueneCostColumnWidth, kCellHeight)];
    [queneCostlabel setText:[NSString stringWithFormat:@"%.2f", addUpItem.queneCost]];
    [queneCostlabel setBackgroundColor:[UIColor clearColor]];
    [queneCostlabel setTextAlignment:NSTextAlignmentCenter];
    [footerView addSubview:queneCostlabel];
    spaceXStart += kQueneCostColumnWidth + kGapWidth;
    
    UILabel *whatLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, 0, kWhatColumnWidth, kCellHeight)];
    [whatLabel setText:addUpItem.what];
    [whatLabel setBackgroundColor:[UIColor clearColor]];
    [whatLabel setTextAlignment:NSTextAlignmentCenter];
    [footerView addSubview:whatLabel];
    
    return footerView;
}

- (void)updateFooterView
{
    NSArray<UILabel *> *labels = [self.tableView.tableFooterView subviews];
    if ([labels count] != 4)
        return ;
    
    ConsumeEventItem *addUpItem = [_consumeItems addUp];
    
    [labels[0] setText:[NSString stringWithFormat:@"%.2f", addUpItem.howMuch]];
    [labels[1] setText:[NSString stringWithFormat:@"%.2f", addUpItem.kingCost]];
    [labels[2] setText:[NSString stringWithFormat:@"%.2f", addUpItem.queneCost]];
    [labels[3] setText:addUpItem.what];
    
    ColorType bgc = [_consumeItems suggestColor:addUpItem];
    UIColor *bgColor = [UIColor colorWithRed:bgc.red green:bgc.green blue:bgc.blue alpha:bgc.alpha];
    
    [self.tableView.tableFooterView setBackgroundColor:bgColor];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemDetailVC *itemDetailVC = [[ItemDetailVC alloc] initWithItem:[_consumeItems itemAtIndex:[indexPath row]]];
    
    [self.navigationController pushViewController:itemDetailVC animated:YES];
}

#pragma mark - actions
- (void)addNewItem:(id)sender
{
    _showAddCell = YES;
    
    [self.tableView  reloadData];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_consumeItems itemCount] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveItem:)];
    [[self navigationItem] setRightBarButtonItem:saveButtonItem];
}

- (void)saveItem:(id)sender
{
    if (![_addItemCell canSave])
    {
        return ;
    }
    NSDate *now = [NSDate date];
    NSString *what = [[_addItemCell whatTextField] text];
    double howMuch = [[[_addItemCell howMuchTextField] text] doubleValue];
    double kingCost = [[[_addItemCell kingCostTextField] text] doubleValue];
    double queueCost = [[[_addItemCell queneCostTextField] text] doubleValue];
    
    ConsumeEventItem *newItem = [[ConsumeEventItem alloc] initWithDate:now what:what howMuch:howMuch kingCost:kingCost queueCost:queueCost];
    
    [_consumeItems addItem:newItem];
    
    [[StoreManager sharedStoreManager] writeConsumeItems:_consumeItems withSimpleDate:_ymDate];
    
    _addItemCell = nil;
    _showAddCell = NO;
    
    [self.tableView reloadData];
    [self updateFooterView];
    
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    [[self navigationItem] setRightBarButtonItem:addButtonItem];
}
@end
