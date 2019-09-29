//
//  SDCategory+WCTTableCoding.h
//  SDaccount
//
//  Created by SunLi on 2019/9/29.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDCategory.h"
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDCategory (WCTTableCoding)<WCTTableCoding>

WCDB_PROPERTY(categoryID)
WCDB_PROPERTY(name)
WCDB_PROPERTY(iconName)
WCDB_PROPERTY(builtin)
WCDB_PROPERTY(sortIndex)
WCDB_PROPERTY(color)

@end

NS_ASSUME_NONNULL_END
