//
//  SDLocationService.m
//  SDaccount
//
//  Created by SunLi on 2019/10/4.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDDBManager.h"
#import "SDLocationService.h"
#import "SDLocation+WCTTableCoding.h"
#import "SDRoomService.h"
#import "SDRoom+WCTTableCoding.h"
#import "SDAddressService.h"
#import "SDAddress+WCTTableCoding.h"

static NSString *const keyLocationVersion = @"location_version";
static NSString *const keyDefaultLocation = @"defaultLocation";

@interface SDLocationService ()

@property (nonatomic, strong) NSString *tableName;
@property (nonatomic, strong) WCTDatabase *db;
//dict的key为“roomID”string
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<SDLocation *> *> *lists;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, SDLocation *> *> *maps;

- (void)insertAllWithPlistDict:(NSDictionary *)dict key:(NSString *)key roomID:(NSInteger)roomID;
- (void)setup;
//- (BOOL)isBetaVersion:(NSString *)version;

//- (NSArray *)builtinListColors;
//- (NSArray *)builtinListIcons;
- (NSArray *)builtinListNames;
- (NSArray *)builtinList;

- (void)onDefaultRoomChanged:(NSNotification *)notification;
- (void)onRoomDeleted:(NSNotification *)notification;

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
        _lists = [[NSMutableDictionary alloc]initWithCapacity:SDRoomService.service.roomLists.count];
        _maps = [[NSMutableDictionary alloc]initWithCapacity:SDRoomService.service.roomLists.count];

        _db = DBManager.database;

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onDefaultRoomChanged:) name:SDDefaultRoomChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onRoomDeleted:) name:SDRoomDeletedNotification object:nil];
        [self setup];
    }
    return self;
}

- (void)configDefaultLocationWithName:(NSString *)locationName roomID:(NSInteger)roomID {
    if (locationName != self.defaultLocation.name || roomID != self.defaultLocation.roomID) {
        NSString *key = [NSString stringWithFormat:@"%ld_%@", roomID, locationName];
        self.defaultLocation = self.maps[SDno2Str(roomID)][locationName];
        [KeyValueStore setString:key forKey:keyDefaultLocation];
        [[NSNotificationCenter defaultCenter]postNotificationName:SDDefaultLocationChangedNotification object:@(self.defaultLocation.locationID)];
    }
}

- (NSDictionary<NSString *, NSArray<NSString *> *> *)nameLists {
    NSMutableDictionary *lists = [NSMutableDictionary dictionaryWithCapacity:self.lists.count];
    [SDRoomService.service.roomLists enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSArray<SDRoom *> *_Nonnull obj, BOOL *_Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(SDRoom *_Nonnull room, NSUInteger idx, BOOL *_Nonnull stop) {
            NSMutableArray *nameList = [NSMutableArray arrayWithCapacity:self.locationLists[SDno2Str(room.roomID)].count];

            [self.locationLists[SDno2Str(room.roomID)] enumerateObjectsUsingBlock:^(SDLocation *_Nonnull location, NSUInteger idx, BOOL *_Nonnull stop) {
                [nameList addObject:location.name];
            }];

            lists[SDno2Str(room.roomID)] = nameList.copy;
        }];
    }];

    return lists.copy;
}

- (NSArray *)builtinListColors {
    return @[SD_THEME_COLOR];
}

- (NSArray *)builtinListIcons {
    return @[@"icon_location"];
}

- (SDLocation *)queryLocationWithName:(NSString *)locationName {
    NSParameterAssert(locationName);
    NSMutableArray< NSString *> *roomIDstrs = [[NSMutableArray alloc]initWithCapacity:self.lists.count];
    [SDRoomService.service.roomLists enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSArray<SDRoom *> *_Nonnull obj, BOOL *_Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(SDRoom *_Nonnull room, NSUInteger idx, BOOL *_Nonnull stop) {
            [roomIDstrs addObject:SDno2Str(room.roomID)];
        }];
    }];

    NSMutableArray<SDLocation *> *res = [[NSMutableArray alloc]initWithCapacity:self.lists.count];
    for (NSString *roomIDstr in roomIDstrs) {
        if (self.maps[roomIDstr][locationName]) {
            [res addObject:self.maps[roomIDstr][locationName]];
        }
    }
    return res.copy;
}

- (SDLocation *)queryLocationWithName:(NSString *)locationName roomID:(NSInteger)roomID {
    NSParameterAssert(locationName);
    return self.maps[SDno2Str(roomID)][locationName];
}

