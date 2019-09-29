//
//  SDUtil.h
//  SDaccount
//
//  Created by SunLi on 2019/9/9.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SDTimeUtilHandler)(NSInteger year, NSInteger month, BOOL haveNext);

NS_ASSUME_NONNULL_BEGIN

@interface SDUtil : NSObject

+ (NSNumberFormatter *)numberFormatter;
+ (nullable NSString *)formattedNumberString:(id)numberValue;

+ (UIImage *)themeImageMake:(NSString *)imageName;

+ (void)getNextMonthWithCurYear:(NSInteger)year month:(NSInteger)month result:(SDTimeUtilHandler)result;
+ (void)getPrevMonthWithCurYear:(NSInteger)year month:(NSInteger)month result:(SDTimeUtilHandler)result;
+ (void)getNextMonthWithCurYear:(NSInteger)year month:(NSInteger)month nextYear:(NSInteger *)nextYear nextMonth:(NSInteger *)nextMonth;
+ (void)getPrevMonthWithCurYear:(NSInteger)year month:(NSInteger)month prevYear:(NSInteger *)prevYear prevMonth:(NSInteger *)prevMonth;

@end

NS_ASSUME_NONNULL_END
