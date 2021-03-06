//
//  SDLocation.h
//  SDaccount
//
//  Created by SunLi on 2019/10/4.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SDItem;

@interface SDLocation : NSObject

@property (nonatomic, assign) NSInteger locationID;
@property (nonatomic, assign) NSInteger roomID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, assign) NSInteger builtin;
@property (nonatomic, assign) NSInteger sortIndex;
@property (nonatomic, strong) NSString *color;

//non-store
@property (nonatomic, strong) NSMutableArray<SDItem *> *itemList;
@property (nonatomic, strong) NSMutableDictionary<NSString *, SDItem *> *itemMap;

@end

NS_ASSUME_NONNULL_END
