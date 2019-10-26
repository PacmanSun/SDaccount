//
//  SDThemeDefault.m
//  SDaccount
//
//  Created by SunLi on 2019/9/28.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDThemeDefault.h"

@implementation SDThemeDefault

- (nonnull NSString *)assetSuffix {
    return @"_yellow_t";
}

- (nonnull NSString *)backgroundColor {
    return @"#fafafa";
}

- (nonnull NSString *)textColor {
    return @"#616161";
}

- (nonnull NSString *)themeColor {
    return @"#ffc107";
}

- (nonnull NSString *)themeColor_darken2 {
    return @"ffa000";
}

- (nonnull NSString *)themeColor_lighten5 {
    return @"fff8e1";
}

- (nonnull NSString *)themeName {
    return @"橙色";
}

- (nonnull NSArray *)themeScreenShots {
    return @[@"default_home",@"default_more"];
}

@end