- (BOOL)renameLocationWithName:(NSString *)locationName newName:(NSString *)newLocationName roomID:(NSInteger)roomID {
    SDLocation *location = [self queryLocationWithName:locationName roomID:roomID];
    NSString *roomIDstr = SDno2Str(roomID);

    if (self.maps[roomIDstr][locationName] != nil && self.maps[roomIDstr][newLocationName] == nil) {
        location.name = newLocationName;
        self.maps[roomIDstr][newLocationName] = location;
        [self.maps[roomIDstr] removeObjectForKey:locationName];
        [self.db updateRowsInTable:self.tableName onProperty:SDLocation.name withObject:location where:SDLocation.name == locationName];

        for (SDLocation *location in self.lists[roomIDstr]) {
            if (location.name == locationName) {
                location.name = newLocationName;
                break;
            }
        }

//        rename default
        if (self.defaultLocation.locationID == location.locationID) {
            NSString *key = [NSString stringWithFormat:@"%ld_%@", roomID, newLocationName];
            [KeyValueStore setString:key forKey:keyDefaultLocation];
        }

        [[NSNotificationCenter defaultCenter]postNotificationName:SDLocationRenamedNotification object:@(location.locationID)];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)deleteLocationWithName:(NSString *)locationName roomID:(NSInteger)roomID {
    SDLocation *location = [self queryLocationWithName:locationName roomID:roomID];
    NSString *roomIDstr = SDno2Str(roomID);
    if (self.maps[roomIDstr][locationName]) {
        [self.maps[roomIDstr] removeObjectForKey:locationName];
        [self.lists[roomIDstr] removeObject:location];
        [self.db deleteObjectsFromTable:self.tableName where:SDLocation.name == locationName];

        [[NSNotificationCenter  defaultCenter]postNotificationName:SDLocationDeletedNotification object:@(location.locationID)];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)addCustomLocationWithName:(NSString *)locationName inRoom:(NSInteger)roomID {
    SDLocation *newLocation = [[SDLocation alloc]init];
    newLocation.isAutoIncrement = YES;
    newLocation.name = locationName;
    newLocation.iconName = @"sd_custom";
    newLocation.builtin = NO;
    newLocation.color = SD_THEME_COLOR;
    NSInteger maxIndex = [[self.db getOneValueOnResult:SDLocation.sortIndex.count() fromTable:self.tableName]integerValue];
    newLocation.sortIndex = maxIndex + 1;

    NSString *roomIDstr = SDno2Str(roomID);
    if (self.maps[roomIDstr][locationName] == nil) {
        [self.db insertObject:newLocation into:self.tableName];

        [self.lists[roomIDstr] addObject:newLocation];
        self.maps[roomIDstr][locationName] = newLocation;

        return YES;
    } else {
        return NO;
    }
}

- (NSArray<SDLocation *> *)fetchCustomLocation {
    NSArray *res;
    res = [self.db getObjectsOfClass:SDLocation.class fromTable:self.tableName where:SDLocation.builtin == NO];
    return res;
}

- (void)setupDefaultLocationInCustomRoom:(NSInteger)roomID type:(RoomType)type {
    NSString *plistFile = [[NSBundle mainBundle]pathForResource:@"Location" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc ]initWithContentsOfFile:plistFile];
//    NSString *version = dict[@"version"];
//    NSString *orderVersion = [KeyValueStore stringForKey:keyLocationVersion];
    NSString *key;
    switch (type) {
        case RoomTypeBed:
            key = @"bed";
            break;
        case RoomTypeWork:
            key = @"work";
            break;
        case RoomTypeStorge:
            key = @"storage";
            break;
        case RoomTypeStudy:
            key = @"study";
            break;
        case RoomTypeCustom:
            key = @"custom";
            break;
        default:
            break;
    }
    [self insertAllWithPlistDict:dict key:key roomID:roomID];
}

#pragma mark -
#pragma mark private method

- (void)insertAllWithPlistDict:(NSDictionary *)dict key:(NSString *)key roomID:(NSInteger)roomID {
    NSArray *list = dict[key];

    //    使用内建列表
    //    insertAllWithBuiltinList
    if (!list) {
        list = self.builtinList;
    }
    NSMutableArray *newLocationArr = [[NSMutableArray alloc]initWithCapacity:60];
    NSMutableDictionary *newLocationDic = [[NSMutableDictionary alloc]initWithCapacity:60];

    [list enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *_Nonnull stop) {
        SDLocation *location = [SDLocation yy_modelWithDictionary:dict];
        location.isAutoIncrement = YES;
        location.roomID = roomID;

        if (location) {
            [newLocationArr addObject:location];
            newLocationDic[location.name] = location;
        }
    }];
    self.lists[SDno2Str(roomID)] = newLocationArr;
    self.maps[SDno2Str(roomID)] = newLocationDic;
    [self.db insertObjects:newLocationArr into:self.tableName];
}

