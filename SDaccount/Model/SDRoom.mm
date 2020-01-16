//
//  SDRoom.m
//  SDaccount
//
//  Created by SunLi on 2019/10/31.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDRoom.h"
#import <WCDB/WCDB.h>

@interface SDRoom () <WCTTableCoding, YYModel>

@end

@implementation SDRoom

WCDB_IMPLEMENTATION(SDRoom)

WCDB_SYNTHESIZE(SDRoom, roomID)
WCDB_SYNTHESIZE(SDRoom, addressID)
WCDB_SYNTHESIZE(SDRoom, name)
WCDB_SYNTHESIZE(SDRoom, iconName)
WCDB_SYNTHESIZE(SDRoom, builtin)
WCDB_SYNTHESIZE(SDRoom, sortIndex)
WCDB_SYNTHESIZE(SDRoom, color)

WCDB_PRIMARY_AUTO_INCREMENT(SDRoom, roomID)

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
