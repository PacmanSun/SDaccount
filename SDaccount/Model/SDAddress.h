//
//  SDAddress.h
//  SDaccount
//
//  Created by SunLi on 2019/11/1.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDRoom.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDAddress : NSObject

@property (nonatomic, assign) NSInteger addressID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, assign) NSInteger builtin;
@property (nonatomic, assign) NSInteger sortIndex;
@property (nonatomic, strong) NSString *color;

//non-store
@property (nonatomic, strong) NSMutableArray<SDRoom *> *roomList;
@property (nonatomic, strong) NSMutableDictionary<NSString *, SDRoom *> *roomMap;

@end

NS_ASSUME_NONNULL_END
