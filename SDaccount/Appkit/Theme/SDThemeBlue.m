//
//  SDThemeBlue.m
//  SDaccount
//
//  Created by SunLi on 2019/9/28.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDThemeBlue.h"

@implementation SDThemeBlue

- (nonnull NSString *)assetSuffix {
    return @"_blue_t";
}

- (nonnull NSString *)backgroundColor {
    return @"#fafafa";
}

- (nonnull NSString *)textColor {
    return @"#616161";
}

- (nonnull NSString *)themeColor {
    return @"#33539E";
}

- (nonnull NSString *)themeColor_darken2 {
    return @"#26407D";
}

- (nonnull NSString *)themeColor_lighten5 {
    return @"#3c62bb";
}

- (nonnull NSString *)themeName {
    return @"蓝色";
}

- (nonnull NSArray *)themeScreenShots {
    return @[@"blue_home",@"blue_more"];
}

@end
