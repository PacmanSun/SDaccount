//
//  SDThemeRed.m
//  SDaccount
//
//  Created by SunLi on 2019/9/28.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDThemeRed.h"

@implementation SDThemeRed

- (nonnull NSString *)assetSuffix { 
    return @"_red_t";
}

- (nonnull NSString *)backgroundColor { 
    return @"#fafafa";
}

- (nonnull NSString *)textColor { 
    return @"#616161";
}

- (nonnull NSString *)themeColor { 
    return @"#da2864";
}

- (nonnull NSString *)themeColor_darken2 { 
    return @"b92456";
}

- (nonnull NSString *)themeColor_lighten5 { 
    return @"#f52e71";
}

- (nonnull NSString *)themeName { 
    return @"红色";
}

- (nonnull NSArray *)themeScreenShots { 
    return @[@"red_home",@"red_more"];
}

@end
