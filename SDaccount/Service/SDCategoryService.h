//
//  SDCategoryService.h
//  SDaccount
//
//  Created by SunLi on 2019/9/29.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDCategoryService : NSObject

@property (nonatomic, strong, readonly) NSArray<SDCategory *> *categoryList;

+ (instancetype)service;

- (SDCategory *)queryCategoryWithName:(NSString *)categoryName;
- (void)addCustomCategoryWithName:(NSString *)categoryName;
- (NSArray<SDCategory *> *)fetchCustomCategory;

@end

NS_ASSUME_NONNULL_END
