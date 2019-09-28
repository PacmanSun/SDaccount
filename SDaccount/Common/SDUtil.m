//
//  SDUtil.m
//  SDaccount
//
//  Created by SunLi on 2019/9/9.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDUtil.h"

@implementation SDUtil

+ (NSNumberFormatter *)numberFormatter {
    static NSNumberFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc]init];
        formatter.maximumFractionDigits = 2;
        formatter.minimumFractionDigits = 0;
    });
    return formatter;
}

+ (NSString *)formattedNumberString:(id)numberValue {
    if ([numberValue isKindOfClass:[NSNumber class]]) {
        return [[self numberFormatter]stringFromNumber:numberValue];
    } else if ([numberValue isKindOfClass:[NSString class]]) {
        return [[self numberFormatter]stringFromNumber:@([numberValue doubleValue])];
    }
    return nil;
}

+ (UIImage *)themeImageMake:(NSString *)imageName {
    id<SDThemeProtocol> theme = [SDThemeManager manager].currentTheme;
    NSString *imgName = [NSString stringWithFormat:@"%@%@", imageName, [theme assetSuffix]];
    return UIImageMake(imgName);
}

+ (void)getNextMonthWithCurYear:(NSInteger)year month:(NSInteger)month result:(SDTimeUtilHandler)result {
    [self getNextMonthWithCurYear:year month:month nextYear:&year nextMonth:&month];
    NSDate *now = [NSDate date];
    BOOL haveNext = YES;
    if (now.year == year && now.month == month) {
        haveNext = NO;
    }
    if (result) {
        result(year, month, haveNext);
    }
}

+ (void)getPrevMonthWithCurYear:(NSInteger)year month:(NSInteger)month result:(SDTimeUtilHandler)result {
    [self getPrevMonthWithCurYear:year month:month prevYear:&year prevMonth:&month];
    NSDate *now = [NSDate date];
    BOOL haveNext = YES;
    if (now.year == year && now.month == month) {
        haveNext = NO;
    }
    if (result) {
        result(year, month, haveNext);
    }
}

+ (void)getNextMonthWithCurYear:(NSInteger)year month:(NSInteger)month nextYear:(NSInteger *)nextYear nextMonth:(NSInteger *)nextMonth {
    if (month == 12) {
        year += 1;
        month = 1;
    } else {
        month += 1;
    }
    *nextYear = year;
    *nextMonth = month;
}

+ (void)getPrevMonthWithCurYear:(NSInteger)year month:(NSInteger)month prevYear:(NSInteger *)prevYear prevMonth:(NSInteger *)prevMonth {
    if (month == 1) {
        year -= 1;
        month = 12;
    } else {
        month -= 1;
    }
    *prevYear = year;
    *prevMonth = month;
}

@end
