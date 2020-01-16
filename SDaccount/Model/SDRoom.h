//
//  SDRoom.h
//  SDaccount
//
//  Created by SunLi on 2019/10/31.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDRoom : NSObject

@property (nonatomic, assign) NSInteger roomID;
@property (nonatomic, assign) NSInteger addressID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, assign) NSInteger builtin;
@property (nonatomic, assign) NSInteger sortIndex;
@property (nonatomic, strong) NSString *color;

//non-store
@property (nonatomic, strong) NSMutableArray<SDLocation *> *locationList;
@property (nonatomic, strong) NSMutableDictionary<NSString *, SDLocation *> *locationMap;

@end

NS_ASSUME_NONNULL_END
