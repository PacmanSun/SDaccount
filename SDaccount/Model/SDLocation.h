//
//  SDLocation.h
//  SDaccount
//
//  Created by SunLi on 2019/10/4.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLocation : NSObject

@property (nonatomic, assign) NSInteger locationID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, assign) NSInteger builtin;
@property (nonatomic, assign) NSInteger sortIndex;
@property (nonatomic, strong) NSString *color;

@end

NS_ASSUME_NONNULL_END
