//
//  SDAddressService.m
//  SDaccount
//
//  Created by SunLi on 2019/11/2.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDDBManager.h"
#import "SDAddressService.h"
#import "SDAddress+WCTTableCoding.h"
#import "SDRoomService.h"
#import "SDRoom+WCTTableCoding.h"

static NSString *const keyAddressVersion = @"address_version";
static NSString *const keyDefaultAddress = @"defaultAddress";

@interface SDAddressService ()

@property (nonatomic, strong) NSString *tableName;
@property (nonatomic, strong) WCTDatabase *db;
@property (nonatomic, strong) NSMutableArray<SDAddress *> *list;
@property (nonatomic, strong) NSMutableDictionary<NSString *, SDAddress *> *map;

- (void)insertAllWithPlistDict:(NSDictionary *)dict key:(NSString *)key;
- (void)setup;
//- (BOOL)isBetaVersion:(NSString *)version;

//- (NSArray *)builtinListColors;
//- (NSArray *)builtinListIcons;
- (NSArray *)builtinListNames;
- (NSArray *)builtinList;

@end

@implementation SDAddressService

+ (instancetype)service {
    static SDAddressService *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SDAddressService alloc]init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _list = [[NSMutableArray alloc]initWithCapacity:15];
        _map = [[NSMutableDictionary alloc]initWithCapacity:15];

        _db = DBManager.database;
        [_db createTableAndIndexesOfName:self.tableName withClass:[SDAddress class]];
        [self setup];
    }
    return self;
}

- (void)configDefaultAddressWithName:(NSString *)addressName {
    if (addressName != self.defaultAddress.name) {
        NSString *key = [NSString stringWithFormat:@"%@", addressName];
        self.defaultAddress = self.map[key];
        [KeyValueStore setValue:addressName forKey:keyDefaultAddress];
        [[NSNotificationCenter defaultCenter]postNotificationName:SDDefaultAddressChangedNotification object:@(self.defaultAddress.addressID)];
    }
}

- (NSArray<NSString *> *)nameList {
    NSMutableArray *nameList = [NSMutableArray arrayWithCapacity:self.addressList.count];
    [self.addressList enumerateObjectsUsingBlock:^(SDAddress *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [nameList addObject:obj.name];
    }];
    return nameList.copy;
}

- (NSArray *)builtinListColors {
    return @[UIColorMakeWithHex(@"#f06292"), UIColorMakeWithHex(@"#ffee58"), UIColorMakeWithHex(@"#66bb6a"), UIColorMakeWithHex(@"#4fc3f7")];
}

- (NSArray *)builtinListIcons {
    return @[@"icon_address_home", @"icon_address_corporation", @"icon_address_storage", @"icon_address_custom"];
}

- (SDAddress *)queryAddressWithName:(NSString *)addressName {
    NSParameterAssert(addressName);
    return self.map[addressName];
}

