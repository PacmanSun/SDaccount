//
//  SDLocationService.h
//  SDaccount
//
//  Created by SunLi on 2019/10/4.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLocation.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSUInteger, RoomType) {
    RoomTypeBed,
    RoomTypeWork,
    RoomTypeStorge,
    RoomTypeStudy,
    RoomTypeCustom
};

@interface SDLocationService : NSObject

@property (nonatomic, strong, readonly) NSDictionary< NSString *, NSArray<SDLocation *> *> *locationLists;
@property (nonatomic, strong) SDLocation *defaultLocation;

+ (instancetype)service;

- (void)configDefaultLocationWithName:(NSString *)locationName roomID:(NSInteger)roomID;//

- (NSDictionary<NSString *, NSArray<NSString *> *> *)nameLists;

- (NSArray *)builtinListColors;
- (NSArray *)builtinListIcons;

- (SDLocation *)queryLocationWithName:(NSString *)locationName;//
- (SDLocation *)queryLocationWithName:(NSString *)locationName roomID:(NSInteger)roomID;//
- (BOOL)renameLocationWithName:(NSString *)locationName newName:(NSString *)newLocationName roomID:(NSInteger)roomID;//
- (BOOL)deleteLocationWithName:(NSString *)locationName roomID:(NSInteger)roomID;//
- (BOOL)addCustomLocationWithName:(NSString *)locationName inRoom:(NSInteger)roomID;
- (NSArray<SDLocation *> *)fetchCustomLocation;
- (void)setupDefaultLocationInCustomRoom:(NSInteger)roomID type:(RoomType)type;

@end

NS_ASSUME_NONNULL_END
