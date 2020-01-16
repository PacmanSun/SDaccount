//
//  SDAddressService.h
//  SDaccount
//
//  Created by SunLi on 2019/11/2.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDAddress.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDAddressService : NSObject

@property (nonatomic, strong, readonly) NSArray<SDAddress *> *addressList;
@property (nonatomic, strong) SDAddress *defaultAddress;

+ (instancetype)service;

- (void)configDefaultAddressWithName:(NSString *)addressName;

- (NSArray<NSString *> *)nameList;

- (NSArray *)builtinListColors;
- (NSArray *)builtinListIcons;

- (SDAddress *)queryAddressWithName:(NSString *)addressName;
- (BOOL)renameAddressWithName:(NSString *)addressName newName:(NSString *)newAddressName;
- (BOOL)deleteAddressWithName:(NSString *)addressName;
- (BOOL)addCustomAddressWithName:(NSString *)addressName;
- (NSArray<SDAddress *> *)fetchCustomAddress;

@end

NS_ASSUME_NONNULL_END
