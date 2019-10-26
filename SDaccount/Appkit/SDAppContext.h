//
//  SDAppContext.h
//  SDaccount
//
//  Created by SunLi on 2019/10/22.
//  Copyright © 2019 PacmanSun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AppContext [SDAppContext context]

NS_ASSUME_NONNULL_BEGIN

@interface SDAppContext : NSObject

@property (nonatomic, assign) BOOL autoPresentAddItemTab;

+ (instancetype)context;

- (void)startupflow;

@end

NS_ASSUME_NONNULL_END
