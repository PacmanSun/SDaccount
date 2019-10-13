//
//  SDItemService.m
//  SDaccount
//
//  Created by SunLi on 2019/10/4.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDItemService.h"
#import "SDDBManager.h"
#import "SDItem+WCTTableCoding.h"

@interface SDItemService ()

@property (nonatomic, strong) NSString *tableName;
@property (nonatomic, strong) WCTDatabase *db;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSMutableDictionary *map;

- (void)setupItems;

@end

@implementation SDItemService

+ (instancetype)service {
    static SDItemService *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SDItemService alloc]init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _list = [[NSMutableArray alloc]initWithCapacity:50];
        _map = [[NSMutableDictionary alloc]initWithCapacity:50];

        _db = DBManager.database;
        [_db createTableAndIndexesOfName:self.tableName withClass:[SDItem class]];
    }
    return self;
}

- (SDItem *)queryItemWithName:(NSString *)itemName {
    NSParameterAssert(itemName);
    NSString *key = [[NSString alloc]initWithFormat:@"%@", itemName];
    return self.map[key];
}

- (void)addItemWithName:(NSString *)itemName {
    SDItem *newItem = [[SDItem alloc]init];
    newItem.isAutoIncrement = YES;
    newItem.name = itemName;
    NSInteger maxIndex = [[self.db getOneValueOnResult:SDItem.sortIndex.count() fromTable:self.tableName]integerValue];
    newItem.sortIndex = maxIndex + 1;
    [self.db insertObject:newItem into:self.tableName];

    [self.list addObject:newItem];
    NSString *key = [[NSString alloc]initWithFormat:@"%@", newItem.name];
    self.map[key] = newItem;
}

- (NSArray<SDItem *> *)fetchItems {
    NSArray *res;
    res = [self.db getAllObjectsOfClass:SDItem.class fromTable:self.tableName];
    return res;
}

#pragma mark -
#pragma mark pritate method

- (void)setupItems {
    WCTSelect *select = [self.db prepareSelectObjectsOfClass:SDItem.class fromTable:self.tableName];
    NSArray *res = select.allObjects;
    [self.list addObjectsFromArray:res];
    DDLogInfo(@"[Item service]: load item data from cache");

    [self.list enumerateObjectsUsingBlock:^(SDItem *item, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *key = [[NSString alloc]initWithFormat:@"%@", item.name];
        self.map[key] = item;
    }];
}

#pragma mark -
#pragma mark private property

- (NSString *)tableName {
    return @"item";
}

#pragma mark -
#pragma mark property

- (NSArray<SDItem *> *)itemList {
    return self.list.copy;
}

@end
