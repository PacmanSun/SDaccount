//
//  SDRoomService.h
//  SDaccount
//
//  Created by SunLi on 2019/11/2.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDRoom.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSUInteger, AddressType) {
    AddressTypeHome,
    AddressTypeCorporation,
    AddressTypeStrorage,
    AddressTypeCustom
};

@interface SDRoomService : NSObject

@property (nonatomic, strong, readonly) NSDictionary< NSString *, NSArray<SDRoom *> *> *roomLists;
@property (nonatomic, strong) SDRoom *defaultRoom;

+ (instancetype)service;

- (void)configDefaultRoomWithName:(NSString *)roomName addressID:(NSInteger)addressID;

- (NSDictionary<NSString *, NSArray<NSString *> *> *)nameLists;

- (NSArray *)builtinListColors;
- (NSArray *)builtinListIcons;

- (NSArray<SDRoom *> *)queryRoomWithName:(NSString *)roomName;
- (SDRoom *)queryRoomWithName:(NSString *)roomName addressID:(NSInteger)addressID;
- (BOOL)renameRoomWithName:(NSString *)roomName newName:(NSString *)newRoomName addressID:(NSInteger)addressID;
- (BOOL)deleteRoomWithName:(NSString *)roomName addressID:(NSInteger)addressID;
- (BOOL)addCustomRoomWithName:(NSString *)roomName atAddress:(NSInteger)addressID;
- (NSArray<SDRoom *> *)fetchCustomRoom;
- (void)setupDefaultRoomsInCustomAddress:(NSInteger)addressID type:(AddressType)type;

@end

NS_ASSUME_NONNULL_END
