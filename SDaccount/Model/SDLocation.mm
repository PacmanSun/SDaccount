//
//  SDLocation.m
//  SDaccount
//
//  Created by SunLi on 2019/10/4.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDLocation.h"
#import <WCDB/WCDB.h>

@interface SDLocation () <WCTTableCoding>

+ (NSDictionary *)modelCustomPropertyMapper;
- (BOOL)modelCustomTransformFromDict:(NSDictionary *)dict;
- (BOOL)modelCustomTransformToDict:(NSMutableDictionary *)dict;

@end

@implementation SDLocation

WCDB_IMPLEMENTATION(SDLocation)

WCDB_SYNTHESIZE(SDLocation, locationID)
WCDB_SYNTHESIZE(SDLocation, name)
WCDB_SYNTHESIZE(SDLocation, iconName)
WCDB_SYNTHESIZE(SDLocation, builtin)
WCDB_SYNTHESIZE(SDLocation, sortIndex)
WCDB_SYNTHESIZE(SDLocation, color)

WCDB_PRIMARY_AUTO_INCREMENT(SDLocation, locationID)

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"sortIndex": @"index" };
}

- (BOOL)modelCustomTransformFromDict:(NSDictionary *)dict {
    NSNumber *indexNum = dict[@"index"];
    if (![indexNum isKindOfClass:[NSNumber class]]) {
        return NO;
    }
    self.sortIndex = [indexNum integerValue];
    return YES;
}

- (BOOL)modelCustomTransformToDict:(NSMutableDictionary *)dict {
    dict[@"index"] = @(self.sortIndex);
    return YES;
}

@end
