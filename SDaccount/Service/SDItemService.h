//
//  SDItemService.h
//  SDaccount
//
//  Created by SunLi on 2019/10/4.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDItemService : NSObject

@property (nonatomic, strong, readonly) NSArray<SDItem *> *itemList;

+ (instancetype)service;

- (SDItem *)queryItemWithName:(NSString *)itemName;
- (void)addItemWithName:(NSString *)itemName ofCategory:(NSInteger)categoryID inLocation:(NSInteger)locationID;
- (NSArray<SDItem *> *)fetchItems;

@end

NS_ASSUME_NONNULL_END
