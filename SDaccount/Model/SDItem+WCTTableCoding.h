//
//  SDItem+WCTTableCoding.h
//  SDaccount
//
//  Created by SunLi on 2019/10/4.
//  Copyright © 2019 PacmanSun. All rights reserved.
//


#import "SDItem.h"
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDItem (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(itemID)
WCDB_PROPERTY(categoryID)
WCDB_PROPERTY(locationID)
WCDB_PROPERTY(sortIndex)
WCDB_PROPERTY(name)

@end

NS_ASSUME_NONNULL_END
