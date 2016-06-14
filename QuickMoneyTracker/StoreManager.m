//
//  StoreManager.m
//  QuickMoneyTracker
//
//  Created by yangxinlei on 16/6/12.
//  Copyright © 2016年 qunar. All rights reserved.
//

#import "StoreManager.h"

#define kDataKey        @"kDataKey"

@implementation StoreManager

+ (instancetype)sharedStoreManager
{
    static StoreManager *storeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storeManager = [[self alloc] init];
    });
    return storeManager;
}

#pragma mark - old read/write
/**
 *  获得永久存储文件路径
 *
 *  @return 路径
 */
- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:@"itemsData.archive"];
}

- (void)writeConsumeItems:(ConsumeItems *)items
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:items forKey:kDataKey];
    [archiver finishEncoding];
    
    [data writeToFile:[self dataFilePath] atomically:YES];
}


#pragma mark - new read/write with year+month

- (NSString *)dataFilePathWithSimpleDate:(SimpleDate *)ymDate
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"itemsData_%ld_%ld.archive", (long)ymDate.year, (long)ymDate.month]];
}

- (ConsumeItems *)readConsumeItemsWithSimpleDate:(SimpleDate *)ymDate
{
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePathWithSimpleDate:ymDate]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    ConsumeItems *result = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];
    
    return result;
}

- (void)writeConsumeItems:(ConsumeItems *)items withSimpleDate:(SimpleDate *)ymDate
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:items forKey:kDataKey];
    [archiver finishEncoding];
    
    [data writeToFile:[self dataFilePathWithSimpleDate:ymDate] atomically:YES];
}

#pragma mark -

- (ConsumeItems *)readConsumeItemsWithDataFilePath:(NSString *)filePath
{
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    ConsumeItems *result = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];
    
    return result;
}

-(NSArray *)allArchiveFiles
{
    NSMutableArray *rlt = [[NSMutableArray alloc] initWithCapacity:42];
    
    // path of documents
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dicEnumerator = [fileManager enumeratorAtPath:documentsDirectory];
    NSString *fileName;
    while ( nil != (fileName = [dicEnumerator nextObject]) )
    {
        if ( [fileName hasPrefix:@"itemsData_"] && [fileName hasSuffix:@".archive"])
        {
            NSString *itemArchiveFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
            ConsumeItems *tmpConsumItems = [self readConsumeItemsWithDataFilePath:itemArchiveFilePath];
            
            if ([tmpConsumItems itemCount] > 0)
            {
                [rlt addObject:itemArchiveFilePath];
            }
        }
    }
    return rlt;
}

@end
