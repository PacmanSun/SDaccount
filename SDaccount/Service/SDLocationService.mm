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
        _list = [[NSMutableArray alloc]initWithCapacity:50];
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
    self.map[key] = newLocation;
}

- (NSArray<SDLocation *> *)fetchCustomLocation {
    NSArray *res;
    res = [self.db getObjectsOfClass:SDLocation.class fromTable:self.tableName where:SDLocation.builtin == NO];
    return res;
}

#pragma mark -
#pragma mark private method

- (void)insertAllWithPlistDict:(NSDictionary *)dict {
    NSArray *list = dict[@"list"];
    [list enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *_Nonnull stop) {
        SDLocation *location = [SDLocation yy_modelWithDictionary:dict];
        location.isAutoIncrement = YES;
        if (location) {
            [self.list addObject:location];
        }
    }];
    [self.db insertObjects:self.list into:self.tableName];
}

- (void)setupCategories {
    BOOL haveCache = [[self.db getOneValueOnResult:SDLocation.locationID.count() fromTable:self.tableName]unsignedIntegerValue] > 0;
    NSString *plistFile = [[NSBundle mainBundle]pathForResource:@"Locations" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc ]initWithContentsOfFile:plistFile];
    NSString *version = dict[@"version"];
    NSString *orderVersion = [KeyValueStore stringForKey:keyLocationVersion];

    if (!haveCache) {
        [self insertAllWithPlistDict:dict];
        DDLogInfo(@"[Location service]: insert location data");
    } else if (!SDIsEqualString(version, orderVersion)) {
        DDLogInfo(@"[Location service]: update location data");
        if ([self isBetaVersion:orderVersion]) {
            [self.db deleteAllObjectsFromTable:self.tableName];
            [self insertAllWithPlistDict:dict];
        }
    } else {
        WCTSelect *select = [self.db prepareSelectObjectsOfClass:SDLocation.class fromTable:self.tableName];
        NSArray *res = select.allObjects;
        [self.list addObjectsFromArray:res];
        DDLogInfo(@"[Location service]: load location data from cache");
    }

    [KeyValueStore setString:version forKey:keyLocationVersion];

    [self.list enumerateObjectsUsingBlock:^(SDLocation *location, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *key = [NSString stringWithFormat:@"_%@", location.name];
        self.map[key] = location;
    }];
}

- (BOOL)isBetaVersion:(NSString *)version {
    float v = version.floatValue;
    return v < 1.0;
}

#pragma mark -
#pragma mark private property

- (NSString *)tableName {
    return @"location";
}

#pragma mark -
#pragma mark property

- (NSArray<SDLocation *> *)locationList {
    return self.list.copy;
}

@end
