//
//  SDThemeManager.h
//  SDaccount
//
//  Created by SunLi on 2019/9/27.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDThemeProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDThemeManager : NSObject

@property (nonatomic, strong, readonly) NSArray<id<SDThemeProtocol> > *themeList;
@property (nonatomic, strong) id<SDThemeProtocol> currentTheme;

+ (instancetype)manager;
- (void)setup;

@end

NS_ASSUME_NONNULL_END
