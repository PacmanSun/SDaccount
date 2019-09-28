//
//  Macro.h
//  SDaccount
//
//  Created by SunLi on 2019/9/9.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#import <UIKit/UIKit.h>
#import "SDThemeManager.h"
#import "SDUtil.h"

#define SD_THEME_COLOR [SDThemeManager manager].currentTheme.themeColor
#define SD_THEME_COLOR_LIGHTEN5 [SDThemeManager manager].currentTheme.themeColor_lighten5
#define SD_THEME_COLOR_DARKEN2 [SDThemeManager manager].currentTheme.themeColor_darken2
#define SD_BG_GRAY [SDThemeManager manager].currentTheme.backgroundColor
#define SD_TEXT_COLOR_BLACK [SDThemeManager manager].currentTheme.textColor

#define SD_TEXT_COLOR_BLACK_DARKEN @"#424242"
#define SD_TEXT_COLOR_BLACK_LIGHTEN @"757575"

#define SDThemeImageMake(imgName) [SDUtil themeImageMake:imgName]

#define SD_MARGIN (20.0f)

#define SDOnePixel CGFloatFromPixel(1.0f)

#define SD_TIPS_SHOWTIME (0.45)

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#ifdef DEBUG
#define SDLog(...) NSLog((@"%@"), [NSString stringWithFormat:__VA_ARGS__])
#else
#define SDLog(...)
#endif

#define SDIsEmptyString(str) (!(str && [str isKindOfClass:NSString.class] && str.length > 0))
#define SDIsEmptyArray(arr) (!(arr && [arr isKindOfClass:NSArray.class] && arr.count > 0))
#define SDIsEmptyDictionary(dict) (!(dict && [dict isKindOfClass:NSDictionary.class] && dict.allKeys > 0))
#define SDIsEqualString(str1, str2) ([str1 isEqualToString:str2])

#define SDApplication [UIApplication sharedApplication]
#define SDDevice [UIDevice currentDevice]
#define SDUserDefaults [NSUserDefaults standardUserDefaults]
#define SDNotifiSDionCenter [NSNotificationCenter defaultCenter]
#define SDKeyWindow [UIApplication sharedApplication].keyWindow

#endif /* Macro_h */
