//
//  SDItem.h
//  SDaccount
//
//  Created by SunLi on 2019/10/4.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDCategory.h"
#import "SDLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDItem : NSObject

@property (nonatomic, assign) NSInteger itemID;
@property (nonatomic, assign) NSInteger categoryID;
@property (nonatomic, assign) NSInteger locationID;
@property (nonatomic, assign) NSInteger sortIndex;
@property (nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
