//
//  SDCategory.m
//  SDaccount
//
//  Created by SunLi on 2019/9/29.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDCategory.h"
#import <WCDB/WCDB.h>

@interface SDCategory () <WCTTableCoding, YYModel>

@end

@implementation SDCategory

WCDB_IMPLEMENTATION(SDCategory)

WCDB_SYNTHESIZE(SDCategory, categoryID)
WCDB_SYNTHESIZE(SDCategory, name)
WCDB_SYNTHESIZE(SDCategory, iconName)
WCDB_SYNTHESIZE(SDCategory, builtin)
WCDB_SYNTHESIZE(SDCategory, sortIndex)
WCDB_SYNTHESIZE(SDCategory, color)

WCDB_PRIMARY_AUTO_INCREMENT(SDCategory, categoryID)

#pragma mark -
#pragma mark YYModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"sortIndex": @"index" };
}

//- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
//    NSNumber *indexNum = dic[@"index"];
//    if (![indexNum isKindOfClass:[NSNumber class]]) {
//        return NO;
//    }
//    self.sortIndex = [indexNum integerValue];
//    return YES;
//}
//
//- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
//    dic[@"index"] = @(self.sortIndex);
//    return YES;
//}

@end