- (void)setup {
    BOOL haveCache = [[self.db getOneValueOnResult:SDLocation.locationID.count() fromTable:self.tableName]unsignedIntegerValue] > 0;

    if (haveCache) {
        [SDRoomService.service.roomLists enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSArray<SDRoom *> *_Nonnull roomArr, BOOL *_Nonnull stop) {
            [roomArr enumerateObjectsUsingBlock:^(SDRoom *_Nonnull room, NSUInteger idx, BOOL *_Nonnull stop) {
                NSArray<SDLocation *> *res = [self.db getObjectsOfClass:SDLocation.class
                                                              fromTable:self.tableName
                                                                  where:SDLocation.roomID == room.roomID];
                self.lists[SDno2Str(room.roomID)] = res.mutableCopy;
                NSMutableDictionary *map = [[NSMutableDictionary alloc]initWithCapacity:res.count];
                [res enumerateObjectsUsingBlock:^(SDLocation *_Nonnull location, NSUInteger idx, BOOL *_Nonnull stop) {
                    map[location.name] = location;
                }];
                self.maps[SDno2Str(room.roomID)] = map;
            }];
        }];

        DDLogInfo(@"[Location service]: load location data from cache");
    }

    NSString *defaultLocationKey = [KeyValueStore stringForKey:keyDefaultLocation];
    NSArray *defaultLocationKeys = [defaultLocationKey componentsSeparatedByString:@"_"];

    if (defaultLocationKeys.count == 2) {
        self.defaultLocation = self.maps[defaultLocationKeys[0]][defaultLocationKeys[1]];
    } else {
        NSString *key = SDno2Str(SDRoomService.service.defaultRoom.roomID);
        SDLocation *defaultLocation = [self.lists[key] firstObject];
        [self configDefaultLocationWithName:defaultLocation.name roomID:defaultLocation.roomID];
    }
}

//- (BOOL)isBetaVersion:(NSString *)version {
//    float v = version.floatValue;
//    return v < 1.0;
//}

- (NSArray *)builtinListNames {
    return @[@"默认位置"];
}

- (NSArray *)builtinList {
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:5];
    [[self builtinListNames] enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        dict[@"name"] = obj;
        dict[@"iconName"] = self.builtinListIcons[idx];
        dict[@"color"] = self.builtinListColors[idx];
        dict[@"builtin"] = @YES;
        [list addObject:dict.copy];
    }];
    return list.copy;
}

- (void)onDefaultRoomChanged:(NSNotification *)notification {
    if ([notification.object isKindOfClass:NSNumber.class]) {
        NSInteger newDefaultRoomID = [notification.object integerValue];
        SDLocation *location = [self.lists[SDno2Str(newDefaultRoomID)] firstObject];
        [self configDefaultLocationWithName:location.name roomID:newDefaultRoomID];
    }
}

- (void)onRoomDeleted:(NSNotification *)notification {
    if ([notification.object isKindOfClass:NSNumber.class]) {
        NSInteger deletedRoomID = [notification.object integerValue];
        NSString *key = SDno2Str(deletedRoomID);
        [self.lists[key] enumerateObjectsUsingBlock:^(SDLocation *_Nonnull location, NSUInteger idx, BOOL *_Nonnull stop) {
            [self deleteLocationWithName:location.name
                                  roomID:deletedRoomID];
        }];
        [self.lists removeObjectForKey:key];
        [self.maps removeObjectForKey:key];
    }
}

#pragma mark -
#pragma mark private property
- (NSString *)tableName {
    return @"location";
}

#pragma mark -
#pragma mark property

- (NSDictionary<NSString *, NSArray<SDLocation *> *> *)locationLists {
    NSMutableDictionary *res = [[NSMutableDictionary alloc]initWithCapacity:self.lists.count];
    [self.lists enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSMutableArray<SDLocation *> *_Nonnull locationArr, BOOL *_Nonnull stop) {
        res[key] = locationArr.copy;
    }];

    return res.copy;
}

@end
