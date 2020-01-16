//
//  SDRoomService.m
//  SDaccount
//
//  Created by SunLi on 2019/11/2.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDDBManager.h"
#import "SDRoomService.h"
#import "SDRoom+WCTTableCoding.h"
#import "SDLocationService.h"
#import "SDLocation+WCTTableCoding.h"
#import "SDAddressService.h"
#import "SDAddress+WCTTableCoding.h"

static NSString *const keyRoomVersion = @"room_version";
static NSString *const keyDefaultRoom = @"defaultRoom";

@interface SDRoomService ()

@property (nonatomic, strong) NSString *tableName;
@property (nonatomic, strong) WCTDatabase *db;
//dict的key为“addressID”string
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<SDRoom *> *> *lists;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, SDRoom *> *> *maps;

- (void)insertAllWithPlistDict:(NSDictionary *)dict key:(NSString *)key addressID:(NSInteger)addressID;
- (void)setup;
//- (BOOL)isBetaVersion:(NSString *)version;

//- (NSArray *)builtinListColors;
//- (NSArray *)builtinListIcons;
- (NSArray *)builtinListNames;
- (NSArray *)builtinList;

- (void)onDefaultAddressChanged:(NSNotification *)notification;
- (void)onAddressDeleted:(NSNotification *)notification;
@end

@implementation SDRoomService

+ (instancetype)service {
    static SDRoomService *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SDRoomService alloc]init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lists = [[NSMutableDictionary alloc]initWithCapacity:SDAddressService.service.addressList.count];
        _maps = [[NSMutableDictionary alloc]initWithCapacity:SDAddressService.service.addressList.count];

        _db = DBManager.database;

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onDefaultAddressChanged:) name:SDDefaultAddressChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onAddressDeleted:) name:SDAddressDeletedNotification object:nil];
        [self setup];
    }
    return self;
}

- (void)configDefaultRoomWithName:(NSString *)roomName addressID:(NSInteger)addressID {
    if (roomName != self.defaultRoom.name || addressID != self.defaultRoom.addressID) {
        NSString *key = [NSString stringWithFormat:@"%ld_%@", addressID, roomName];
        self.defaultRoom = self.maps[SDno2Str(addressID)][roomName];
        [KeyValueStore setValue:key forKey:keyDefaultRoom];
        [[NSNotificationCenter defaultCenter]postNotificationName:SDDefaultRoomChangedNotification object:@(self.defaultRoom.roomID)];
    }
}

- (NSDictionary<NSString *, NSArray<NSString *> *> *)nameLists {
    NSMutableDictionary *lists = [NSMutableDictionary dictionaryWithCapacity:self.lists.count];
    [SDAddressService.service.addressList enumerateObjectsUsingBlock:^(SDAddress *_Nonnull address, NSUInteger idx, BOOL *_Nonnull stop) {
        NSMutableArray *nameList = [NSMutableArray arrayWithCapacity:self.roomLists[SDno2Str(address.addressID)].count];

        [self.roomLists[SDno2Str(address.addressID)] enumerateObjectsUsingBlock:^(SDRoom *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [nameList addObject:obj.name];
        }];

        lists[SDno2Str(address.addressID)] = nameList.copy;
    }];

    return lists.copy;
}

- (NSArray *)builtinListColors {
    return @[UIColorMakeWithHex(@"#f0ee92"), UIColorMakeWithHex(@"#ffbb58"), UIColorMakeWithHex(@"#66c36a"), UIColorMakeWithHex(@"#4f62f7"), UIColorMakeWithHex(@"#6fbe52")];
}

- (NSArray *)builtinListIcons {
    return @[@"icon_room_bed", @"icon_room_work", @"icon_room_storage", @"icon_room_study", @"icon_room_custom"];
}

- (NSArray<SDRoom *> *)queryRoomWithName:(NSString *)roomName {
    NSParameterAssert(roomName);
    NSMutableArray< NSString *> *addressIDstrs = [[NSMutableArray alloc]initWithCapacity:self.lists.count];
    [[[SDAddressService service]addressList]enumerateObjectsUsingBlock:^(SDAddress *_Nonnull address, NSUInteger idx, BOOL *_Nonnull stop) {
        [addressIDstrs addObject:SDno2Str(address.addressID)];
    }];
    NSMutableArray<SDRoom *> *res = [[NSMutableArray alloc]initWithCapacity:self.lists.count];
    for (NSString *addressIDstr in addressIDstrs) {
        if (self.maps[addressIDstr][roomName]) {
            [res addObject:self.maps[addressIDstr][roomName]];
        }
    }
    return res.copy;
}

