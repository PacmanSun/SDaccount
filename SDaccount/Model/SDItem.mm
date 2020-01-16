//
//  SDItem.m
//  SDaccount
//
//  Created by SunLi on 2019/10/4.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDItem.h"
#import <WCDB/WCDB.h>

@interface SDItem () <WCTTableCoding,YYModel>

@end

@implementation SDItem

WCDB_IMPLEMENTATION(SDItem)

WCDB_SYNTHESIZE(SDItem, itemID)
WCDB_SYNTHESIZE(SDItem, categoryID)
WCDB_SYNTHESIZE(SDItem, locationID)
WCDB_SYNTHESIZE(SDItem, sortIndex)
WCDB_SYNTHESIZE(SDItem, name)

WCDB_PRIMARY_AUTO_INCREMENT(SDItem, itemID)

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
