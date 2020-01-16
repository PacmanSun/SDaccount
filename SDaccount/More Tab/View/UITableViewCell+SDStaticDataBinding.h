//
//  UITableViewCell+SDStaticDataBinding.h
//  SDaccount
//
//  Created by SunLi on 2019/10/26.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDStaticTableCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (SDStaticDataBinding)
- (void)sd_bindStaticData:(SDStaticTableCellData *)staticCellData;
@end

NS_ASSUME_NONNULL_END
