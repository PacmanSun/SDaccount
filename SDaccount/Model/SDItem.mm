//
//  SDItem.m
//  SDaccount
//
//  Created by SunLi on 2019/10/4.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDItem.h"
#import <WCDB/WCDB.h>

@interface SDItem () <WCTTableCoding>

+ (NSDictionary *)modelCustomPropertyMapper;
- (BOOL)modelCustomTransformFromDict:(NSDictionary *)dict;
- (BOOL)modelCustomTransformToDict:(NSMutableDictionary *)dict;

@end

@implementation SDItem

WCDB_IMPLEMENTATION(SDItem)

WCDB_SYNTHESIZE(SDItem, itemID)
WCDB_SYNTHESIZE(SDItem, category)
WCDB_SYNTHESIZE(SDItem, location)
WCDB_SYNTHESIZE(SDItem, sortIndex)
WCDB_SYNTHESIZE(SDItem, name)

WCDB_PRIMARY_AUTO_INCREMENT(SDItem, itemID)

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
