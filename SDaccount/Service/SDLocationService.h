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

@interface SDLocationService : NSObject

@property (nonatomic, strong, readonly) NSArray<SDLocation *> *locationList;

+ (instancetype)service;

- (SDLocation *)queryLocationWithName:(NSString *)locationName;
- (void)addCustomLocationWithName:(NSString *)locationName;
- (NSArray<SDLocation *> *)fetchCustomLocation;

@end

NS_ASSUME_NONNULL_END