- (SDRoom *)queryRoomWithName:(NSString *)roomName addressID:(NSInteger)addressID {
    NSParameterAssert(roomName);
    return self.maps[SDno2Str(addressID)][roomName];
}

- (BOOL)renameRoomWithName:(NSString *)roomName newName:(NSString *)newRoomName addressID:(NSInteger)addressID {
    SDRoom *room = [self queryRoomWithName:roomName addressID:addressID];
    NSString *addressIDstr = SDno2Str(addressID);

    if (self.maps[addressIDstr][roomName] != nil && self.maps[addressIDstr][newRoomName] == nil) {
        room.name = newRoomName;
        self.maps[addressIDstr][newRoomName] = room;
        [self.maps[addressIDstr] removeObjectForKey:roomName];
        [self.db updateRowsInTable:self.tableName onProperties:SDRoom.name withObject:room where:SDRoom.name == roomName];

        for (SDRoom *room in self.lists[addressIDstr]) {
            if (room.name == roomName) {
                room.name = newRoomName;
                break;
            }
        }
//        rename default
        if (self.defaultRoom.roomID == room.roomID) {
            NSString *key = [NSString stringWithFormat:@"%ld_%@", addressID, newRoomName];
            [KeyValueStore setValue:key forKey:keyDefaultRoom];
        }

        [[NSNotificationCenter defaultCenter]postNotificationName:SDRoomRenamedNotification object:@(room.roomID)];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)deleteRoomWithName:(NSString *)roomName addressID:(NSInteger)addressID {
    SDRoom *room = [self queryRoomWithName:roomName addressID:addressID];
    NSString *addressIDstr = SDno2Str(addressID);
    if (self.maps[addressIDstr][roomName]) {
        [self.maps[addressIDstr] removeObjectForKey:roomName];
        [self.lists[addressIDstr] removeObject:room];
        [self.db deleteObjectsFromTable:self.tableName where:SDRoom.name == roomName];

        [[NSNotificationCenter defaultCenter]postNotificationName:SDRoomDeletedNotification object:@(room.roomID)];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)addCustomRoomWithName:(NSString *)roomName atAddress:(NSInteger)addressID {
    SDRoom *newRoom = [[SDRoom alloc]init];
    newRoom.isAutoIncrement = YES;
    newRoom.name = roomName;
    newRoom.iconName = @"sd_custom";
    newRoom.builtin = NO;
    newRoom.color = SD_THEME_COLOR;
    newRoom.addressID = addressID;
    NSInteger maxIndex = [[self.db getOneValueOnResult:SDRoom.sortIndex.count() fromTable:self.tableName]integerValue];
    newRoom.sortIndex = maxIndex + 1;

    NSString *addressIDstr = SDno2Str(addressID);
    if (self.maps[addressIDstr][roomName] == nil) {
        [self.db insertObject:newRoom into:self.tableName];

        [self.lists[addressIDstr] addObject:newRoom];
        self.maps[addressIDstr][roomName] = newRoom;

        [SDLocationService.service setupDefaultLocationInCustomRoom:newRoom.roomID type:RoomTypeCustom];
        return YES;
    } else {
        return NO;
    }
}

- (NSArray<SDRoom *> *)fetchCustomRoom {
    NSArray *res;
    res = [self.db getObjectsOfClass:SDRoom.class fromTable:self.tableName where:SDRoom.builtin == NO];
    return res;
}

- (void)setupDefaultRoomsInCustomAddress:(NSInteger)addressID type:(AddressType)type {
    NSString *plistFile = [[NSBundle mainBundle]pathForResource:@"Room" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:plistFile];
//    NSString *version = dict[@"version"];
//    NSString *orderVersion = [KeyValueStore stringForKey:keyRoomVersion];
    NSString *key;
    switch (type) {
        case AddressTypeHome:
            key = @"home";
            break;
        case AddressTypeCorporation:
            key = @"corporation";
            break;
        case AddressTypeStrorage:
            key = @"storage";
            break;
        case AddressTypeCustom:
            key = @"custom";
            break;
        default:
            break;
    }
    [self insertAllWithPlistDict:dict key:key addressID:addressID];
}

#pragma mark -
#pragma mark private method
- (void)insertAllWithPlistDict:(NSDictionary *)dict key:(NSString *)key addressID:(NSInteger)addressID {
    NSArray *list = dict[key];

    //    使用内建列表
    //    insertAllWithBuiltinList
    if (!list) {
        list = self.builtinList;
    }

    NSMutableArray *newRoomArr = [[NSMutableArray alloc]initWithCapacity:50];
    NSMutableDictionary *newRoomDic = [[NSMutableDictionary alloc]initWithCapacity:50];

    [list enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *_Nonnull stop) {
        SDRoom *room = [SDRoom yy_modelWithDictionary:dict];
        room.isAutoIncrement = YES;
        room.addressID = addressID;

        if (room) {
            [newRoomArr addObject:room];
            newRoomDic[room.name] = room;

            RoomType type;

            if (SDIsEqualString(room.name, @"bed")) {
                type = RoomTypeBed;
            } else if (SDIsEqualString(room.name, @"work")) {
                type = RoomTypeWork;
            } else if (SDIsEqualString(room.name, @"stroage")) {
                type = RoomTypeStorge;
            } else if (SDIsEqualString(room.name, @"study")) {
                type = RoomTypeStudy;
            } else {
                type = RoomTypeCustom;
            }

            [SDLocationService.service setupDefaultLocationInCustomRoom:room.roomID
                                                                   type:type];
        }
    }];
    self.lists[SDno2Str(addressID)] = newRoomArr;
    self.maps[SDno2Str(addressID)] = newRoomDic;
    [self.db insertObjects:newRoomArr into:self.tableName];
}

- (void)setup {
    BOOL haveCache = [[self.db getOneValueOnResult:SDRoom.roomID.count() fromTable:self.tableName]unsignedIntegerValue] > 0;
    if (haveCache) {
        [SDAddressService.service.addressList enumerateObjectsUsingBlock:^(SDAddress *_Nonnull address, NSUInteger idx, BOOL *_Nonnull stop) {
            //        WCTSelect *select = [self.db prepareSelectObjectsOfClass:SDRoom.class
            //                                                       fromTable:self.tableName];
            //        NSMutableArray *res = select.allObjects.mutableCopy;
            NSArray<SDRoom *> *res = [self.db getObjectsOfClass:SDRoom.class
                                                      fromTable:self.tableName
                                                          where:SDRoom.addressID == address.addressID];
            self.lists[SDno2Str(address.addressID)] = res.mutableCopy;
            NSMutableDictionary *map = [[NSMutableDictionary alloc]initWithCapacity:res.count];
            [res enumerateObjectsUsingBlock:^(SDRoom *_Nonnull room, NSUInteger idx, BOOL *_Nonnull stop) {
                map[room.name] = room;
            }];
            self.maps[SDno2Str(address.addressID)] = map;
        }];

        DDLogInfo(@"[Room service]: load room data from cache");
    }

    NSString *defaultRoomKey = [KeyValueStore valueForKey:keyDefaultRoom];
    NSArray *defaultRoomKeys = [defaultRoomKey componentsSeparatedByString:@"_"];

    if (defaultRoomKeys.count == 2) {
        self.defaultRoom = self.maps[defaultRoomKeys[0]][defaultRoomKeys[1]];
    } else {
        NSString *key = SDno2Str(SDAddressService.service.defaultAddress.addressID);
        SDRoom *defaultRoom = [self.lists[key] firstObject];
        [self configDefaultRoomWithName:defaultRoom.name addressID:defaultRoom.addressID];
    }
}

//- (BOOL)isBetaVersion:(NSString *)version {
//    float v = version.floatValue;
//    return v < 1.0;
//}

- (NSArray *)builtinListNames {
    return @[@"卧室", @"工作间", @"书房", @"储藏室"];
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

- (void)onDefaultAddressChanged:(NSNotification *)notification {
    if ([notification.object isKindOfClass:NSNumber.class]) {
        NSInteger newDefaultAddressID = [notification.object integerValue];
        SDRoom *room = [self.lists[SDno2Str(newDefaultAddressID)] firstObject];
        [self configDefaultRoomWithName:room.name addressID:newDefaultAddressID];
    }
}

- (void)onAddressDeleted:(NSNotification *)notification {
    if ([notification.object isKindOfClass:NSNumber.class]) {
        NSInteger deletedAddressID = [notification.object integerValue];
        NSString *key = SDno2Str(deletedAddressID);
        [self.lists[key] enumerateObjectsUsingBlock:^(SDRoom *_Nonnull room, NSUInteger idx, BOOL *_Nonnull stop) {
            [self deleteRoomWithName:room.name
                           addressID:deletedAddressID];
        }];
        [self.lists removeObjectForKey:key];
        [self.maps removeObjectForKey:key];
    }
}

#pragma mark -
#pragma mark private property
- (NSString *)tableName {
    return @"room";
}

#pragma mark -
#pragma mark property

- (NSDictionary< NSString *, NSArray<SDRoom *> *> *)roomLists {
    NSMutableDictionary *res = [[NSMutableDictionary alloc]initWithCapacity:self.lists.count];
    [self.lists enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSMutableArray<SDRoom *> *_Nonnull roomArr, BOOL *_Nonnull stop) {
        res[key] = roomArr.copy;
    }];
    return res.copy;
}

@end
