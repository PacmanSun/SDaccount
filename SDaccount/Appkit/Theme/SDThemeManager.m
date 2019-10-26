//
//  SDThemeManager.m
//  SDaccount
//
//  Created by SunLi on 2019/9/27.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDThemeManager.h"
#import "SDThemeDefault.h"
#import "SDThemeGreen.h"
#import "SDThemeBlue.h"
#import "SDThemeRed.h"
#import "SDThemePurple.h"

@interface SDThemeManager ()

- (instancetype)initManager;

@end

@implementation SDThemeManager

+ (instancetype)sharedManager {
    static SDThemeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]initManager];
    });
    return manager;
}

- (instancetype)initManager {
    self = [super init];
    if (self) {
        SDThemeDefault *defaultTheme = [[SDThemeDefault alloc]init];
        SDThemeGreen *greenTheme = [[SDThemeGreen alloc]init];
        SDThemeBlue *blueTheme = [[SDThemeBlue alloc]init];
        SDThemeRed *redTheme = [[SDThemeRed alloc]init];
        SDThemePurple *purpleTheme = [[SDThemePurple alloc]init];
        _themeList = @[defaultTheme, greenTheme, blueTheme, redTheme, purpleTheme];
    }
    return self;
}

- (void)setup {
    NSString *userTheme = [KeyValueStore stringForKey:@"SDThemeName"];
    if (!SDIsEmptyString(userTheme)) {
        for (id<SDThemeProtocol > theme in self.themeList) {
            if (SDIsEqualString(theme.themeName, userTheme)) {
                self.currentTheme = theme;
                return;
            }
        }
    }
    //use Default
    self.currentTheme = [self.themeList firstObject];
}

- (void)setCurrentTheme:(id<SDThemeProtocol>)currentTheme {
    if (_currentTheme == currentTheme) {
        return;
    }
    _currentTheme = currentTheme;
    [QMUIConfigurationTemplate setupConfigurationTemplate];
    [KeyValueStore setString:currentTheme.themeName forKey:@"SDThemeName"];
    [[NSNotificationCenter defaultCenter]postNotificationName:SDThemeDidUpdateNotification object:nil];
}

@end
