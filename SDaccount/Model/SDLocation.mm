//
//  SDLocation.m
//  SDaccount
//
//  Created by SunLi on 2019/10/4.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDLocation.h"
#import <WCDB/WCDB.h>

@interface SDLocation () <WCTTableCoding, YYModel>

@end

@implementation SDLocation

WCDB_IMPLEMENTATION(SDLocation)

WCDB_SYNTHESIZE(SDLocation, locationID)
WCDB_SYNTHESIZE(SDLocation, roomID)
WCDB_SYNTHESIZE(SDLocation, name)
WCDB_SYNTHESIZE(SDLocation, iconName)
WCDB_SYNTHESIZE(SDLocation, builtin)
WCDB_SYNTHESIZE(SDLocation, sortIndex)
WCDB_SYNTHESIZE(SDLocation, color)

WCDB_PRIMARY_AUTO_INCREMENT(SDLocation, locationID)

#pragma mark -
#pragma mark YYModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"sortIndex": @"index" };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *indexNum = dic[@"index"];
    if (![indexNum isKindOfClass:[NSNumber class]]) {
        return NO;
    }
    self.sortIndex = [indexNum integerValue];
    return YES;
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    dic[@"index"] = @(self.sortIndex);
    return YES;
}

@end
