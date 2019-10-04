//
//  SDLocation+WCTTableCoding.h
//  SDaccount
//
//  Created by SunLi on 2019/10/4.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDLocation.h"
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLocation (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(locationID)
WCDB_PROPERTY(name)
WCDB_PROPERTY(iconName)
WCDB_PROPERTY(builtin)
WCDB_PROPERTY(sortIndex)
WCDB_PROPERTY(color)

@end

NS_ASSUME_NONNULL_END
