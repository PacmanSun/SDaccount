//
//  SDThemeTableViewCell.h
//  SDaccount
//
//  Created by SunLi on 2019/10/26.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
#import "SDThemeProtocol.h"

#define K_ThemeCellHeight 385

NS_ASSUME_NONNULL_BEGIN

@interface SDThemeTableViewCell : QMUITableViewCell

- (void)bindTheme:(id<SDThemeProtocol>)theme;
- (void)setChecked:(BOOL)checked animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