- (BOOL)renameAddressWithName:(NSString *)addressName newName:(NSString *)newAddressName {
    SDAddress *address = [self queryAddressWithName:addressName];
    if (self.map[addressName] != nil && self.map[newAddressName] == nil) {
        address.name = newAddressName;
        self.map[newAddressName] = address;
        [self.map removeObjectForKey:addressName];
        [self.db updateRowsInTable:self.tableName onProperty:SDAddress.name withObject:address where:SDAddress.name == addressName];
//        NSPredicate *predcate = [NSPredicate predicateWithFormat:@"name == %@", addressName];
//        NSArray*filterArr= [self.list filteredArrayUsingPredicate:predcate];
        for (SDAddress *address in self.list) {
            if (address.name == addressName) {
                address.name = newAddressName;
                break;
            }
        }
//        rename default
        if (self.defaultAddress.addressID == address.addressID) {
            [KeyValueStore setValue:newAddressName forKey:keyDefaultAddress];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:SDAddressRenamedNotification object:@(address.addressID)];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)deleteAddressWithName:(NSString *)addressName {
    SDAddress *address = [self queryAddressWithName:addressName];
    if (self.map[addressName]) {
        [self.map removeObjectForKey:addressName];
        [self.list removeObject:address];
        [self.db deleteObjectsFromTable:self.tableName where:SDAddress.name == addressName];
//        NSArray*res = [self.db getAllObjectsOfClass:SDAddress.class fromTable:self.tableName];
//        [self.list removeAllObjects];
//        [self.list addObjectsFromArray:res];
        [[NSNotificationCenter defaultCenter]postNotificationName:SDAddressDeletedNotification object:@(address.addressID)];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)addCustomAddressWithName:(NSString *)addressName {
    SDAddress *newAddress = [[SDAddress alloc]init];
    newAddress.isAutoIncrement = YES;
    newAddress.name = addressName;
    newAddress.iconName = @"sd_custom";
    newAddress.builtin = NO;
    newAddress.color = SD_THEME_COLOR;
    NSInteger maxIndex = [[self.db getOneValueOnResult:SDAddress.sortIndex.count() fromTable:self.tableName]integerValue];
    newAddress.sortIndex = maxIndex + 1;
    if (self.map[addressName] == nil) {
        [self.db insertObject:newAddress into:self.tableName];

        [self.list addObject:newAddress];
        self.map[addressName] = newAddress;

        //    NSInteger addressID = [[self.db getOneValueOnResult:SDAddress.addressID fromTable:self.tableName where:SDAddress.name == newAddress.name ]integerValue];
        [SDRoomService.service setupDefaultRoomsInCustomAddress:newAddress.addressID type:AddressTypeCustom];
        return YES;
    } else {
        return NO;
    }
}

- (NSArray<SDAddress *> *)fetchCustomAddress {
    NSArray *res;
    res = [self.db getObjectsOfClass:SDAddress.class fromTable:self.tableName where:SDAddress.builtin == NO];
    return res;
}

#pragma mark -
#pragma mark private method
- (void)insertAllWithPlistDict:(NSDictionary *)dict key:(NSString *)key {
    NSArray *list = dict[key];

//    使用内建列表
//    insertAllWithBuiltinList
    if (!list) {
        list = self.builtinList;
    }

    [list enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *_Nonnull stop) {
        SDAddress *address = [SDAddress yy_modelWithDictionary:dict];
        address.isAutoIncrement = YES;
        if (address) {
            [self.list addObject:address];
            self.map[address.name] = address;

            AddressType type;
            if (SDIsEqualString(address.name, @"home")) {
                type = AddressTypeHome;
            } else if (SDIsEqualString(address.name, @"corporation")) {
                type = AddressTypeCorporation;
            } else if (SDIsEqualString(address.name, @"storage")) {
                type = AddressTypeStrorage;
            } else {
                type = AddressTypeCustom;
            }
            [SDRoomService.service setupDefaultRoomsInCustomAddress:address.addressID
                                                               type:type];
        }
    }];
    [self.db insertObjects:self.list into:self.tableName];
}

- (void)setup {
    BOOL haveCache = [[self.db getOneValueOnResult:SDAddress.addressID.count() fromTable:self.tableName]unsignedIntegerValue] > 0;
    NSString *plistFile = [[NSBundle mainBundle]pathForResource:@"Address" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:plistFile];
//    NSString *version = dict[@"version"];
//    NSString *orderVersion = [KeyValueStore stringForKey:keyAddressVersion];

    if (!haveCache) {
        [self insertAllWithPlistDict:dict key:@"list"];
        DDLogInfo(@"[Address service]: insert address data");
//        [KeyValueStore setString:version forKey:keyAddressVersion];
//    } else if (!SDIsEqualString(version, orderVersion)) {
//        DDLogInfo(@"[Address service]: update address data");
//        if ([self isBetaVersion:orderVersion]) {
//            [self.db deleteAllObjectsFromTable:self.tableName];
//            [self insertAllWithPlistDict:dict key:@"list"];
//        }
//        [KeyValueStore setString:version forKey:keyAddressVersion];
    } else {
        WCTSelect *select = [self.db prepareSelectObjectsOfClass:SDAddress.class fromTable:self.tableName];
        NSArray<SDAddress *> *res = select.allObjects;
        [self.list addObjectsFromArray:res];
        [res enumerateObjectsUsingBlock:^(SDAddress *address, NSUInteger idx, BOOL *_Nonnull stop) {
            self.map[address.name] = address;
        }];
        DDLogInfo(@"[Address service]: load address address from cache");
    }

    NSString *defaultAddressName = [KeyValueStore valueForKey:keyDefaultAddress];
    if (defaultAddressName) {
        self.defaultAddress = self.map[defaultAddressName];
    } else {
        SDAddress *defaultAddress = [self.addressList firstObject];
        [self configDefaultAddressWithName:defaultAddress.name];
    }
}

//- (BOOL)isBetaVersion:(NSString *)version {
//    float v = version.floatValue;
//    return v < 1.0;
//}

- (NSArray *)builtinListNames {
    return @[@"住宅", @"公司", @"仓库"];
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

#pragma mark -
#pragma mark private property

- (NSString *)tableName {
    return @"address";
}

#pragma mark -
#pragma mark property

- (NSArray<SDAddress *> *)addressList {
    return self.list.copy;
}

@end
