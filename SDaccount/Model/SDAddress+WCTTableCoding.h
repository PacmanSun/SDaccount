//
//  SDAddress+WCTTableCoding.h
//  SDaccount
//
//  Created by SunLi on 2019/11/2.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import "SDAddress.h"
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDAddress (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(addressID)
WCDB_PROPERTY(name)
WCDB_PROPERTY(iconName)
WCDB_PROPERTY(builtin)
WCDB_PROPERTY(sortIndex)
WCDB_PROPERTY(color)

@end

NS_ASSUME_NONNULL_END
