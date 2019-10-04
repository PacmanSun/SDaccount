//
//  SDLocationService.m
//  SDaccount
//
//  Created by SunLi on 2019/10/4.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDLocationService.h"
#import "SDDBManager.h"
#import "SDLocation+WCTTableCoding.h"

static NSString *const keyLocationVersion = @"location_version";

@interface SDLocationService ()

@property (nonatomic, strong) NSString *tableName;
@property (nonatomic, strong) WCTDatabase *db;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSMutableDictionary *map;

- (void)insertAllWithPlistDict:(NSDictionary *)dict;
- (void)setupCategories;
- (BOOL)isBetaVersion:(NSString *)version;

@end

@implementation SDLocationService

+ (instancetype)service {
    static SDLocationService *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SDLocationService alloc]init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _list = [[NSMutableArray alloc]initWithCapacity:15];
        _map = [[NSMutableDictionary alloc]initWithCapacity:50];

        _db = DBManager.database;
        [_db createTableAndIndexesOfName:self.tableName withClass:[SDLocation class]];
    }
    return self;
}

- (SDLocation *)queryLocationWithName:(NSString *)locationName {
    NSParameterAssert(locationName);
    NSString *key = [[NSString alloc]initWithFormat:@"%@", locationName];
    return self.map[key];
}

- (void)addCustomLocationWithName:(NSString *)locationName {
    SDLocation *newLocation = [[SDLocation alloc]init];
    newLocation.isAutoIncrement = YES;
    newLocation.name = locationName;
    newLocation.iconName = @"sd_custom";
    newLocation.builtin = NO;
    newLocation.color = SD_THEME_COLOR;
    NSInteger maxIndex = [[self.db getOneValueOnResult:SDLocation.sortIndex.count() fromTable:self.tableName]integerValue];
    newLocation.sortIndex = maxIndex + 1;
    [self.db insertObject:newLocation into:self.tableName];

    [self.list addObject:newLocation];
    NSString *key = [[NSString alloc]initWithFormat:@"%@", newLocation.name];
    self.map[@"key"] = newLocation;
}

//- (NSArray<SDLocation *> *)fetchCustomLocation;

#pragma mark -
#pragma mark private method

@end
