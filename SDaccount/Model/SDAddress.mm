//
//  SDAddress.m
//  SDaccount
//
//  Created by SunLi on 2019/11/1.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDAddress.h"
#import <WCDB/WCDB.h>

@interface SDAddress () <WCTTableCoding, YYModel>

@end

@implementation SDAddress

WCDB_IMPLEMENTATION(SDAddress)

WCDB_SYNTHESIZE(SDAddress, addressID)
WCDB_SYNTHESIZE(SDAddress, name)
WCDB_SYNTHESIZE(SDAddress, iconName)
WCDB_SYNTHESIZE(SDAddress, builtin)
WCDB_SYNTHESIZE(SDAddress, sortIndex)
WCDB_SYNTHESIZE(SDAddress, color)

WCDB_PRIMARY_AUTO_INCREMENT(SDAddress, addressID)

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
