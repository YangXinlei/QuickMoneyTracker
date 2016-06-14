//
//  LeftHistoryTableViewController.m
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/13.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import "LeftHistoryTableViewController.h"
#import "StoreManager.h"
#import "BaseViewController.h"
#import "MainTableViewController.h"
#import "SimpleDate.h"


#define kUITableViewCellResueId             @"kUITableViewCellResueId"
#define kCellHeight                         50

@interface LeftHistoryTableViewController ()

@property (nonatomic, strong) NSArray *archiveFiles;

@end

@implementation LeftHistoryTableViewController

-(instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        _archiveFiles = [[StoreManager sharedStoreManager] allArchiveFiles];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kUITableViewCellResueId];
    
}

#pragma mark - table view data source method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_archiveFiles count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellResueId forIndexPath:indexPath];


    SimpleDate *ymDate = [self simpleDateWithFilePath:_archiveFiles[indexPath.row]];
    
    [[cell textLabel] setText:[NSString stringWithFormat:@"%ld年%ld月", (long)ymDate.year, (long)ymDate.month]];
    
    ConsumeItems *consumeItems = [[StoreManager sharedStoreManager] readConsumeItemsWithSimpleDate:ymDate];
    ColorType ct = [consumeItems suggestColor:[consumeItems addUp]];
    [cell setBackgroundColor:[UIColor colorWithRed:ct.red green:ct.green blue:ct.blue alpha:ct.alpha]];
    
    return cell;
}

#pragma mark - table view delegete

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return kCellHeight;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseViewController *rootViewController = (BaseViewController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    MainTableViewController *newMainTableViewController = [[MainTableViewController alloc] initWithSimpleDate:[self simpleDateWithFilePath:_archiveFiles[indexPath.row]]];
    
    [rootViewController updateMainTableVC:newMainTableViewController];
    [rootViewController closeDrawer:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (SimpleDate *)simpleDateWithFilePath:(NSString *)filePath
{
    NSRange dotRange = [filePath rangeOfString:@"." options:NSBackwardsSearch];
    NSRange lastUnderBarRange = [filePath rangeOfString:@"_" options:NSBackwardsSearch];
    NSRange lastSecondUnderBarRange = [filePath rangeOfString:@"_" options:NSBackwardsSearch range:NSMakeRange(0, lastUnderBarRange.location - 1)];
    
    NSString *yearStr = [filePath substringWithRange:NSMakeRange(lastSecondUnderBarRange.location + 1, lastUnderBarRange.location - lastSecondUnderBarRange.location - 1)];
    NSString *monthStr = [filePath substringWithRange:NSMakeRange(lastUnderBarRange.location + 1, dotRange.location - lastUnderBarRange.location - 1)];
    
    return [[SimpleDate alloc] initWithYear:[yearStr integerValue] AndMonth:[monthStr integerValue]];
}

@end
