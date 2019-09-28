//
//  SDThemeProtocol.h
//  SDaccount
//
//  Created by SunLi on 2019/9/27.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDThemeProtocol <NSObject>

@required
- (NSString *)themeColor;
- (NSString *)backgroundColor;
- (NSString *)textColor;
- (NSString *)themeColor_lighten5;
- (NSString *)themeColor_darken2;

- (NSString *)assetSuffix;

- (NSString *)themeName;
- (NSArray *)themeScreenShots;

@end

NS_ASSUME_NONNULL_END
